load("live-batters-full.rda")

live_batters_full = live_batters_full %>% 
  rename(BBperc = 'BB%', Kperc = 'K%')

lm.fit = lm(ovr ~ fielding_ability + arm_strength + arm_accuracy + reaction_time +
              speed + baserunning_ability + BBperc + Kperc + AVGvR + ISOvR + AVGvL +
              ISOvL + AVGwRISP, data = live_batters_full)
summary(lm.fit)
