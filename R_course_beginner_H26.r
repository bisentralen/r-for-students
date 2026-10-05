install.packages("readxl")
install.packages("dplyr")
install.packages("tidyverse")
install.packages("moments")
install.packages("quantmod")

library(readxl)
library(dplyr)
library(tidyverse)
library(moments)
library(quantmod)

########## Beginners R Course ############

### Intro:
# - What is R and RStudio?
# - Explain scripts, console and environment
# - Explain Environment objects
# - Show how to change theme and colours
# - Explain commenting out sections and headlines


###############       Chapter 1 - Objects       #############

### 1.1 - Making a variable ###

var1 <- 135

### 1.2 - Common object classes ###

character <- "text"
numeric <- 1
integer_example <- 2L
vector <- c(1, 2, 3)
logical <- TRUE
vector_of_characters <- c("Hello", "Bye")

class(integer_example)
class("2")
as.numeric("2")

### 1.3 - Checking the class of an object ###

class(var1)

### 1.3.1 - Vectors and operators ###

vector[1]
length(vector)
vector + 10
vector * c(2, 3, 4)
vector > 1
vector[vector > 1]

### Exercises - Chapter 1 ###
# 1. Create an object called my_age and check its class.
# 2. Check the class of "25", then convert it into a number.
# 3. Create my_vector containing 5, 10 and 15. Select its second element.


### 1.4 - Cleaning and setting the working directory ###

setwd("~/Desktop/r_course_begginer")


###############       Chapter 2 - Loading Data       #############

### 2.1 - Loading CSV data ###

sp500_data <- read.csv("SP500.csv")

View(sp500_data)
head(sp500_data)


rm(sp500_data)

### 2.2 - Loading Excel data ###

treasury_data <- read_excel("DGS10.xlsx", sheet = "Daily")

View(treasury_data)
head(treasury_data)

rm(treasury_data)

### 2.3 - Loading financial data using quantmod ###

tickers <- c("AAPL", "TSLA")
getSymbols(tickers, src = "yahoo")

class(TSLA)

### Exercises - Chapter 2 ###
# 1. Load SP500.csv again and look at it using View().
# 2. Check the class of AAPL and the length of tickers.



################   Chapter 3 - Merging and Cleaning   ##############

### 3.1 - Merging the two stocks together ###

stock_data <- merge(
  TSLA[, "TSLA.Close"],
  AAPL[, "AAPL.Close"],
  join = "inner"
)

View(stock_data)
sum(is.na(stock_data))

stock_data <- na.omit(stock_data)

### 3.2 - Adjusting the time window within an xts object ###

stock_data <- stock_data["2020/"]

View(stock_data)

### 3.3 - Adjusting the time window within a data frame ###

stock_data <- as.data.frame(stock_data)
class(stock_data)

new_stock_data <- stock_data[
  as.Date(rownames(stock_data)) >= as.Date("2021-01-01"),
  ,
  drop = FALSE
]

View(new_stock_data)

### 3.4 - Adding and removing columns ###

new_stock_data$diff <- new_stock_data$TSLA.Close - new_stock_data$AAPL.Close

View(new_stock_data)

new_stock_data$diff <- NULL

View(new_stock_data)

### Exercises - Chapter 3 ###
# 1. Create first_ten containing the first 10 rows of stock_data.
# 2. Add a column called ratio to first_ten: TSLA.Close divided by AAPL.Close.
# 3. Remove the ratio column again.


##################  Chapter 4 - Plots  ####################

new_stock_data$date <- as.Date(rownames(new_stock_data))

plot(new_stock_data$date, new_stock_data$TSLA.Close)

plot(new_stock_data$date, new_stock_data$TSLA.Close, type = "l")

plot(
  new_stock_data$date,
  new_stock_data$TSLA.Close,
  type = "l",
  xlab = "Year",
  ylab = "TSLA"
)

plot(
  new_stock_data$date,
  new_stock_data$TSLA.Close,
  type = "l",
  xlab = "Year",
  ylab = "TSLA",
  col = "blue"
)

### Exercises - Chapter 4 ###
# 1. Make a line plot for AAPL instead of TSLA. Change the y-axis label too.
# 2. Make the line red.



##################  Chapter 5 - Descriptive Statistics  ####################

mean_price <- mean(new_stock_data$TSLA.Close)
print(paste("The mean is", mean_price))

price_variance <- var(new_stock_data$TSLA.Close)
print(paste("The variance is", price_variance))

st_dev <- sd(new_stock_data$TSLA.Close)
print(paste("The standard deviation is", st_dev))

price_covariance <- cov(
  new_stock_data$TSLA.Close,
  new_stock_data$AAPL.Close
)
print(paste("The covariance between TSLA and AAPL is", price_covariance))

correlation <- cor(
  new_stock_data$TSLA.Close,
  new_stock_data$AAPL.Close
)
print(paste("The correlation between TSLA and AAPL is", correlation))

price_skewness <- skewness(new_stock_data$TSLA.Close)
print(paste("The skewness is", price_skewness))

### Exercises - Chapter 5 ###
# 1. Calculate the mean and standard deviation of AAPL.Close.
# 2. Which stock has the higher standard deviation of its price levels?


################  Chapter 6 - Simple Regression Analysis  ################

plot(
  new_stock_data$TSLA.Close,
  new_stock_data$AAPL.Close,
  xlab = "TSLA",
  ylab = "AAPL"
)

model <- lm(AAPL.Close ~ TSLA.Close, data = new_stock_data)

abline(model, col = "blue")
summary(model)

# This price-level example illustrates R syntax, not a causal relationship.
# Price-level standard deviations are not comparable measures of return risk.

### Exercises - Chapter 6 ###
# 1. In the output of summary(model), is the TSLA.Close coefficient positive
#    or negative? Does this match the slope of the line in the plot?
# 2. Redraw the scatterplot and add a red regression line.





