# combine datasets in 01,02 and 03 files
library(readr)
library(tidyverse)
library(lubridate)
macro <- read_csv("data/processed/macro.csv")
all_bank_bg <- read_csv("data/processed/all_bank_bg.csv")

all_bank_df <- read_csv("data/processed/all_bank_df.csv")
# convert the exact date to year and yearquarter 
all_bank_df%>%mutate(year=year(date), quarter=quarter(date), t)
