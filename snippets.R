# R script for testing simple stuff

# Defining three numerical vectors
a <- c(1, 3.4, 2.3, 5.1)
b <- c(0.1, 13.4, 12.3, 5.1)
w <- c(1, 1, 2, 1)


# Mean of values in a
mean(a)


# Standard deviation of values in a
sd(a)


# Weighted mean of a, using weights in w
weighted.mean(a, w)


# Defining a vector c, as a and b put together
c <- append(a, b)

