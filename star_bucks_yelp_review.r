#load library

library(tidyverse)
library(rvest)


# get url

url <- "https://www.yelp.com/biz/starbucks-wichita-7"

#conver url to html object

page <- read_html(url)

#find the page number
page_number <- page %>% 
  html_nodes(".text-align--center__09f24__fYBGO .css-chan6m") %>% 
  html_text() %>% 
  str_remove_all("1 of ") %>% 
  as.numeric()

#create a sequence
page_seq <- seq(from = 0, 
                to = (page_number * 10) - 10,
                by = 10)

#create a vector
review_date_all <- c()
review_rating_all <- c()
review_text_all <- c()
user_all <- c()
location_all <- c()


  

for (i in page_seq){
  if (i == 0){
    page <- read_html(url)
  } else {
      page <- read_html(paste0(url,'?start=', i))
  }
  #review date
  review_date <- page %>% 
    html_nodes(".margin-b1-5__09f24__NHcQi .arrange-unit-fill__09f24__CUubG") %>% 
    html_text()
  
  #review rating
  review_rating <- page %>% 
    html_nodes(".margin-b1-5__09f24__NHcQi .overflow--hidden__09f24___ayzG") %>% 
    html_attr("aria-label") %>% 
    str_remove_all(" star rating") %>% 
    as.numeric()
  
  #review text
  review_text <- page %>% 
    html_nodes(".comment__09f24__gu0rG .raw__09f24__T4Ezm") %>% 
    html_text()
  
  #user
  user <- page %>% 
    html_nodes(".css-ux5mu6 .css-1m051bw") %>% 
    html_text()
  
  #location
  location <- page %>% 
    html_nodes(".arrange-unit-fill__09f24__CUubG .border-color--default__09f24__NPAKY .border-color--default__09f24__NPAKY .border-color--default__09f24__NPAKY .border-color--default__09f24__NPAKY .css-qgunke") %>% 
    html_text()
  
  review_date_all <- append(review_date_all, review_date)
  review_rating_all <- append(review_rating_all, review_rating)
  review_text_all <- append(review_text_all, review_text)
  user_all <- append(user_all, user)
  location_all <- append(location_all, location)
  
}

df <- data.frame ("date" = review_date_all,
                  "rating" = review_rating_all,
                  "comment" = review_text_all,
                  "user" = user_all,
                  "location" = location_all)
  
view(df)
