########## Intermediate R Course ############

# Cleaning the environment
rm(list=ls())









###################    Chapter 1 -  Loops    ##################



#### Importing some cool financial data
library(quantmod)



stock_data = NULL # Empty object

tickers = c("AAPL", "TSLA", "MSFT", "NVDA") # Choose your own tickers

start_date = as.Date("01-01-2015", format = "%d-%m-%Y") # Use format to be sure it works
end_date = as.Date("01-01-2020", format = "%d-%m-%Y")



for (ticker in tickers) {
  
  # Ad collects the adjusted close
  stocks = Ad(getSymbols(ticker, 
                         from = start_date,
                         to = end_date,
                         auto.assign = FALSE)) # Auto.assign decides if the 
                                               # variables get returned as a list 
                                               # or as variables. 
  colnames(stocks) = ticker # Assigning the tickers as column names
  stock_data = cbind(stock_data, stocks) # Putting the adj.close columns to a dataframe

}

rm(stocks, ticker, tickers) # Cleaning










############ Chapter 2 - Explorative Plotting ##########


### Plotting the prices as they are
plot(stock_data, legend.loc = "topleft") # Ok looks nice, but not that intuitive




### Let's try to transform the stock prices to logarithms
# This will show percentage changes as more similar 
log_stock_data = log(stock_data) # Taking logs of all the prices
plot(log_stock_data, legend.loc = "topleft") # Still not so intuitive




### Let's try to index all at the same starting point AND use logs
first_row = as.numeric(stock_data[1, ]) # extracting the first row as a list

# Using the first row to index everything
# Sweep is a vector function. It's target matrix is stock_data (minus the first row)
# ,doing the operation columnwise (the 2 input), and its the first_row, 
# that is getting divided ("/")
indexed_stock_data = log(sweep(stock_data[-1, ], 2, first_row, "/"))# and taking logs

# Changing if back from dataframe to xts for simplicity
indexed_stock_data = xts::xts(indexed_stock_data, order.by = index(stock_data[-1,]))
plot(indexed_stock_data, legend.loc = "topleft") #Looking much more comparable


# cleaning
rm(indexed_stock_data, log_stock_data)







#############     Chapter 3 - Making Portfolios     #############


### Making a portfolio of our stocks 

# Equally weighted portfolio (buy and hold)
weights = c(0.25, 0.25, 0.25, 0.25) # The weight of each stock


# multiplying the stock values with our weights
# sweep is indexing the stock data to start at 1, like before, 
# just as a dataframe and without logs. 
portfolio = sweep(stock_data[-1, ], 2, first_row, "/") * weights

# Summing up to the stock_prices * weights to get the total portfolio value
portfolio_values = rowSums(portfolio) # row sums gives the sum for each row

# Showing the portfolio development in a graph
plot(portfolio_values * 100, type = "l", 
     xlab = "Time Index", ylab = "Portfolio Value in %")








### Comparing our portfolio to the benchmark

# Loading in our benchmark the quantmod way
# The QQQ - ticker is for the Nasdaq Exchange traded fund
benchmark = Ad(getSymbols("QQQ", src = "yahoo", auto.assign = FALSE,
                          from = start_date, 
                          to = end_date))

# indexing the benchmark to start at 1
benchmark_values = sweep(benchmark[-1,], 2, benchmark[1,], "/")

# Making into a dataframe so we can add a benchmark-column
portfolio_values = as.data.frame(portfolio_values)

# Adding the benchmark column 
portfolio_values$benchmark = as.numeric(benchmark_values)

# Plot
plot(portfolio_values[, 1] * 100, type = "l",                # our portfolio in black
     xlab = "Time Index", ylab = "Portfolio Value in %")
lines(portfolio_values[, 2] * 100, type = "l", col = "blue") # benchmark in blue


# Cleaning
rm(benchmark, benchmark_values, portfolio, start_date, 
   end_date, first_row, weights)








#####################    Chapter 4 -  Stats and Metrics    ####################




# Correlation should be the same in the indexed and non-indexed data:
portfolio_correlation = cor(portfolio_values$portfolio_values, 
                            portfolio_values$benchmark)

portfolio_correlation2 = cor(portfolio_values$portfolio_values, 
                             portfolio_values$benchmark)









### Sharpe Ratio


# In short: The Sharpe Ratio gives you a number on how good your portfolio's
# risk adjusted return is. 

days = 252 # Open days in a year
rf = 0.05 # Just picking a number (can be imported if you want)
rf_daily = rf  / days

# Computing daily returns in %,instead of price levels
          # everything except first row / everything except last row
returns = portfolio_values[-1,] / portfolio_values[-nrow(portfolio_values),] -1
# This is shifting the series and dividing

excess_returns = returns - rf_daily # subtracting the rf from both columns

annual_sharpe_ratio = sqrt(days) * mean(excess_returns$portfolio_values) /
                                   sd(excess_returns$portfolio_values)

# cleaning
rm(rf)



###### Sortino Ratio


# The same as Sharpe, but only with the portfolio's downside deviation. 
# Here we'll use the risk free rate (rf) as target return. 
downside_deviation = sqrt(mean(pmin(excess_returns$portfolio_values, 0)^2))

annual_sortino_ratio = sqrt(days) * mean(excess_returns$portfolio_values) /
                                    downside_deviation

# cleaning
rm(downside_deviation)





###### Tracking error

# The volatility of a portfolio's performance relative to its benchmark. 

# Computing how much over (under) the benchmark our returns are
active_return = returns$portfolio_values - returns$benchmark

tracking_error = sd(active_return)

annual_tracking_error = tracking_error * sqrt(days)





##### Information Ratio

# How efficiently and consistently the portfolio outperforms the benchmark (higher = better).
annual_information_ratio = sqrt(days) * mean(active_return) / tracking_error


rm(active_return, tracking_error)






########### Making a Table ############


# Collecting all variables in the environment that starts with "annual_"
variables = ls(pattern = "annual_") # Making it as a list

portfolio_table = stack(mget(variables))[, c("ind","values")]
names(portfolio_table) = c("metric", "value")
print(portfolio_table)










###################      Chapter 5 - IF-statements       ###################



#### Evaluating the metrics 

if (annual_sharpe_ratio > 0.8 && annual_sharpe_ratio < 2) {
  print("You're doing great!")
  
}  else if (annual_sharpe_ratio > 2) {
  print("Wow, let's gooooo!")
  
} else {
  print("Please quit and join the army.")
}










###################    Chapter 6 - Multiple Regression    ###################


# Regression equation:
# y = b0 + b1*x1 + b2*x2 + b3* x3



multiple_model = lm(TSLA ~ AAPL + MSFT + NVDA, data = stock_data)

summary(multiple_model)

# TSLA = 12.197 + 2.24 * AAPL - 0.098 * MSFT  + 1.35 * NVDA















