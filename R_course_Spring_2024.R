#R Introduction Course Spring 2024


#---- What is R and RStudio? ----


  #R is a programming language and software, particularly apt for statistical
#calculations and data visualization. 


  #RStudio: is an IDE (integrated development environment), a programming
#environment for R. 


#---- The R Studio interface ----

  #Open a new R Script (File->New File-> R Script or Ctrl+Shift+N)

  #Decide pane layout (View->Panes->Pane Layout)


#---- Setting working directory ----

  # (Session->Setting working directory->Choose Directory
#or setwd("<path to folder>")- NB! Not to select file, but folder to work in. 
 

#---- Code and Comments ---- 

  #To write comments to your code, start with #. 
  #In this script so far there are only comments. The First code line is 37. 



#---- Installing and loading packages ---- 

library(stats) #Use "Run" in the menu above (or Ctrl+enter) to load
#the stats package. R is distributed with the Stats package, so we only 
#need to load it. 

#The three other packages we are going to use have to be installed
#prior to first time usage. Remove the hastags and run them:

#install.packages("readxl") 
#install.packages("ggplot2") 
#install.packages("MASS") 

#When done, put the hasthags back again or delete these lines,
#as these packages now are installed.


#Now, load these libraries. This must be done each time when working in a 
#new script or if you have closed and reopened RStudio. 


library(readxl) #package to read excel files
library(ggplot2) #package for data visualisation 
library(MASS)#package which provides access to many datasets, including one
#called survey, with information about a group of Australian students.

#Many, many R packages exist. see CRAN https://cran.r-project.org/)



#---- BUILT-IN FUNCTIONS ----

#A function is a block of code which runs when it is called. Built-in functions
#are blocks of code already written for us, which run when we call the function

head(survey) #Inspect the first lines of the dataset

names(survey) #See the variables in the dataset

summary(survey)#get statistics - Note that the summary function is written
#with lowercase s



#---- INSPECT, SELECT AND MANIPULATE ONE COLUMN IN YOUR DATASET ----


summary(survey$Pulse) #use dollar sign to access one variable


#Let's look into the relation between pulse and gender. 
#First we attach the dataset so we can type the variables only:


attach(survey)



#---- VISUALIZE DATA USING BOXPLOT ----

#Create a boxplot to examine the relation between pulse and gender. 

boxplot(Pulse~Sex) #Tilde sign. For PC, try: Alt Gr + key next to Enter 
#Mac: Option(Alt) + key next to Enter. Or search the web for your OS and keyboard.


  # Give your plot color and title:

boxplot(Pulse~Sex, col = "green", main = "Boxplot")

boxplot(Pulse~Sex, col = (c("green", "pink")), main = "Boxplot")

#Regarding colors: Make a conscious choice of colors. Do we really need different colors 
#for the two "boxes" in this plot? If color codes are crucial to communicate
#your data, make sure they are easy to distinguish between (including being 
#color blindness friendly) and rational for the type of data in question. 



#---- Exercise 1----

#Inspect the height and sex variables using the summary() function.
#inspect the relation between height and sex by creating a boxplot. 
#Color your boxplot and give it a title. 







#Possible solution

summary(Sex)
summary(Height)

summary(Height~Sex)
plot(Height~Sex, col = (c("blue", "grey")))




#---- SAVE SCRIPT ---- 

#Go to "file" -> "Save as" - Important, as scripts are not always automatically saved





#---- READ FILES ON YOUR COMPUTER ----


#The dataset we are going to use: CRSP_index_monthly. Available here: https://github.com/bisentralen/Files. 
#Download it to your computer and go to 'Session' in the top menu in RStudio -> Set Working
#Directory -> Choose Directory. Choose the folder where the downloaded file 
#is saved, normally your 'downloads' folder.)


#This dataset: monthly returns on U.S. stock market index from 1925-2023. CRSP (Center for Research in Security Prices)
  #Retrieved from WARDS, Wharton University of Pennsylvania.
  #https://wrds-www.wharton.upenn.edu/pages/get-data/center-research-security-prices-crsp/


read_xlsx("CRSP_index_monthly.xlsx") #the readxl library.

#If you have set the working directory to the folder where this file is 
#saved, you only need to start typing its name. Then use the tab key to 
#select the file. NB. You need simple or double quotation marks. 




#---- VARIABLES/OBJECTS ----

#Variables in programming allow you to store values.The variable is a 
#sort of a container. You decide yourself the name of your variable. It should 
#be informative (or else you may get lost if your script becomes extensive)
#and short and easy to type.  


CRSP <- read_xlsx("CRSP_index_monthly.xlsx") #We store the file in a variable
#so we don't have to type the entire command each time. 


summary(CRSP)


head(CRSP,20)


class(CRSP$`Value-Weighted Return-incl. dividends`)#the class function 
#displays here the type of data of one of the variables in the dataset




#---- VISUALIZE THE DATA USING A _HISTOGRAM_ ---- 

#A histogram is a graph which displays the distribution of a variable (of numeric data) in a dataset

#Use the dollar sign to select the variable to visualize


hist(CRSP$`Value-Weighted Return-incl. dividends`)


  # Give your plot color and title:

hist(CRSP$`Value-Weighted Return-incl. dividends`, col = "green", 
     main = "Histogram")





#---- Exercise 2 ----

#Store the column 'date of observation' in a variable. 
#Inspect the data you have stored using the head(), summary() and class() functions. 







#Solution

CRSP_dates <- CRSP$`Date of Observation`


head(CRSP_dates)
summary(CRSP_dates)
class(CRSP_dates)




#---- MANIPULATE THE DATE FORMAT ----

#Let's reexamine the 'date of observation' column

head(CRSP$`Date of Observation`, 20)

#We have many observations, let's see how we can study the stock market values per
#year, by grouping the values from each year. 

#First we create a new variable and store 'date of observation' only. You 
#can use the one you created previously. We can use the 'format()' function 
#to change the date format:

years <- format(CRSP_dates, "%Y")

head(years)


#---- AGGREGATE DATA USING THE STATS LIBRARY ----

#Group the observations from each year and calculate mean with the 
#'aggregate' function from 'stats'. 


CRSP_years <- aggregate(CRSP$`Value-Weighted Return-incl. dividends`, 
                        by = list(years), mean)



head(CRSP_years) #Pay attention to the names of the columns. They are needed to 
#visualize the data in the next session.



#---- VISUALIZE DATA USING THE LIBRARY GGPLOT ----


#GGplot is a popular library for visualizing data. You can read and learn more about it here: https://ggplot2.tidyverse.org/

ggplot(CRSP_years, aes(x= x, y = Group.1))+ #x and Group.1 are the names automatically assigned to the variables created by the aggregate function above
  geom_bar(stat= "identity")+ #we choose a bar chart by specifying geom_bar. The 'stat = identity' argument lets us display the specific sum of values for one particular variable,grouped by another (here the stock market values (x), are grouped by year (y))
  labs(title = "Stock Market Values from 1925-2023", y = "Year", 
       x = "Values") #Add labels to the axes and a title for the plot using labs(). 


#Plot a selected period (here up until 1979) with 'which[]'

ggplot(CRSP_years[which(CRSP_years$Group.1<=1979),], aes(x= x, y = Group.1))+
  geom_bar(stat= "identity")+
  labs(title = "Stock Market Values from 1925-1979", y = "Year", 
       x = "Values")



#Modify the plot to get different colors for negative and positive values: 

CRSP_years$values <- ifelse(CRSP_years$x >= 0, "Positive", "Negative") #To the left we create a new column called values in the CRSP_years dataframe. To the right we use a conditional function in r, if else. It checks whether the values of x are equal to or greater than 0, thus positive, then the condition is TRUE, otherwise FALSE.
# 'Positive' is the value assigned to the new values column when the condition is TRUE, 'Negative' when it is FALSE.  

ggplot(CRSP_years[which(CRSP_years$Group.1<=1979),], aes(x= x, y = Group.1, fill = values))+ #Note the last argument; we want the new values column to determine the colors of the plot.
  geom_bar(stat= "identity")+
  scale_fill_manual(values = c("Positive" = "turquoise4", "Negative" = "orange")) + #This line specifies the colors we want for respectively positive and negative values. 
  labs(title = "Stock Market Values from 1925-1979", y = "Year", 
       x = "Values")



#---- Exercise 3 ----
#Create a barplot for the CRSP data using the library GGPlot. Plot the data
#from 1980 to 2023. 





ggplot(CRSP_years[which(CRSP_years$Group.1>=1980),], aes(x= x, y = Group.1, fill = values))+ #Note the last argument; we want the new values column to determine the colors of the plot.
  geom_bar(stat= "identity")+
  scale_fill_manual(values = c("Positive" = "turquoise4", "Negative" = "orange")) + #This line specifies the colors we want for respectively positive and negative values.
  labs(title = "Stock Market Values from 1980-2023", y = "Year", 
       x = "Values")







