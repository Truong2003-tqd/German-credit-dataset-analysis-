#Data frame for correlation analysis
{
df2 <- df1
df2$sex <- as.numeric(factor(df2$sex))
df2$job <- as.numeric(factor(df2$job))
df2$housing <- as.numeric(factor(df2$housing))
df2$saving_accounts <- as.numeric(factor(df2$saving_accounts))
df2$checking_account <- as.numeric(factor(df2$checking_account))
df2$purpose <- as.numeric(factor(df2$purpose))
}
#Correlation Matrix of Variables
#Create correlation table
{
  correl_table_1 <- df2 %>% 
    select(credit_amount,duration,age,sex,job,housing,saving_accounts,checking_account,purpose) %>%
    cor(.)
  #Round by 3 decimal places
  correl_table_1 <- round(correl_table_1,3)
  #Remove "_" in variables and capitalize the first letter
  colnames(correl_table_1) <- str_to_title(gsub("_", " ", colnames(correl_table_1)))
  rownames(correl_table_1) <- str_to_title(gsub("_", " ", rownames(correl_table_1)))
  #Create correlation plot
  corrplot(correl_table_1, 
           method = "color", 
           type = "lower",
           addCoef.col = "#0F4761",
           number.cex = 0.6,
           tl.col = "#0F4761", 
           tl.srt = 30) 
  mtext("Correlation Matrix of Variables", 
        side = 3,                   # Position: Top (1 - bottom, 2 - left, 3 - top, 4 - right)
        line = -4,                  # Adjust vertical position
        col = "#1B5B78",            # Title color
        cex = 1.5,                  # Title size
        font = 2)                   # Bold font
}
#Hypothesis test for correlation coefficients
{
  cor.test(df2$credit_amount, df2$duration) 
  cor.test(df2$credit_amount, df2$job)
  cor.test(df2$credit_amount, df2$housing)
  cor.test(df2$duration, df2$job)
  cor.test(df2$duration, df2$housing)
}

