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
#Scatter plot of credit amount across checking and checking account status
{  #Scatter plot of credit amount by duration category across saving account status
  {
    saving_scatter <- df1 %>% 
      mutate(is_outliers = if_else(credit_amount %in% outlier, "Outlier", "Not Outlier")) %>% 
      ggplot(aes(x = duration, y =  credit_amount, color = is_outliers))+
      geom_point(size = 2, alpha = 0.5)+
      scale_color_manual(values = c("Outlier" = "red", "Not Outlier" = "#1B5B78")) +
      theme_classic()+
      labs(title = "Savings Account",x = "Months", y = "Credit Amount")+
      theme(
        plot.title = element_text(size = 12, color = "#0F4761", face = "bold"),
        axis.title = element_text(size = 10, color = "#0F4761"),
        axis.text = element_text(size = 9, color = "#0F4761"),
        legend.position = "none",
        strip.text = element_text(size = 11, color = "#0F4761", face = "bold"))+
      facet_wrap(~str_to_title(saving_accounts))
  } 
  #Scatter plot of credit amount by duration category across checking account status
  {
    checking_scatter <- df1 %>%  
      mutate(is_outliers = if_else(credit_amount %in% outlier, "Outlier", "Not Outlier")) %>%
      ggplot(aes(x = duration, y =  credit_amount, color = is_outliers))+
      geom_point(size = 2, alpha = 0.5)+
      scale_color_manual(values = c("Outlier" = "red", "Not Outlier" = "#1B5B78")) +
      theme_classic()+
      labs(title = "Checking Account",x = "Months", y = "Credit Amount", color = "Outlier Status")+
      theme(
        plot.title = element_text(size = 12, color = "#0F4761", face = "bold"),
        axis.title = element_text(size = 10, color = "#0F4761"),
        axis.text = element_text(size = 9, color = "#0F4761"),
        strip.text = element_text(size = 11, color = "#0F4761", face = "bold"),
        legend.position = "bottom",
        legend.title = element_text(size = 10, color = "#0F4761"),
        legend.text = element_text(size = 9, color = "#0F4761"))+
      facet_wrap(~str_to_title(checking_account))
  }
  #Combine charts
  {
    combine_saving_and_checking_scatter <- 
      grid.arrange(saving_scatter, checking_scatter, ncol = 1,
                   top = textGrob("Credit Amount Outliers' Distribution across Savings and Checking Account Statuses",
                                  gp = gpar(fontsize = 12, fontface = "bold", col = "#0F4761")))
  }
}
