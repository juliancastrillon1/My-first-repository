library(rvest)
library(dplyr)
library(tidyverse)
library(stringr)

#### We call the web page as a variable
book <- "https://christophm.github.io/interpretable-ml-book/" 
#### We ask R to read the HTML so we get the lines of code from the webpage
BookPage <- read_html(book)

BookPage
str(BookPage)

#### Then we look for places where we find body

body_nodes1 <- BookPage %>% 
  html_node("section")%>%
  html_children()%>%
  html_children()
body_nodes1

text1 <- body_nodes1%>% 
  xml2::xml_find_all('//*[@id="summary"]/p[*]') %>%
  rvest::html_text()%>%
  toString()
text1

string1='//*[@id="'
string2='"]/p[*]'

XPATH=paste0(string1,x,string2,sep="")
XPATH

str_replace_all(finale,"\"","")
