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
# write.csv(macro,"data/processed/macro.csv")


gdp_plt <- ggplot(macro, aes(x = year, y = gdp, color = country)) +
  geom_line() +
  labs(title = "GDP Per Capita Over Time by Country",
       x = "Year",
       y = "GDP Per Capita (constant USD)",
       color = "Country") +
  theme_minimal()
ggsave("output/graph/gdp.png",gdp_plt)




cpi_plt <- ggplot(macro, aes(x = year, y = cpi, color = country)) +
  geom_line() +
  labs(title = "CPI Over Time by Country",
       x = "Year",
       y = "CPI",
       color = "Country") +
  theme_minimal()
ggsave("output/graph/cpi.png",cpi_plt)
