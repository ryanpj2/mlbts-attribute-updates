library(httr)
library(jsonlite)
library(tidyverse)

url = "https://mlb23.theshow.com/apis/items.json?"

#total number of pages of MLB cards in Diamond Dynasty, 25 cards per page
total_pages = 151

#initialize empty list to store requested data
all_data = list()

#loop through all pages
for (page in 1:total_pages) {
  response = GET(paste0(url, "page=", page))
  page_data = content(response, "parsed")
  
  #append page data to list
  all_data[[page]] = page_data$items
}

#combine lists of each page into one dataframe
combined_data = do.call(rbind, all_data)

save(combined_data, file = "combined.RData")
load("combined.RData")

combined_data %>% 
  filter(series == "Live") %>% 
  select(name, team, ovr, display_position) %>% 
  arrange(desc(ovr)) %>% 
  head(10)
