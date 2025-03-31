#Credit Category Distribution by Duration Category: Missing vs. Non-Missing Values
{
plot1 <- df %>% 
  filter(is.na(saving_accounts) | is.na(checking_account)) %>% 
  ggplot(aes(x = duration_cat, fill =credit_cat))+
  geom_bar(position = "dodge", color = "white")+
  scale_fill_manual(values = c("#52824B","#D35400", "#1B5B78","#E0C479")) +
  theme_classic()+
  labs(x = "", y = "Count")+
  theme(
    axis.title = element_text(size = 12, color = "#0F4761"),
    axis.text = element_text(size = 9, color = "#0F4761"),
    legend.position = "none")

plot2 <- df %>% 
  ggplot(aes(x = duration_cat, fill =credit_cat))+
  geom_bar(position = "dodge", color = "white")+
  scale_fill_manual(values = c("#52824B","#D35400", "#1B5B78","#E0C479")) +
  theme_classic()+
  labs(x = "Duration Category", y = "Count", fill = "Credit Category")+
  theme(
    axis.title = element_text(size = 12, color = "#0F4761"),
    axis.text = element_text(size = 9, color = "#0F4761"),
    legend.position = "bottom",
    legend.title = element_text(size = 10, color = "#0F4761"),
    legend.text = element_text(size = 9, color = "#0F4761"))    

combine_duration <- grid.arrange(plot1, plot2, ncol = 1,
                                 top = textGrob("Credit Category Distribution by Duration Category: Missing vs. Non-Missing Values",
                                                gp = gpar(fontsize = 12, fontface = "bold", col = "#0F4761")))
}
#Credit Category Distribution by Age Catergory: Missing vs. Non-Missing Values
{
plot3 <- df %>% 
  filter(is.na(saving_accounts) | is.na(checking_account)) %>% 
  ggplot(aes(x = age_cat, fill =credit_cat))+
  geom_bar(position = "dodge", color = "white")+
  scale_fill_manual(values = c("#52824B","#D35400", "#1B5B78","#E0C479")) +
  theme_classic()+
  labs(x = "", y = "Count")+
  theme(
    axis.title = element_text(size = 12, color = "#0F4761"),
    axis.text = element_text(size = 9, color = "#0F4761"),
    legend.position = "none")
  
plot4 <- df %>% 
  ggplot(aes(x = age_cat, fill =credit_cat))+
  geom_bar(position = "dodge", color = "white")+
  scale_fill_manual(values = c("#52824B","#D35400", "#1B5B78","#E0C479")) +
  theme_classic()+
  labs(x = "Duration Category", y = "Count", fill = "Credit Category")+
  theme(
    axis.title = element_text(size = 12, color = "#0F4761"),
    axis.text = element_text(size = 9, color = "#0F4761"),
    legend.position = "bottom",
    legend.title = element_text(size = 10, color = "#0F4761"),
    legend.text = element_text(size = 9, color = "#0F4761"))   

combine_age <- grid.arrange(plot3, plot4, ncol = 1,
                            top = textGrob("Credit Category Distribution by Age Catergory: Missing vs. Non-Missing Values",
                                           gp = gpar(fontsize = 12, fontface = "bold", col = "#0F4761")))
}
#Credit Category Distribution by Job Catergory: Missing vs. Non-Missing Values
{
plot5 <- df %>% 
  filter(is.na(saving_accounts) | is.na(checking_account)) %>% 
  ggplot(aes(x = job, fill =credit_cat))+
  geom_bar(position = "dodge", color = "white")+
  scale_fill_manual(values = c("#52824B","#D35400", "#1B5B78","#E0C479")) +
  theme_classic()+
  labs(x = "", y = "Count")+
  theme(
    axis.title = element_text(size = 12, color = "#0F4761"),
    axis.text = element_text(size = 9, color = "#0F4761"),
    legend.position = "none")

plot6 <- df %>% 
  ggplot(aes(x = job, fill =credit_cat))+
  geom_bar(position = "dodge", color = "white")+
  scale_fill_manual(values = c("#52824B","#D35400", "#1B5B78","#E0C479")) +
  theme_classic()+
  labs(x = "Job Category", y = "Count", fill = "Credit Category")+
  theme(
    axis.title = element_text(size = 12, color = "#0F4761"),
    axis.text = element_text(size = 9, color = "#0F4761"),
    legend.position = "bottom",
    legend.title = element_text(size = 10, color = "#0F4761"),
    legend.text = element_text(size = 9, color = "#0F4761"))   

combine_job <- grid.arrange(plot5, plot6, ncol = 1,
                            top = textGrob("Credit Category Distribution by Job Catergory: Missing vs. Non-Missing Values",
                                           gp = gpar(fontsize = 12, fontface = "bold", col = "#0F4761")))
}
#Credit Category Distribution by Housing Catergory: Missing vs. Non-Missing Values
{
plot7 <- df %>% 
  filter(is.na(saving_accounts) | is.na(checking_account)) %>% 
  ggplot(aes(x = housing, fill =credit_cat))+
  geom_bar(position = "dodge", color = "white")+
  scale_fill_manual(values = c("#52824B","#D35400", "#1B5B78","#E0C479")) +
  theme_classic()+
  labs(x = "", y = "Count")+
  theme(
    axis.title = element_text(size = 12, color = "#0F4761"),
    axis.text = element_text(size = 9, color = "#0F4761"),
    legend.position = "none")

plot8 <- df %>% 
  ggplot(aes(x = housing, fill =credit_cat))+
  geom_bar(position = "dodge", color = "white")+
  scale_fill_manual(values = c("#52824B","#D35400", "#1B5B78","#E0C479")) +
  theme_classic()+
  labs(x = "Housing Category", y = "Count", fill = "Credit Category")+
  theme(
    axis.title = element_text(size = 12, color = "#0F4761"),
    axis.text = element_text(size = 9, color = "#0F4761"),
    legend.position = "bottom",
    legend.title = element_text(size = 10, color = "#0F4761"),
    legend.text = element_text(size = 9, color = "#0F4761"))  
  
combine_housing <- grid.arrange(plot7, plot8, ncol = 1,
                                top = textGrob("Credit Category Distribution by Housing Catergory: Missing vs. Non-Missing Values",
                                               gp = gpar(fontsize = 12, fontface = "bold", col = "#0F4761")))
}
#Replace the missing value by kNN method 
{df1 <- df %>% 
    kNN(variable = c("saving_accounts", "checking_account"),
        k = 7)}
#Skim through the data after processing
skim(df1)
#Credit Category Distribution by Checking Account Status: Before and After Imputation
{
before_imputation_by_checking_account <- 
  ggplot(df, aes(x = checking_account,y = credit_amount)) + 
  geom_boxplot(fill = "#0F4761", alpha = 0.7,
               outlier.colour =  "#0F4761",
               color =  "#0F4761") + 
  theme_classic() +
  labs(x = "", y = "Credit Amount")+
  theme(
    axis.title = element_text(size = 10, color = "#0F4761"),
    axis.text = element_text(size = 9, color = "#0F4761"))
  
after_imputation_by_checking_account <-
  ggplot(df1, aes(x = checking_account,y = credit_amount)) + 
  geom_boxplot(fill = "#0F4761", alpha = 0.7,
                outlier.colour =  "#0F4761",
                color =  "#0F4761") + 
  theme_classic() +
  labs(x = "Checking Account Status", y = "Credit Amount")+
  theme(
    axis.title = element_text(size = 10, color = "#0F4761"),
    axis.text = element_text(size = 9, color = "#0F4761"))

  combine_checking_account <- grid.arrange(before_imputation_by_checking_account, after_imputation_by_checking_account, ncol = 1,
                                  top = textGrob("Credit Category Distribution by Checking Account Status: Before and After Imputation",
                                                 gp = gpar(fontsize = 12, fontface = "bold", col = "#0F4761")))
}


