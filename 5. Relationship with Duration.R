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
#Extract outliers for the upcoming analysis
{
  #Short-term outliers
  short_term_outliers <- df1 %>% 
    filter(duration_cat == "short term") %>%
    pull(credit_amount) %>% 
    boxplot.stats() %>% 
    .$out
  
  short_term_outliers_rows <- which(df1$credit_amount %in% c(short_term_outliers))
  
  #Medium-term outliers
  medium_term_outliers <- df1 %>% 
    filter(duration_cat == "medium term") %>%
    pull(credit_amount) %>% 
    boxplot.stats() %>% 
    .$out
  
  medium_term_outliers_rows <- which(df1$credit_amount %in% c(medium_term_outliers))
  
  #Long-term outliers
  long_term_outliers <- df1 %>% 
    filter(duration_cat == "long term") %>%
    pull(credit_amount) %>% 
    boxplot.stats() %>% 
    .$out
  
  long_term_outliers_rows <- which(df1$credit_amount %in% c(long_term_outliers))
  
  
  #Dataset outliers
  outlier <- c(short_term_outliers,medium_term_outliers,long_term_outliers) 
  outlier_rows <- which(df1$credit_amount %in% c(outlier))
}
