installed.packages("readr","stringr")
library("readr")
library(stringx)
library(stringr)


rawInput <- readLines("list.txt")
rawInput[5]

#### Now we change the list of 532 lines to a single line

rawInput1 <- paste(rawInput,collapse=" \n ") 

#### Now we are reading line by line, in this case line 1

rawInputByLine <- readLines("list.txt", n=1)

#### Creating a DataFrame from the file List.txt

df<- data.frame(rawInput)
test <- df$rawInput[4]

#### Now we are trying to find for words in the str

grep('https',readLines("list.txt"),value=TRUE)

#### Now we cfind in which lines the word appears

grep('https',readLines("list.txt"))

#### We can find in a strg the location of a word
test1 <- str_locate(test,"\\| ")
str(test1)

#### We can divide a str by characters that appear

df1 <- str_split(test,"\\| ")
df1

#### Now we can add columns to the dataFrame

df$Name <- ""
df$Adress <- ""

df$addr <- str_split(df$rawInput," \\| ",2)[1] 
df$nm <- str_split(df$rawInput," \\| ",2)[2] 
df
