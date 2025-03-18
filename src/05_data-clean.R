# combine datasets in 01,02 and 03 files
library(readr)
library(tidyverse)
library(lubridate)

macro <- read_csv("data/processed/macro.csv")
t1c_all <- read_csv("data/processed/t1c_all.csv")
t1c_group <- read_csv("data/processed/t1c_bankwise_mean_group.csv")%>%select(bank,Group)
all_bank_bg <- read_csv("data/processed/all_bank_bg.csv")
all_bank_df <- read_csv("data/processed/all_bank_df.csv")

# convert the exact date to year and yearquarter for bankwise info except t1c
all_bank_time_fixed <- all_bank_df%>%
  mutate(year=year(date), 
         quarter=quarter(date), 
         yr_qtr = paste0(year,"q",quarter))%>%
  filter(year >= start_year & year <= end_year)%>%
  select(-c(date,...1,  quarter))

# convert the exact date to year and yearquarter for t1c info
t1c_fixed <- t1c_all%>%
  mutate(year=year(Date), 
         quarter=quarter(Date), 
         yr_qtr = paste0(year,"q",quarter))%>%
  filter(year >= start_year & year <= end_year)%>%
  select(-c(Date,...1,  quarter, year))


# combine 3 dataset
bank_full <- all_bank_time_fixed%>%
  left_join(t1c_fixed, by=c('yr_qtr','bank'))%>%
  left_join(all_bank_bg%>%select(-...1), by='bank')%>%
  left_join(macro%>%select(-...1), by = c('year','country'))%>%
  left_join(t1c_group, by="bank")

# generate indicator variables T, P, TP
df_for_stata <- bank_full %>%
       mutate(T = ifelse(country == "Canada", 1, 0),
              P = ifelse(year >= policy_change_year, 1, 0),
              TP = T * P)


# write.csv(df_for_stata, "data/processed/df_for_stata.csv")
 