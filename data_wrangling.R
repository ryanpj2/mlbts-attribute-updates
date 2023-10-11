library(httr)
library(jsonlite)
library(tidyverse)

#PULLING CARD DATA FROM MLBTS23 API

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

save(combined_data, file = "combined.rda")



#WRANGLING CARD DATA

load("combined.rda")

#filter for only Live Series batter cards, selecting att that contribute to OVR)
live_batters_cards = combined_data %>% 
  filter(series == "Live" & is_hitter == "TRUE") %>% 
  select(uuid, name, team_short_name, ovr, display_position, 
         contact_left:hitting_durability, fielding_ability:baserunning_aggression)

save(live_batters_cards, file = "live-batters-cards.rda")



#WRANGLING FANGRAPHS PLAYER STATS

batter_vs_r = read_csv("data/batter-vs-r.csv")
batter_vs_l = read_csv("data/batter-vs-l.csv")
batter_risp = read_csv("data/batter-risp.csv")
batter_plate_discipline = read_csv("data/batter-plate-discipline.csv")


batter_vs_r_small = batter_vs_r %>% 
  select(Name, PA, AVG, ISO) %>% 
  rename(PAvR = PA, AVGvR = AVG, ISOvR = ISO)

batter_vs_l_small = batter_vs_l %>% 
  select(Name, PA, AVG, ISO) %>% 
  rename(PAvL = PA, AVGvL = AVG, ISOvL = ISO)

batter_risp_small = batter_risp %>% 
  select(Name, PA, AVG) %>% 
  rename(PAwRISP = PA, AVGwRISP = AVG)

batter_plate_discipline_small = batter_plate_discipline %>% 
  select(Name, PA, 'BB%', 'K%')


df_list = list(batter_plate_discipline_small, batter_vs_r_small, batter_vs_l_small,
               batter_risp_small)

#joining dfs together
live_batters_stats = df_list %>% 
  reduce(full_join, by = "Name")


save(live_batters_stats, file = "live-batters-stats.rda")
