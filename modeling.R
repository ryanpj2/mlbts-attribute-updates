load("live-batters-full.rda")

live_batters_trn = live_batters_full %>% 
  rename(BBperc = 'BB%', Kperc = 'K%') %>% 
  filter(PA > 50 & PAvL > 25)

lm.fit = lm(ovr ~ fielding_ability + BBperc + Kperc + AVGvR + ISOvR + AVGvL +
              ISOvL, data = live_batters_trn)
summary(lm.fit)
