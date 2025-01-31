#________1.Getting started________



## In order to access WRDS, you'll need to have the Duo Mobile app installed on your smartphone for two-factor Authentification

## Instructions for setting up Duo:
## https://wrds-www.wharton.upenn.edu/pages/about/log-in-to-wrds-using-two-factor-authentication/


## You may access WRDS from the web, using RStudio Server, or from your computer, using RStudio. 
### This is a guide to using RStudio, from your computer


install.packages("RPostgres") #install the package RPostgres, which is the library allowing you to connect to WRDS data. Uncomment this line when installed.

#When the installation is complete, you need to close your R session and quit R Studio and then install configuration files:

## First configuration file: you need to create a .pgpass file. See the instructions for doing so on either Mac or Windows here: 
## - https://wrds-www.wharton.upenn.edu/pages/support/programming-wrds/programming-r/r-from-your-computer/#initial-setup-the-pgpass-pgpassconf-file
## - Remember to secure your file as specified if you are using Mac, using chmod: 'chmod 0600 ~/.pgpass'

## Second optional configuration file: Consider whether it would be practical for you to create an .Rprofile file (it's not mandatory):
# - https://wrds-www.wharton.upenn.edu/pages/support/programming-wrds/programming-r/r-from-your-computer/#initial-setup-the-rprofile-file.


#Welcome back to the guide - you should now have installed the RPostgres package and then created a .pg.pass file (and a .Rprofile file if you chose to)


library(RPostgres) #Now, load the RPostgres library 




#________2.Connecting to WRDS when above stages are executed________


## Connection code, which creates a connection to WRDS with all the necessary parameters and saves that connection as wrds:
wrds <-dbConnect(Postgres(),
                 host='wrds-pgdata.wharton.upenn.edu',
                 port=9737,
                 dbname='wrds',
                 sslmode='require',
                 user='your_username_in_wrds') #replace with your WRDS user name



## Check if the connection is successful
if (inherits(wrds, "PqConnection")) {
  message("Successfully connected to WRDS.")
} else {
  stop("Failed to connect to WRDS. Please check your credentials and network connection.")
}
## Using inherits(wrds, "PqConnection") checks whether the wrds object is an instance of the "PqConnection" class, 
## which is the class name for database connections created by the RPostgres package. 





#_______3.Learn how to navigate the metadata______


## WRDS data is organized by vendor (ex. crsp), referred to as a library, and datasets. Each library contains a number of 
## datasets (ex. msi in the library crsp), which contain the actual data in tabular format with column headers called variables. 




### Use this code to view the data libraries (schemas) available as WRDS:
res <- dbSendQuery(wrds, "select distinct table_schema
                   from information_schema.tables
                   where table_type ='VIEW'
                   order by table_schema")
### Explanation of the code above:

#### - We use the dbSendQuery()function, which uses the already-established wrds connection to prepare the SQL query string
#### and save the query in a variable we call 'res'.
#### - The SQL query selects unique schema names with 'select distinct table_schema' from a system table called 'information_schema.tables' 
#### that holds metadata of all tables in the database.
#### - We specify the table_type to "VIEW" using the "where" parameter.(This limits the retrieved schemas to those containing views and may exclude schemas that only have base tables)
#### - To get the libraries alphabetically listed, we use the 'order by' parameter.  



data <- dbFetch(res, n=-1) # The dbFetch() function fetches the data that results from running the query res against wrds and stores it in 
#a new variable we call data. n is an optional parameter to limit the number of returned records:n=-1 is the default and returns all 
#matching rows, whereas for instance n=10, returns the first 10 rows. This is a great way to test a SQL statement against a large dataset quickly.  
dbClearResult(res) # closes the connection, making you ready for a new query.
data # Wiew the data you have retrieved 




### Now let's determine the datasets within a given library - NB! Here 'crsp' (Center for Research in Security Prices) is used as an example. 
### Replace with the library of your interest
res <- dbSendQuery(wrds, "select distinct table_name
                   from information_schema.columns
                   where table_schema='crsp' 
                   order by table_name")
data <- dbFetch(res, n=-1)
dbClearResult(res)
data



### Next is to check the variables within your dataset of interest. NB. Here we use 'crsp' as library and 'msi' (Monthly Stock Indices) as dataset
res <- dbSendQuery(wrds, "select column_name
                   from information_schema.columns
                   where table_schema='crsp'
                   and table_name='msi'
                   order by column_name")
data <- dbFetch(res, n=-1)
dbClearResult(res)
data






#________4.Querying WRDS Data___________

res <- dbSendQuery(wrds, "SELECT * FROM crsp.msi") 
data <- dbFetch(res, n=10) #we limit the results to 10 records
dbClearResult(res)
data


#Congratulations! When you have come this far you have a solid base for querying WRDS data, you may search: 

## - by variable
## - by date 
## build sql strings with multiple criteria
## join data from separate datasets 
## and much more. See how to and examples:
## - https://wrds-www.wharton.upenn.edu/pages/support/programming-wrds/programming-r/advanced-topics-in-r/querying-wrds-data-r/
## - graphing data: https://wrds-www.wharton.upenn.edu/pages/support/programming-wrds/programming-r/advanced-topics-in-r/plots-graphs-r/ 



#A last example: 

res <- dbSendQuery(wrds, "select date,vwretd
                   from crsp.msi
                   where date between '2007-01-01'
                   and '2024-09-01'")
data <- dbFetch(res, n=-1)
dbClearResult(res)
data


#Now lets plot the data

library(ggplot2) # load the popular ggplot library library for data visualisations (install it or install/load tidyverse)

date <- as.Date(data$date) #We start by assuring that the 'date' column gets a date format ggplot can read correctly. 

## Use ggplot to create a line graph
ggplot(data, aes(y = vwretd, x = date))+
  geom_line(color = 'red')+
  labs(title = "CRSP - Monthly value-weighted returns including dividens - 2007-2023", x = "Date", y = "Monthly Return")

