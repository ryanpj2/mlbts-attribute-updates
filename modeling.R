load("live-batters-full.rda")
library(tidyverse)

live_batters_trn = live_batters_full %>% 
  rename(BBperc = 'BB%', Kperc = 'K%') %>% 
  filter(PA > 50 & PAvL > 25)

live_batters = live_batters_full %>% 
  rename(BBperc = 'BB%', Kperc = 'K%') %>% 
  select(ovr, fielding_ability:reaction_time, speed, baserunning_ability, BBperc:AVGwRISP)

lm.fit = lm(ovr ~ fielding_ability + BBperc + Kperc + AVGvR + ISOvR + AVGvL +
              ISOvL, data = live_batters_full)
summary(lm.fit)

lm.fit2 = lm(ovr ~ ., data = live_batters)
summary(lm.fit2)

predict(lm.fit2, newdata = live_batters[548,])
