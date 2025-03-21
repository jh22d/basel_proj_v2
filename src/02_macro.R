source("src/00_variables.R")

library(WDI)
library(tidyverse)

# WDIsearch('real.*interest.*rate')
macro_raw <- WDI(indicator=indicators_macro,
           country=countries,
           start=start_year,
           end=end_year)
macro <-  macro_raw %>%
  mutate(gdp=NY.GDP.PCAP.KD,
         cpi=FP.CPI.TOTL,
         rir=FR.INR.RINR,
         country=factor(country),
         log_gdp = log(gdp),
         log_cpi=log(cpi))%>%
  select(-iso2c,-iso3c,-indicators_macro)
# write.csv(macro_df,"data/processed/macro.csv")

# 
# ggplot(macro, aes(x = year, y = log10_gdp, color = country)) +
#   geom_line() +
#   labs(title = "GDP Per Capita Over Time by Country",
#        x = "Year",
#        y = "GDP Per Capita (constant USD)",
#        color = "Country") +
#   theme_minimal()
