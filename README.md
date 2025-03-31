# Overview
Welcome to my analysis of German Credit dataset, which sourced from [Kaggle - German Credit Risk](https://www.kaggle.com/datasets/uciml/german-credit), containing customers' information on age, duration, credit amount, checking and savings account statuses, job and housing status, and purposes. This analysis involves data wrangling, mining, and visualization using the R programming language. The variables are analyzed to determine the bank's lending strategy and the portfolio risk profile, and to detect any unusual patterns that may result from financial fraud.  
# The Questions
Below are questions I want to answer in my project:
1. What are the relationships between variables?
2. What are the primary customers of this banks?
3. What are the overall risk profile of the loan portfolio?
4. Are there any ususual partterns in the data? What are the root causes?
# Tools I Used
Rstudio is the backbone of my analysis. I used following packages to analyze the data:
1. tidyverse: A collection of R packages for data manipulation, visualization, and analysis (e.g., dplyr, ggplot2).
2. naniar: Handles missing data by visualizing and imputing missing values.
3. gtExtras: Extends the gt package to create advanced and visually appealing tables.
4. patchwork: Combines multiple ggplot2 plots into a single layout.
5. gridExtra: Arranges multiple plots and tables in a grid format.
6. skimr: Provides quick summaries of data, including missing values and distributions.
7. VIM: Visualizes and imputes missing values for multivariate data.
8. corrplot: Visualizes correlation matrices using colorful and informative plots.
9. ggplot2: Creates customizable and elegant data visualizations.
# Data Preparation and Wrangling
This section outline steps taken to prepare and clean the data to ensure high accuracy and usability
## Import & Clean Up Data
I start by importing need packages and loading the csv dataset file, followed by detecting and handling missing values and outliers. 
### Import packages and load the data
**1. Import packages**
```r
#Import packages
library(readr)
library(tidyverse)
library(naniar)
library(gtExtras)
library(patchwork)
library(gridExtra)
library(skimr)
library(VIM)
library(corrplot)
library(ggplot2)
```
**2. Load the data**
```r
#Load the data
German_Credit_Dataset <- read_csv("German Credit Dataset.csv", 
                                      na = "NA")
```
**3. Create a dataframe for the analysis**
```r
#Create a new dataframe 
df <- German_Credit_Dataset %>% 
  unique()
```
**4. Summary table of variables**

| Variable         | Data Type | Description                                                                                   |
|----------------------|--------------|-----------------------------------------------------------------------------------------------|
| id                   | Numeric      | Customer's unique identifier                                                                |
| age                  | Numeric      | Customer’s age                                                                              |
| sex                  | Character    | Male, Female                                                                               |
| job                  | Character    | 0 - Unskilled and non-resident, 1 - Unskilled and resident, 2 - Skilled, 3 - Highly skilled |
| housing              | Character    | Own, Rent, or Free                                                                          |
| saving_accounts      | Character    | Little, Moderate, Quite Rich, Rich, Unknown                                                 |
| checking_account     | Character    | Little, Moderate, Rich, Unknown                                                             |
| credit_amount        | Numeric      | Credit amount (DM)                                                                          |
| duration             | Numeric      | Loan term (months)                                                                          |
| purpose              | Character    | Radio/TV, Education, Furniture/Equipment, Car, Business, Domestic Appliances, Repairs, Vacation/Others |

The table describes the original meaning and data type of each variable.
**5. Convert categorical variables to factor data type**
```r
#Convert into categorical variables
df$sex <- factor(df$sex, levels = c("male", "female"))
df$job <- as.factor(df$job)
df$housing <- factor(df$housing, levels = c("own", "rent","free"))
df$saving_accounts <- factor(df$saving_accounts, levels = c("little","moderate","quite rich","rich"))
df$checking_account <- factor(df$checking_account, levels = c("little","moderate","rich"))
df$purpose <- as.factor(df$purpose)
```
Check the dataset after changes
```r
#Check the data type
glimpse(df, width = 1)
```
```r
Rows: 1,000
Columns: 13
$ id               <dbl> …
$ age              <dbl> …
$ age_cat          <fct> …
$ duration         <dbl> …
$ duration_cat     <fct> …
$ credit_amount    <dbl> …
$ credit_cat       <fct> …
$ sex              <fct> …
$ job              <fct> …
$ housing          <fct> …
$ saving_accounts  <fct> …
$ checking_account <fct> …
$ purpose          <fct> …
```
**6. Group age, duration and credit_amount observations to new caterogry**
```r
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
```
The table below describe the new columns after processing
| **Variable**       | **Data Type** | **Categories**                                                                                                             |
|---------------------|--------------|--------------------------------------------------------------------------------------------------------------------------|
| **Age_cat**         | Factor       | Student [18, 24], Young (24, 34], Adult (34, 59], Senior (59, 100]                                                         |
| **Duration_cat**    | Factor       | Short Term [6, 12], Medium Term (12, 36], Long Term (36 and above)                                                        |
| **Credit_cat**      | Factor       | Low [250, 1366], Moderate (1366, 2320], Quite High (2320, 3972], High (3972, 18424]                                        |

### Data Cleaning
**1. Skim through the data**
```
skim(German_Credit_Dataset)
```
```r
── Data Summary ────────────────────────
                           Values               
Name                       German_Credit_Dataset
Number of rows             1000                 
Number of columns          10                   
_______________________                         
Column type frequency:                          
  character                5                    
  numeric                  5                    
________________________                        
Group variables            None                 

── Variable type: character ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable    n_missing complete_rate min max empty n_unique whitespace
1 sex                      0         1       4   6     0        2          0
2 housing                  0         1       3   4     0        3          0
3 saving_accounts        183         0.817   4  10     0        4          0
4 checking_account       394         0.606   4   8     0        3          0
5 purpose                  0         1       3  19     0        8          0

── Variable type: numeric ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate    mean       sd  p0   p25   p50   p75  p100 hist 
1 id                    0             1  500.    289.      0  250.  500.  749.   999 ▇▇▇▇▇
2 age                   0             1   35.5    11.4    19   27    33    42     75 ▇▆▃▁▁
3 job                   0             1    1.90    0.654   0    2     2     2      3 ▁▂▁▇▂
4 credit_amount         0             1 3271.   2823.    250 1366. 2320. 3972. 18424 ▇▂▁▁▁
5 duration              0             1   20.9    12.1     4   12    18    24     72 ▇▇▂▁▁
```
The data has 183 and 394 missing values in saving_account and checking_account, respectively. Missing data can arise from human error, machine malfunctions or respondents' refusal to answer. The removal of a significant number of missing values will substantially distort the dataset; therefore, a proper imputation method is necessary to handle the missingness. An appropriate method is selected based on the types of missingness, defined in the table below. 
| Missing Randomness        | Definition                                                                                                                 |
|--------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| **Missing Completely at Random (MCAR)** | The missingness occurs at random, and its pattern cannot be explained by observed or unobserved data points.             |
| **Missing at Random (MAR)**            | The missingness occurs at random, but its pattern can be explained by other observed data points.                         |
| **Missing Not at Random (MNAR)**       | The missingness is neither MCAR nor MAR; its reasons are directly related to the missing value itself.                   |

**2. Handle missing value** 
Figure illustrates the distribution of missing and non-missing data points by credit categories across duration, age, job and housing categories. The missingness is MCAR because there is no noticeable pattern across the variables. Consequently, instead of introducing an “unknown” category that contributes limited insights to the analysis, k-nearest-neighbors (kNN) imputation is chosen. The kNN imputer estimates the missing values by referencing k most similar data points, then imputing the most frequent value among neighbors to the categorical variables. 
```r
#Replace the missing value by kNN method 
df1 <- df %>% 
  kNN(variable = c("saving_accounts", "checking_account"),
      k = 7)

#Skim through the data after processing
skim(df1)
```
```r
── Data Summary ────────────────────────
                           Values
Name                       df1   
Number of rows             1000  
Number of columns          15    
_______________________          
Column type frequency:           
  factor                   9     
  logical                  2     
  numeric                  4     
________________________         
Group variables            None  

── Variable type: factor ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable    n_missing complete_rate ordered n_unique top_counts                            
1 age_cat                  0             1 FALSE          4 adu: 401, you: 399, stu: 149, sen: 51 
2 duration_cat             0             1 FALSE          3 med: 554, sho: 359, lon: 87           
3 credit_cat               0             1 FALSE          4 low: 251, mod: 250, hig: 250, qui: 249
4 sex                      0             1 FALSE          2 mal: 690, fem: 310                    
5 job                      0             1 FALSE          4 2: 630, 1: 200, 3: 148, 0: 22         
6 housing                  0             1 FALSE          3 own: 713, ren: 179, fre: 108          
7 saving_accounts          0             1 FALSE          4 lit: 779, mod: 105, qui: 67, ric: 49  
8 checking_account         0             1 FALSE          3 lit: 492, mod: 435, ric: 73           
9 purpose                  0             1 FALSE          8 car: 337, rad: 280, fur: 181, bus: 97 

── Variable type: logical ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable        n_missing complete_rate  mean count             
1 saving_accounts_imp          0             1 0.183 FAL: 817, TRU: 183
2 checking_account_imp         0             1 0.394 FAL: 606, TRU: 394

── Variable type: numeric ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate   mean     sd  p0   p25   p50   p75  p100 hist 
1 id                    0             1  500.   289.    1  251.  500.  750.  1000 ▇▇▇▇▇
2 age                   0             1   35.5   11.4  19   27    33    42     75 ▇▆▃▁▁
3 duration              0             1   20.9   12.1   4   12    18    24     72 ▇▇▂▁▁
4 credit_amount         0             1 3271.  2823.  250 1366. 2320. 3972. 18424 ▇▂▁▁▁
```
The result returns no missing value after processing. Further, the bar graph of checking and saving accounts before and after the imputation shows insignificant interquartile and mean changes, though outlier concentration slightly increases. 
<p align="center">
  <img src="https://github.com/user-attachments/assets/15642f0b-1144-4355-b0bf-d895401a64c5" alt="Credit Category Distribution" width="600">
</p>





