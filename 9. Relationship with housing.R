#Distribution of credit amount across purpose by duration
{
df1 %>%
  mutate(is_outliers = if_else(credit_amount %in% outlier, "Outlier", "Not Outlier")) %>%
  mutate(purpose = case_when(purpose %in% c("radio/TV","furniture/equipment","domestic appliances","repairs") ~  "household", TRUE ~ purpose)) %>% 
  ggplot(aes(x = duration, y = credit_amount, fill = is_outliers))+
  geom_bar(stat = "identity")+
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("Outlier" = "red", "Not Outlier" = "#1B5B78")) +
  labs(title = "Distribution of Credit Amount by Duration across Housing Statuses",x = "Months", y = "Credit Amount", fill = "Outlier Status")+
  theme_bw()+
  theme(
    plot.title = element_text(size = 12, color = "#0F4761", face = "bold", hjust = 0.5),
    axis.title = element_text(size = 10, color = "#0F4761"),
    axis.text = element_text(size = 9, color = "#0F4761"),
    strip.text = element_text(size = 11, color = "#0F4761", face = "bold"),
    legend.position = "bottom",
    legend.title = element_text(size = 10, color = "#0F4761"),
    legend.text = element_text(size = 9, color = "#0F4761"))+
  facet_wrap(~str_to_title(housing))
}
#Distribution of Credit Amount by Housing Status across Purposes
{
df1 %>%
  mutate(is_outliers = if_else(credit_amount %in% outlier, "Outlier", "Not Outlier")) %>%
  mutate(purpose = case_when(purpose %in% c("radio/TV","furniture/equipment","domestic appliances","repairs") ~  "household", TRUE ~ purpose)) %>% 
  ggplot(aes(x = str_to_title(housing),y = credit_amount, fill = is_outliers))+
  geom_bar(stat = "identity")+
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("Outlier" = "red", "Not Outlier" = "#1B5B78")) +
  labs(title = "Distribution of Credit Amount by Housing Status across Purposes",x = "Housing Status", y = "Cummulative Credit Amount", fill = "Outlier Status")+
  theme_bw()+
  theme(
    plot.title = element_text(size = 12, color = "#0F4761", face = "bold", hjust = 0.5),
    axis.title = element_text(size = 11, color = "#0F4761"),
    axis.text = element_text(size = 9, color = "#0F4761"),
    strip.text = element_text(size = 11, color = "#0F4761", face = "bold"),
    legend.position = "bottom",
    legend.title = element_text(size = 10, color = "#0F4761"),
    legend.text = element_text(size = 9, color = "#0F4761"))+
  facet_wrap(~str_to_title(purpose))
}
#Distribution of Credit Amount by Duration across Purposes
{
df1 %>%
  filter(credit_amount %in% outlier) %>% 
  mutate(purpose = case_when(purpose %in% c("radio/TV","furniture/equipment","domestic appliances","repairs") ~  "household", TRUE ~ purpose)) %>%
  ggplot(aes(x = duration, y = credit_amount, fill = housing))+
  geom_bar(stat = "identity")+
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("own" = "red", "rent" = "#1B5B78", "free" = "#FBC02D")) +
  labs(title = "Distribution of Credit Amount by Duration across Purposes",x = "Months", y = "Cummulative Credit Amount", fill = "Housing Status")+
  theme_bw()+
  theme(
    plot.title = element_text(size = 12, color = "#0F4761", face = "bold", hjust = 0.5),
    axis.title = element_text(size = 11, color = "#0F4761"),
    axis.text = element_text(size = 9, color = "#0F4761"),
    strip.text = element_text(size = 11, color = "#0F4761", face = "bold"),
    legend.position = "bottom",
    legend.title = element_text(size = 10, color = "#0F4761"),
    legend.text = element_text(size = 9, color = "#0F4761"))+
  facet_wrap(~str_to_title(purpose))
}
  