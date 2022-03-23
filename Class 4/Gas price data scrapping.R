library(rvest)
library(dplyr)
library(tidyverse)

#### We call the web page as a variable
gasprice <- "https://gasprices.aaa.com/state-gas-price-averages/" 
#### We ask R to read the HTML so we get the lines of code from the webpage
GPpage <- read_html(gasprice)

GPpage
str(GPpage)

#### Then we look for places where we find the places in the string where we find body

body_nodes <- GPpage %>% 
  html_node("tbody") %>% 
  html_children()
body_nodes

### We have the first part of the nodes inside "tbody"
### Now we use the crome developer page, we find the label body is located
### finally we use copy as XPath and pasted in the function below
### it is important to change the first tr (column) to * which means all rows

state <- body_nodes%>% 
  xml2::xml_find_all('//*[@id="sortable"]/tbody/tr[*]/td[1]/a') %>%
  rvest::html_text()
state

### Now as there are info inside the insider nodes above we use children twice

body_nodes1 <- GPpage %>% 
  html_node("tbody") %>% 
  html_children()%>%
  html_children()
body_nodes1

### Now we repeat the process of copying the XPath for each column

regular <- body_nodes1%>% 
  xml2::xml_find_all('//*[@id="sortable"]/tbody/tr[*]/td[2]') %>%
  rvest::html_text()
regular

mid_grade <- body_nodes%>% 
  xml2::xml_find_all('//*[@id="sortable"]/tbody/tr[*]/td[3]') %>%
  rvest::html_text()
mid_grade

premium <- body_nodes%>% 
  xml2::xml_find_all('//*[@id="sortable"]/tbody/tr[*]/td[4]') %>%
  rvest::html_text()
premium

diesel <- body_nodes%>% 
  xml2::xml_find_all('//*[@id="sortable"]/tbody/tr[*]/td[5]') %>%
  rvest::html_text()
diesel

### Now we use the following function to create a dataframe

chart_df <- data.frame(state,regular,mid_grade,premium,diesel)
knitr::kable(
  chart_df  %>% head(10))

view(chart_df)


