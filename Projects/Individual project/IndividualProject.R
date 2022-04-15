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

#### We call the web page as a variable
book <- "https://christophm.github.io/interpretable-ml-book/" 
#### We ask R to read the HTML so we get the lines of code from the webpage
BookPage <- read_html(book)

BookPage
str(BookPage)

#### Then we look for places where we find body

body_nodes <- BookPage %>% 
  html_node("ul") %>% 
  html_children()%>% 
  html_children()
body_nodes

### We have the first part of the nodes inside "tbody"
### Now we use the crome developer page, we find the label body is located
### finally we use copy as XPath and pasted in the function below
### it is important to change the first tr (column) to * which means all rows

titles <- body_nodes%>% 
  xml2::xml_find_all('//html/body/div[*]/div[*]/nav/ul/li[*]/a') %>%
  rvest::html_text()
titles


subtitles <- body_nodes%>% 
  xml2::xml_find_all('//html/body/div[*]/div[*]/nav/ul/li[*]/ul/li[*]/a') %>%
  rvest::html_text()
subtitles

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
view(chart_df1)

chart_df2 <- chart_df2%>%
  mutate(URLS = recode(URLS,"r-packages-used.html#r-packages-used"  = "r-packages-used.html"))
view(chart_df2)

chart_df3 <- chart_df1 %>%                       
  mutate(
    new_var_dup    = URLT)
view(chart_df3)
