library(readxl)
library(tidyverse)
t1c_gsib_us <- read_excel("data/raw/t1c_gsib_us.xlsx")
t1c_dsib_us <- read_excel("data/raw/t1c_dsib_us.xlsx")%>%select(-1,-2)
t1c_ca <- read_excel("data/raw/t1c_ca.xlsx")%>%select(-Date)
t1c_all <- cbind(t1c_gsib_us,t1c_dsib_us,t1c_ca)%>%
  pivot_longer(-Date,names_to = 'equity_detail',values_to = 't1c')%>%
  mutate(
    bank = recode(tolower(
      str_extract(equity_detail, "(?<=\\().*?(?=\\s[A-Z]{2}\\sEquity)")
    ),"2370058d"="suntrust"))%>%
  select(-equity_detail)
# write.csv(t1c_all,"data/processed/t1c_all.csv")
