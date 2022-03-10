# Week 2 Learning

# So far just discuss using setwd or using the system

# Importing datables -----
# The data set and instructions are here: https://cran.r-project.org/web/packages/datasets.load/datasets.load.pdf

library("datasets.load")
library("tidyverse")

# The complete function is alldata(package = NULL, lib.loc = NULL, all = TRUE, drop.defaults = FALSE)
# I can use the 3 commas to avoid writting everything, or even I leave it empty 
alldata(,,,drop.defaults = FALSE)

# Giving a name to the dataset and visualizing it
df1 <- datasets()
dfi
View(df1)

####################################################################
# Example of how to create an array
read_csv("a,b,c
1,2,3
4,6,7
8,9,10")
####################################################################

# str function shows the internal structure of the dataset in string
df1
str(df1)
df2 <- df1
df2
# now we change the character strings into factors
# this functions show as the class of the label (the $ sign specifies the label)
class(df2$Package)

# This function changes the character to factor
df2$Package <- as.factor(df2$Package)    
# then this function tell as that the class is a factor
class(df2$Package)
df2$Package

# how to create a new column with the info of the "Package" column in our dataset
df3 <- df2
df3$pkg <- as.factor(df2$Package)
df3


