#R Course Fall 2022


#What is R and RStudio? 


#R is a programming language and software, particularly apt for statistical
#calculations and data visualization. 


#RStudio: An IDE (integrated development environment)
#for R. 


#R Studio: interface. 


#File -> Open a new R Script

#View -> Decide pane layout 

#Session -> Setting working directory - NB. Not to select file, but folder 
#to work in (that comprises files to analyze in R). 


#Code and comments 


#Installing and loading the packages we need: 

library(stats) #R is distributed with the Stats package, so we only need
#to load it. 

#The three other packages we are going to use have to be installed the
#first time you use them: 

#install.packages("<package name>") 

#install.packages("readxl") #Remove the hashtag at the start of these three 
#install.packages("ggplot2") #lines and run each one of them.
#install.packages("MASS") #When done, put the hasthags back again so you
#won't install them each time, which is unnecessary and takes time. 

#Now, load these libraries. This must be done each time when working in a 
#new script or if you have closed and reopened RStudio. 


library(readxl)
library(ggplot2)
library(MASS)




#With the library(MASS) we get access to a dataset called survey comprising
#a set of information of a group of Australian students. 


#1.BUILT-IN FUNCTIONS

head(survey) #Inspect the first lines of the dataset

names(survey) #The names of the objects 

summary(survey)#get statistics - Note that the summary function is written
#with a small s



#2.Inspect, select and manipulate one column in your dataset 

summary(survey$Pulse) #use dollar sign to access one variable


#Let's look into the relation between pulse and sex: 

#First we attach the dataset so we can type the variables only:

attach(survey)


#3.vISUALIZE DATA USING BOXPLOT. 
#Create a boxplot to examine the relation between pulse and sex

boxplot(Pulse~Sex)


#4.Give your plot color and title:

boxplot(Pulse~Sex, col = (c("green", "pink")), main = "Boxplot")




#Exercise 1.
#A.Inspect the height and sex variables using the summary() function.
#B.inspect the relation between height and sex by creating a boxplot. 
#C.Color your boxplot and give it a title. 





summary(Sex)
summary(Height)

summary(Height~Sex)
plot(Height~Sex, col = (c("blue", "grey")))


#5.SAVE SCRIPT

#Go to "file" -> "Save as" 




#New dataset: CRSP_index_monthly (distributed to course participants). 
#Also available here: https://github.com/bisentralen/Files. Download it to
#your computer and go to 'Session' in the top menu in RStudio -> set working
#directory -> choose directory.Choose the folder where the downloaded file 
#is saved, normally your 'downloads' folder.)



#6.READ FILES ON YOUR COMPUTER

read_xlsx("CRSP_index_monthly.xlsx") 

#If you have set the working directory to the folder where this file is 
#saved, you only need to start typing its name. Then use the tab key to 
#select the file. NB. You need simple or double quotation marks. 



#7.VARIABLES/OBJECTS

CRSP <- read_xlsx("CRSP_index_monthly.xlsx") #We store the file in a variable
#so we don't have to type the entire command each time. 


summary(CRSP)

head(CRSP,20)


class(CRSP$`Value-Weighted Return-incl. dividends`)




#8.VISUALIZE THE DATA USING A _HISTOGRAM_. 

#Use the dollar sign to select the variable to visualize

hist(CRSP$`Value-Weighted Return-incl. dividends`)



hist(CRSP$`Value-Weighted Return-incl. dividends`, col = "green", 
     main = "Histogram")





#Exercise 2.
#A.Store the column 'date of observation' in a variable. 
#B.Inspect the data you have stored using the head(), summary() and class() functions. 



CRSP_dates <- CRSP$`Date of Observation`


head(CRSP_dates)
summary(CRSP_dates)
class(CRSP_dates)




#9.MANIPULATE THE DATE FORMAT 

#Let's reexamine the 'date of observation' column

head(CRSP$`Date of Observation`, 20)

#We have many years, let's see how we can study the stock market values per
#year, by grouping the values from each year and comparing them. 

#First we create a new variable and store 'date of observation only'. You 
#can use the one you created previously. We can use the format function 
#to change the date format:

years <- format(CRSP$`Date of Observation`, "%Y")

head(years)


#10.AGGREGATE DATA USING THE STATS LIBRARY 

#Group the observations from each year and calculate mean with the 
#'aggregate' function from 'stats'. 

CRSP_years <- aggregate(CRSP$`Value-Weighted Return-incl. dividends`, 
                        by = list(years), mean)

head(CRSP_years) #Pay attention to the names of the columns, necessary to 
#visualize the data.



#11.VISUALIZE DATA USING THE LIBRARY GGPLOT


ggplot(CRSP_years, aes(x= x, y = Group.1))+
  geom_bar(stat= "identity")+
  labs(title = "Stock Market Values from 1925-2020", y = "Year", 
       x = "Values")


#Plot a selected period (here up until 1979)

ggplot(CRSP_years[which(CRSP_years$Group.1<=1979),], aes(x= x, y = Group.1))+
  geom_bar(stat= "identity")+
  labs(title = "Stock Market Values from 1925-1979", y = "Year", 
       x = "Values")






#Exercise 3.
#Create a barplot for the CRSP data using the library GGPlot. Plot the data
#from 1980 to 2020. 





ggplot(CRSP_years[which(CRSP_years$Group.1>=1980),], aes(x= x, y = Group.1))+
  geom_bar(stat= "identity")+
  labs(title = "Stock Market Values from 1980-2020", y = "Year", 
       x = "Values")








