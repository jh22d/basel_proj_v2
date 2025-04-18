# check if the t1cr in 6 canadina banks statistcially siginificnat increased after 2014
compare_base <- t1c_all %>% 
  filter(
    !is.na(t1c_B) & 
    bank %in% c("cm","ry","td","bmo", "bns","na") & 
    Date < "2018-01-01"
  )
compare_base

compare_mean <- compare_base%>%
  mutate(when = ifelse(Date < "2014-01-01","pre","post"))%>%
  group_by(when)%>%
  summarise(mean=mean(t1c_B))
compare_mean

compare_mean_plt <-compare_mean %>%
  ggplot(aes(x = factor(when), y = mean)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(x = "Time Period", y = "Mean Value", title = "Comparison of Mean ROE of Canadian SIBs") +
  theme_minimal()
ggsave(filename = "output/graph/compare_mean_plt.png", plot = compare_mean_plt, device = "png", width = 10, height = 6, dpi = 300)

compare_base

