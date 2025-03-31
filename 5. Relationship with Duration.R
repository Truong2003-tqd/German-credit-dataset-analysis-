#Boxplot of Credit Amount by Duration Category
{
ggplot(df1, aes(x = duration_cat,y = credit_amount)) + 
  geom_boxplot(fill = "#0F4761", alpha = 0.7,
               outlier.colour =  "#0F4761",
               color =  "#0F4761") + 
  theme_classic() +
  labs(title = "Boxplot of Credit Amount by Duration Category",x = "Duration Category", y = "Credit Amount (DM)")+
  theme(
    plot.title = element_text(size = 13, color = "#0F4761", hjust = 0.5, face = "bold"),
    axis.title = element_text(size = 10, color = "#0F4761"),
    axis.text = element_text(size = 9, color = "#0F4761"))
}