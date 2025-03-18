library(readxl)
library(tidyverse)

# import t1c dataset in ca, us-dsib, us-gsib
t1c_gsib_us <- read_excel("data/raw/t1c_gsib_us.xlsx")
t1c_dsib_us <- read_excel("data/raw/t1c_dsib_us.xlsx")%>%select(-1)
t1c_ca <- read_excel("data/raw/t1c_ca.xlsx")%>%select(-Date)

# combine the t1c info for all banks in 2 countries
t1c_all <- cbind(t1c_gsib_us,t1c_dsib_us,t1c_ca)%>%
  pivot_longer(-Date,names_to = 'equity_detail',values_to = 't1c')%>%
  mutate(
    bank = recode(tolower(
      str_extract(equity_detail, "(?<=\\().*?(?=\\s[A-Z]{2}\\sEquity)")
    ),"2370058d"="suntrust"),
    t1c_B=t1c/1000000000)%>%
  select(-c(equity_detail,t1c))
write.csv(t1c_all,"data/processed/t1c_all.csv")

t1c_bankwise_mean_group <- t1c_all%>%
  group_by(bank)%>%
  summarise(bank_mean_t1c_B=mean(t1c_B, na.rm=T))%>%
  arrange(desc(bank_mean_t1c_B))%>%
  mutate(Country = if_else(bank %in% c('ry', 'td', 'bmo', 'cm', 'na', 'nbs'), 
                           "Canada",
                           "US"),
         Group = if_else(bank_mean_t1c_B>t1c_threshold,
                         "Large","Small"))
write.csv(t1c_bankwise_mean_group,"data/processed/t1c_bankwise_mean_group.csv")

t1c_bankwise_mean_plt <- t1c_bankwise_mean_group %>%
  filter(bank != "mufg") %>%  # Filter out "mufg"
  ggplot(aes(x = reorder(bank, -bank_mean_t1c_B), 
             y = bank_mean_t1c_B,
             fill = Country)) +  # Map fill to the new column
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("Canada" = "steelblue", "US" = "gray")) +  # Custom colors
  labs(
    title = "Mean Tier 1 Capital by Bank",
    x = "Bank",
    y = "Mean Tier 1 Capital (in Billions)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
t1c_bankwise_mean_plt
ggsave(filename = "output/graph/t1c_bankwise_mean_plt.png", plot = t1c_bankwise_mean_plt, device = "png", width = 10, height = 6, dpi = 300)


t1c_trend_by_bank_plt <- ggplot(t1c_all %>% 
                                  filter(!is.na(t1c_B) & bank != "mufg" & Date < "2019-01-01"),
       aes(Date, t1c_B, color = as.factor(bank), group = as.factor(bank))) +
  geom_line() +
  theme_minimal() +
  labs(
    title = "Tier 1 Capital Over Time by Bank",
    subtitle = "2006 - 2019",
    x = "Date",
    y = "Tier 1 Capital (in Billions)",
    color = "Bank"  
  )
t1c_trend_by_bank_plt
ggsave(filename = "output/graph/t1c_trend_by_bank_plt.png", plot = t1c_trend_by_bank_plt, device = "png", width = 10, height = 6, dpi = 300)


t1c_mean_by_group_plt <- ggplot(t1c_bankwise_mean_group %>% 
                                  filter(bank != "mufg"),
                                aes(bank_mean_t1c_B, Group)) +
  geom_boxplot() +
  theme_minimal() +
  labs(
    title = "Tier 1 Capital by Group",
    x = "Tier 1 Capital (in Billions)",
    y = "Group"
  )
t1c_mean_by_group_plt
ggsave(filename = "output/graph/t1c_mean_by_group_plt.png", plot = t1c_mean_by_group_plt, device = "png", width = 10, height = 6, dpi = 300)


