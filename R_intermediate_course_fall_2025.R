########## Beautiful Pretty Intermediate R Course ############

# Housekeepin
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




### Let's try to transform the stock prices to price changes
log_stock_data = log(stock_data) # Taking logs of all the prices
plot(log_stock_data, legend.loc = "topleft") # Looks better, but still not so intuitive




### Let's try to index all at the same starting point AND use price changes
first_row = as.numeric(stock_data[1, ]) # extracting the first row as a list

# Using the first row to index everything (notice the t() for transposing...)
indexed_stock_data = log(t(t(stock_data[-1, ]) / first_row)) # and taking logs

# Changing if back from dataframe to xts for simplicity
indexed_stock_data = xts::xts(indexed_stock_data, order.by = index(stock_data[-1,]))
plot(indexed_stock_data, legend.loc = "topleft") #Looking much more comparable









#############     Chapter 3 - Making Portfolios     #############


### Making a cutesy portfolio of our stocks 

weights = c(0.25, 0.25, 0.25, 0.25) # The weight of each stock

# We could do e.g. a value (size) weighted portfolio, but we're too lazy to get 
# the data for that today. 

# Notice the t() here for transpose again
portfolio = (t(t(stock_data) * weights))

portfolio_returns = rowSums(portfolio) # row sums gives the sum for each row

#converting it to xts object for neat plotting
portfolio_returns = xts::xts(portfolio_returns, order.by = index(stock_data))
plot(portfolio_returns)







### Comparing our cutesy portfolio to the benchmark

# Loading in our benchmark the quantmod way
benchmark = Ad(getSymbols("QQQ", src = "yahoo", auto.assign = FALSE,
                          from = start_date, 
                          to = end_date))

# merging our benchmark with our portfolio
portfolio_returns = merge(portfolio_returns, benchmark, 
                     join = "inner") 

# Making them start the same place again 
first_row = as.numeric(portfolio_returns[1, ])
portfolio_returns_indexed = t(t(portfolio_returns[-1,]) / first_row)
portfolio_returns_indexed = xts::xts(portfolio_returns_indexed,
                                     order.by = index(stock_data[-1,]))


plot(portfolio_returns_indexed, legend.loc = "topleft")









#####################    Chapter 4 -  Stats and Metrics    ####################




# Correlation should be the same in the indexed and non-indexed data:
portfolio_correlation = cor(portfolio_returns_indexed$portfolio_returns, 
                            portfolio_returns_indexed$QQQ.Adjusted)

portfolio_correlation2 = cor(portfolio_returns$portfolio_returns, 
                            portfolio_returns$QQQ.Adjusted)









### Sharpe Ratio


# In short: The Sharpe Ratio gives you a number on how good your portfolio's
# risk adjusted return is. 

days = 252 # Open days in a year
rf = 0.05 # Just picking a number (can be imported if you want)
rf_daily = (1+rf)^(1/days) - 1

# Computing daily returns in %,instead of prices using ROC (from quantmod)
# This will make the first row NA, therefore we use na.omit
returns = na.omit(ROC(portfolio_returns, type = "discrete")) # Discrete gives % returns

excess_returns = returns - rf_daily

annual_sharpe_ratio = sqrt(days) * mean(excess_returns$portfolio_returns) /
                                  sd(excess_returns$portfolio_returns)





###### Sortino Ratio


# The same as Sharpe, but only with the portfolio's downside deviation. 
# Here we'll use the risk free rate (rf) as target return. 
downside_deviation = sqrt(mean(pmin(excess_returns$portfolio_returns, 0)^2))

annual_sortino_ratio = sqrt(days) * mean(excess_returns$portfolio_returns) /
                                    downside_deviation



###### Tracking error

# The volatility of a portfolio???s performance relative to its benchmark. 

# Computing how much over (under) the benchmark our returns are
active_return = returns$portfolio_returns - returns$QQQ.Adjusted

tracking_error = sd(active_return)

annual_tracking_error = tracking_error * sqrt(days)




##### Information Ratio

# How efficiently and consistently the portfolio outperforms the benchmark (higher = better).
annual_information_ratio = sqrt(days) * mean(active_return) / tracking_error









########### Making a Table ############


# Collecting all variables in the environment that starts with "annual_"
variables = ls(pattern = "annual_") 

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






























