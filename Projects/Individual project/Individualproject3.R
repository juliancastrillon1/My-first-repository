pacman::p_load(
  rio,        # importing data  
  here,       # relative file pathways  
  janitor,    # data cleaning and tables
  lubridate,  # working with dates
  epikit,     # age_categories() function
  tidyverse   # data management and visualization
)

library(rvest)
library(dplyr)
library(tidyverse)
library(stringr)
library(regexPipes)

#### We call the web page as a variable
book <- "https://christophm.github.io/interpretable-ml-book/" 
#### We ask R to read the HTML so we get the lines of code from the webpage

BookPage <- read_html(book)

BookPage
str(BookPage)

#### Then we look for places where we find UL

body_nodes <- BookPage %>% 
  html_node("ul") %>% 
  html_children()%>% 
  html_children()
body_nodes

### We have the first part of the nodes inside "UL"
### Now we use the crome developer page, we find the label body is located
### finally we use copy as XPath and pasted in the function below
### it is important to change the first tr (column) to * which means all rows

### Now we are going to retrieve the names and URL from everything from the index
titles <- body_nodes%>% 
  xml2::xml_find_all('//html/body/div[*]/div[*]/nav/ul/li[*]/a') %>%
  rvest::html_text()
titles


subtitles <- body_nodes%>% 
  xml2::xml_find_all('//html/body/div[*]/div[*]/nav/ul/li[*]/ul/li[*]/a') %>%
  rvest::html_text()
subtitles

### this is for the URL

URLtitles <- body_nodes%>% 
  xml2::xml_find_all('//html/body/div[*]/div[*]/nav/ul/li[*]/a')
URLtitles

URLsubtitles <- body_nodes%>% 
  xml2::xml_find_all('//html/body/div[*]/div[*]/nav/ul/li[*]/ul/li[*]/a')
URLsubtitles


URLT<-head(html_attr(URLtitles, "href"),n=20L)
URLT

URLS<-head(html_attr(URLsubtitles, "href"),n=50L)
URLS

### We create our inicial dataframes

chart_df1 <- data.frame(titles,URLT)
knitr::kable(
  chart_df1  %>% head(10))

chart_df2 <- data.frame(subtitles,URLS)
knitr::kable(
  chart_df2  %>% head(10))

chart_df1 <- chart_df1[-c(1), ]
chart_df1

chart_df1 <- chart_df1%>%
  mutate(URLT = recode(URLT,
                       "index.html#summary"  = "index.html",
                       "references.html#references" = "references.html"
  ))

chart_df2 <- chart_df2%>%
  mutate(URLS = recode(URLS,"r-packages-used.html#r-packages-used"  = "r-packages-used.html"))

### In order to search every page with a for, it was necessary to modify the dataframes

chart_df3 <- chart_df1 %>%                       
  mutate(
      URLTNAME    = URLT)%>%
  mutate_at("URLTNAME", str_replace, ".html", "")
view(chart_df3)

chart_df4 <- chart_df2 %>%                       
  mutate(
    URLSNAME    = URLS)%>%
  mutate_at("URLSNAME", str_replace, ".html", "")
view(chart_df4)

### Now we look for the content on each page (text)

body_nodes1 <- BookPage %>% 
  html_node("section")%>%
  html_children()%>%
  html_children()
body_nodes1


### In this step, we are going to create each xpath with a for a the new columns

string1='//*[@id="'
string2='"]/p[*]'


for (i in 1:(nrow(chart_df3))){
  antesp=toString(str_replace_all(paste0(string1,chart_df3[i,3],string2,sep=""),"\"",""))
  prueba=xml2::xml_find_all(antesp)
  prueba1=rvest::html_text(prueba)
  prueba2=toString(prueba1)
}
prueba2


