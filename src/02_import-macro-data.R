source("src/00_variables.R")

library(WDI)
library(tidyverse)

# WDIsearch('real.*interest.*rate')
macro <- WDI(indicator=indicators_macro,
           country=countries,
           start=start_year,
           end=end_year) %>%
  mutate(gdp=NY.GDP.PCAP.KD,
         cpi=FP.CPI.TOTL,
         rir=FR.INR.RINR,
         country=factor(country))%>%
  select(-iso2c,-iso3c,-indicators_macro)
write.csv(macro,"data/processed/macro.csv")
