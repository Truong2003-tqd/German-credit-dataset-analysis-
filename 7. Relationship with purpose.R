#Distribution of credit amount by duration across purpose 
{
df1 %>%
  mutate(is_outliers = if_else(credit_amount %in% outlier, "Outlier", "Not Outlier")) %>%
  mutate(purpose = case_when(purpose %in% c("radio/TV","furniture/equipment","domestic appliances","repairs") ~  "household", TRUE ~ purpose)) %>% 
  ggplot(aes(x = duration,y = credit_amount, fill = is_outliers))+
  geom_bar(stat = "identity")+
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("Outlier" = "red", "Not Outlier" = "#1B5B78")) +
  labs(title = "Distribution of Credit Amount by Duration across Purposes ",x = "Months", y = "Credit Amount", fill = "Outlier Status")+
  theme_bw()+
  theme(
    plot.title = element_text(size = 12, color = "#0F4761", face = "bold", hjust = 0.5),
    axis.title = element_text(size = 10, color = "#0F4761"),
    axis.text = element_text(size = 9, color = "#0F4761"),
    strip.text = element_text(size = 11, color = "#0F4761", face = "bold"),
    legend.position = "bottom",
    legend.title = element_text(size = 10, color = "#0F4761"),
    legend.text = element_text(size = 9, color = "#0F4761"))+
  facet_wrap(~str_to_title(purpose))
}

#Distribution of Checking and Savings Account Statuses across Purposes
{
checking_distribution_across_purpose <- df1 %>% 
  mutate(is_outliers = if_else(credit_amount %in% outlier, "Outlier", "Not Outlier")) %>% 
  mutate(purpose = case_when(purpose %in% c("radio/TV","furniture/equipment","domestic appliances","repairs") ~  "household", TRUE ~ purpose)) %>%
  ggplot(aes(x = str_to_title(saving_accounts), fill = is_outliers))+
  geom_bar(position = "stack")+
  scale_fill_manual(values = c("Outlier" = "red", "Not Outlier" = "#1B5B78")) +
  labs(x = "Checking Account Status", y = "Count")+
  theme_bw()+
  theme(
    axis.title = element_text(size = 10, color = "#0F4761"),
    axis.text = element_text(size = 8, color = "#0F4761"),
    strip.text = element_text(size = 10, color = "#0F4761", face = "bold"),
    legend.position = "none")+
  facet_wrap(~str_to_title(purpose))

savings_distribution_across_purpose <- df1 %>% 
  mutate(is_outliers = if_else(credit_amount %in% outlier, "Outlier", "Not Outlier")) %>% 
  mutate(purpose = case_when(purpose %in% c("radio/TV","furniture/equipment","domestic appliances","repairs") ~  "household", TRUE ~ purpose)) %>%
  ggplot(aes(x = str_to_title(checking_account), fill = is_outliers))+
  geom_bar(position = "stack")+
  scale_fill_manual(values = c("Outlier" = "red", "Not Outlier" = "#1B5B78")) +
  labs(x = "Savings Account Status", y = "Count", fill = "Outlier Status")+
  theme_bw()+
  theme(
    axis.title = element_text(size = 10, color = "#0F4761"),
    axis.text = element_text(size = 8, color = "#0F4761"),
    strip.text = element_text(size = 10, color = "#0F4761", face = "bold"),
    legend.position = "right",
    legend.title = element_text(size = 10, color = "#0F4761"),
    legend.text = element_text(size = 9, color = "#0F4761"))+
  facet_wrap(~str_to_title(purpose))


combine_checking_and_savings_distribution <- 
  grid.arrange(checking_distribution_across_purpose ,savings_distribution_across_purpose,ncol = 2,
               top = textGrob("Distribution of Checking and Savings Account Statuses across Purposes",
                              gp = gpar(fontsize = 14, fontface = "bold", col = "#0F4761")))
}


