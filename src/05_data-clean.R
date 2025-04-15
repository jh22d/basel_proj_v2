# combine datasets in 01,02 and 03 files
library(readr)
library(tidyverse)
library(lubridate)

# 01
all_bank_wise<- read_csv("data/processed/all_bank_wise.csv")
# 02
macro <- read_csv("data/processed/macro.csv")
# 03
all_bank_bg <- read_csv("data/processed/all_bank_bg.csv")
# 04
t1c_all <- read_csv("data/processed/t1c_all.csv")

# t1c_group <- read_csv("data/processed/t1c_bankwise_mean_group.csv")%>%
#   select(bank,Group)%>%
#   mutate(bank=recode(bank,"ry"="rbc", "na"="nbc"))
# 
# all_bank_df <- read_csv("data/processed/all_bank_df.csv")

# convert the exact date to year and yearquarter for bankwise info except t1c
all_bank_yrqt <- all_bank_wise%>%
  mutate(year=year(date), 
         quarter=quarter(date), 
         yr_qtr = paste0(year,"q",quarter),
         adj_ebitda_B = adj_ebitda/1000000000,
         mkt_cap_B = mkt_cap/1000000000)%>%
  filter(year >= start_year & year <= end_year)%>%
  select(-c(date, ...1,quarter, adj_ebitda, mkt_cap))

# convert the exact date to year and yearquarter for t1c info
t1c_yrqt <- t1c_all%>%
  mutate(year=year(Date), 
         quarter=quarter(Date), 
         yr_qtr = paste0(year,"q",quarter))%>%
  filter(year >= start_year & year <= end_year)%>%
  select(-c(Date, ...1, quarter, year))


# combine 3 dataset
bank_full <- all_bank_yrqt%>%
  left_join(t1c_yrqt, by=c('yr_qtr','bank'))%>%
  left_join(all_bank_bg%>%select(-...1), by='bank')%>%
  left_join(macro%>%select(-...1), by = c('year','country'))

# generate indicator variables T, P, TP
df_for_stata <- bank_full %>%
       mutate(T = ifelse(country == "Canada", 1, 0),
              P = ifelse(year >= policy_change_year, 1, 0),
              TP = T * P)


write.csv(df_for_stata, "data/processed/df_for_stata.csv")


mean_t1cr <- all_bank_wise %>%
  filter(bank %in% c("cm", "rbc", "td", "bmo", "bns", "nbc") &
           date < as.Date("2018-01-01") &
           date >= as.Date("2011-01-01")) %>%
  group_by(date) %>%
  summarise(mean_t1cr = mean(t1cr, na.rm = TRUE))

t1cr_trend_Can_bank_plt <-ggplot(all_bank_wise %>%
                                   filter(bank %in% c("cm", "rbc", "td", "bmo", "bns", "nbc") &
                                            date < as.Date("2018-01-01") &
                                            date >= as.Date("2011-01-01")),
                                 aes(x = date, y = t1cr, color = as.factor(bank), group = as.factor(bank))) +
  geom_line() +
  geom_line(data = mean_t1cr, aes(x = date, y = mean_t1cr), 
            inherit.aes = FALSE,  # Important to turn off inherited aesthetics
            color = "black", size = 1, linetype = "solid")+
  geom_vline(xintercept = as.Date("2014-01-01"), linetype = "dashed", color = "red") +
  geom_hline(yintercept = 6, linetype = "dashed", color = "red") +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 15),
        axis.text.y = element_text(size = 15),
        legend.title = element_text(size = 15, face = "bold"),
        legend.text = element_text(size = 15),
        plot.title = element_text(size = 16, face = "bold"))+
  scale_x_date(date_breaks = "1 years", date_labels = "%Y")+
  labs(
    title = "Tier 1 Capital Ratio Over Time by Bank",
    subtitle = "2011 - 2018",
    x = "",
    y = "Tier 1 Capital Ratio",
    color = "Bank"  
  )
t1cr_trend_Can_bank_plt
ggsave(filename = "output/graph/t1cr_trend_CAN_bank_plt.png", plot = t1cr_trend_Can_bank_plt, device = "png", width = 15, height = 5, dpi = 300)


 