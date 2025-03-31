#Import data 
library(readr)
German_Credit_Dataset <- read_csv("German Credit Dataset.csv", 
                                      na = "NA")
#View the data
View(German_Credit_Dataset)

#Open libraries
library(tidyverse)
library(naniar)
library(gtExtras)
library(patchwork)
library(gridExtra)
library(skimr)
library(VIM)
library(corrplot)
library(ggplot2)


#Skim through the data
skim(German_Credit_Dataset) 

#Check the number of duplicated values
sum(duplicated(German_Credit_Dataset)) 

#Create a new data frame of the dataset with unique "id"
df <- German_Credit_Dataset %>% 
  unique()

#Determine unrealistic negative value 
df %>% 
  filter(id <= 0|
         age <= 0|
         job < 0|
         duration <= 0)
        
#Increase the id by 1 to fix the error
df <- df %>% 
  mutate(id = id + 1)

#View the data
View(df)

#Convert into categorical variables
df$sex <- factor (df$sex, levels = c("male", "female"))
df$job <- as.factor(df$job)
df$housing <- factor (df$housing, levels = c("own", "rent","free"))
df$saving_accounts <- factor (df$saving_accounts, levels = c("little","moderate","quite rich","rich"))
df$checking_account <- factor (df$checking_account, levels = c("little","moderate","rich"))
unique(df$checking_account)
df$purpose <- as.factor(df$purpose)

#Summary the dataset
summary(df)

#Summary missing values
df %>% 
  miss_var_summary(.) 

#Visualize missing values
gg_miss_var(df) +
  theme_bw()+
  labs(title = "Missing Values in Dataset", 
       x = "Variables", 
       y = "Number of Missing Values")

#Create age category 
age_interval <- c(18,24,34,59,100) #Create age intervals
age_labels <- c("student", "young", "adult", "senior") #Create age labels

#Create age_cat column
df <- df %>% 
  mutate(age_cat = cut(age, breaks = age_interval, labels = age_labels, right = TRUE)) 

#Create duration category
duration_interval <- c(0,12,36, Inf) #Create duration intervals
duration_labels <- c("short term", "medium term", "long term") #Create duration labels

#Create duration_cat column
df <- df %>% 
  mutate(duration_cat = cut(duration, breaks = duration_interval, labels = duration_labels, right = TRUE)) 

#Create category for credit amount by using percentiles (25, 50, 75)
credit_interval <- c(0,1366,2320,3972,Inf) #Create credit_amount intervals
credit_labels <-  c("low", "moderate", "quite high", "high")#Create credit_amount labels

#Create credit_cat column
df <- df %>% 
  mutate(credit_cat = cut(credit_amount, breaks = credit_interval, labels = credit_labels, right = TRUE)) 

#Rearrange column
df <- df %>% 
  select(id, age, age_cat, duration, duration_cat, credit_amount, credit_cat, everything()) 

#Replace the missing value by kNN method (job and housing as,numeric to conduct kNN)
df1 <- df %>% 
  kNN(variable = c("saving_accounts", "checking_account"),
      k = 7)

#Skim through the data after processing
skim(df1)




