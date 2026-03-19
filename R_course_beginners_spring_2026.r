########## Beginners R Course ############

rm(list=ls())

### Intro:
# - What is R and R-studio?
# - Explain scripts, console, environment
# - Explain Environment objects
# - Show how to change theme and colours 
# - Explain commenting out sections and headlines

# Files
# https://github.com/bisentralen/Files/blob/main/capm.xlsx
# https://github.com/bisentralen/Files/blob/main/data_ceo.csv





###############       Chapter 1 - Objects       #############


### 1.1. - Making a variable ###

super_cool_variable = 135




### 1.2. - Common object classes ###

character = "text"

numeric = 1

vector = c(1 ,2, 3)

logical = TRUE

vector_of_characters = c("Hello", "Bye")



### 1.3. - Checking the class of an object ###

class(super_cool_variable)  # Using the class() function 





### 1.4 - Cleaning ###

# Removing all existing variables in the environment
rm(list=ls())







#############    Chapter 2 - Loading Data    ################

# Set working directory 
setwd("~/Datasett") # Copy this from console



# Saving the script

# File -> Save As...
# ctrl + s    /      (cmd + s) on mac 






### 2.1 - Loading CSV ###

# Reading the file
ceo_data = read.csv("data_ceo.csv")

#Viewing the file
View(ceo_data)

# Removing the file
rm(ceo_data)





### 2.2 - Loading Excel ###

# Installing necessary package to load excel files
# install.packages("readxl")

# Telling R to use this package
library(readxl)

# Reading the file
capm = read_excel("capm.xlsx", sheet = 1) 
# Do not need to use sheet = 1, if there's only one

# Looking at the file
View(capm)

# Removing the file
rm(capm)





### 2.3 - Loading Direct Financial Data Using Quantmod ###

# Installing the quantmod package
# install.packages("quantmod")


# Telling R to use this package
library(quantmod)

# Making a list of all the stocks you want to load
tickers =  c("AAPL", "TSLA")

# Collecting the stock data
getSymbols(tickers)

# Checking what type of variable it is
class(TSLA) # It's an xts object which is fine for us






################   Chapter 3 - Merging and Cleaning   ##############



### 3.1 - Merging the two stocks together ###

stock_data = merge(       # This merge works for xts objects
  TSLA[, "TSLA.Close"],   # Syntax: object[rows, columns]
  AAPL[, "AAPL.Close"], 
  join = "inner"          # inner / outer / left / right
)

View(stock_data) # Checking if it looks pretty


# Checking for NA-values that can create trouble 
sum(is.na(stock_data)) 

# If there is NAs:
stock_data = na.omit(stock_data) # Removes all NAs






### 3.2 - Adjusting the Time Window within an xts object ###

# Let's say we only want data from 2020 until today
stock_data = stock_data["2020/"]  # This only works with xts objects, not dataframes
# or...
stock_data = stock_data["2020-01-01/"] 


View(stock_data)





### 3.3 - Adjusting the Time Window within a dataframe ###

# Converting it into a dataframe
stock_data = as.data.frame(stock_data)

# Checking that everything went fine
class(stock_data) # should return "data.frame" in the console

# Making a subset with data from 2021 up until today 
# drop = FALSE is keeping the dimensions of the original dataframe
new_stock_data = stock_data[as.Date(rownames(stock_data)) >= as.Date("2021-01-01"), , drop = FALSE]
#or...
new_stock_data = stock_data[1:30, ] # Filtering on row 1 to 30, all columns
# The last one is helpful if the index is not the dates. 



View(new_stock_data)





### 3.4 - Adding and removing columns ###

# Let's just take the difference between the two stocks
new_stock_data$diff = new_stock_data$TSLA.Close - new_stock_data$AAPL.Close

View(new_stock_data) # looking at the new column 

# Removing the column 
new_stock_data$diff = NULL

View(new_stock_data) # Checking that it's gone 






##################  Chapter 4 - Plots  ####################


# We need to make a date column before plotting
new_stock_data$date = as.Date(rownames(new_stock_data)) # Making a new column


# Simple plot
plot(new_stock_data$date, new_stock_data$TSLA.Close) # plot(x-axis, y-axis)

# Adding type
plot(new_stock_data$date, new_stock_data$TSLA.Close, type = "l") # type = "l" for line

# Adding axis labels
plot(new_stock_data$date, new_stock_data$TSLA.Close, type = "l",
     xlab = "Year", ylab = "TSLA") # Changing axis names 

# Adding colour 
plot(new_stock_data$date, new_stock_data$TSLA.Close, type = "l",
     xlab = "Year", ylab = "TSLA",
     col = "blue") # Try to write any colour :) 





 




##################  Chapter 5 - Descriptive Statistics  ####################


# Mean
mean = mean(new_stock_data$TSLA.Close)
print(paste("The mean is", mean))


# Variance
var = var(new_stock_data$TSLA.Close)
print(paste("The variance is", var))


# Standard deviation
st_dev = sd(new_stock_data$TSLA.Close)
print(paste(" The standard deviation is", st_dev))


# Covariance
cov = cov(new_stock_data$TSLA.Close, new_stock_data$AAPL.Close)
print(paste("The covariance between TSLA and AAPL is", cov))


# Correlation
corr = cor(new_stock_data$TSLA.Close, new_stock_data$AAPL.Close)
print(paste("The correlation between TSLA and AAPL is", corr))











################  Chapter 6 - Simple Regression Analysis  ################


# Look at the relationship
plot(new_stock_data$TSLA.Close, new_stock_data$AAPL.Close,
     xlab = "TSLA", ylab = "AAPL")


# Check their linear dependence through regression
model = lm(AAPL.Close ~ TSLA.Close, data = new_stock_data) # Regression model


# Adding the regression line to the plot
abline(model, col = "blue")


# Checking the stats
summary(model)



