# combine datasets in 01,02 and 03 files
library(readr)
library(tidyverse)
library(lubridate)
macro <- read_csv("data/processed/macro.csv")
all_bank_bg <- read_csv("data/processed/all_bank_bg.csv")

all_bank_df <- read_csv("data/processed/all_bank_df.csv")

# convert the exact date to year and yearquarter 
all_bank_time_fixed <- all_bank_df%>%
  mutate(year=year(date), 
         quarter=quarter(date), 
         yr_qtr = paste0(year,"q",quarter))%>%
  filter(year >= start_year & year <= end_year)%>%
  select(-c(date,...1,  quarter))

# combine 3 dataset
bank_full <- all_bank_time_fixed%>%
  left_join(all_bank_bg%>%select(-...1), by='bank')%>%
  left_join(macro%>%select(-...1), by = c('year','country'))

# convert indicator variables T, P and TP
df_for_stata <- bank_full %>%
       mutate(T = ifelse(country == "Canada", 1, 0),
              P = ifelse(year >= policy_change_year, 1, 0),
              TP = T * P)


# write.csv(df_for_stata, "data/processed/df_for_stata.csv")
 