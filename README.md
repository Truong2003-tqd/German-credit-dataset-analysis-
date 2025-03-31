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

**3. Handle outliers**
Due to the left-skewed distributions of credit amount, duration and age, using the boxplot is the best way to detect outliers.
<p align="center">
  <img src="https://github.com/user-attachments/assets/d6f1edea-4683-47f9-8e8f-b4e5c6dd21f0" alt="Credit Category Distribution" width="600">
</p
  
In R, the boxplot determines lower and upper bounds for the dataset by using equations 1 and 2. 
(1) Lower bound=Q1-1.5*IQR 
(2) Upper bound=Q3+1.5*IQR 
Because the outliers are natural, retaining them is the best strategy to explain the unusual patterns. Overall loan risk, the bank’s policy and customers’ profile are explored by analyzing these outliers. Other methods, such as removal or winsorization, replacing outliers with less extreme values, will unnecessarily distort the original meaning of the dataset. 
<p align="center">
  <img src="https://github.com/user-attachments/assets/2329a892-cafa-4f1d-abc1-e4c0ce3dcaeb" alt="Centered Image">
</p>

# Data Exploration
Banks assess risk profile using financial health, cash flow stability and mortgage assets. In the context of this dataset, financial health can be assessed by checking and savings account balances; high balances may indicate stronger financial health. Next, cash flow stability and mortgage assets are assessed through job and housing variables. The highly skilled workers are paid higher salaries, indicating better financial stability. Further, house ownership serves as a tangible collateral asset, reducing the loan risk. Regarding observations of the housing variable, customers with the “own” status seemly have the lowest risk. 

## Correlation Coefficients
Correlation coefficients are useful for demonstrating the relationship between variables. Therefore, it is suitable to select the most important variables to dive deeper into the dataset. Figure indicates a moderate to strong positive relationship (0.62) between credit amount and duration. The coefficient is statistically significant because of a p-value < 0.05 and a t-value > 1.96 (Appendix). Therefore, the duration category is selected to demonstrate the distribution and explore the profile of outliers. The correlation matrix also highlights noticeable positive relationships between credit amount, duration, job, and housing, which are also statistically significant. Although the correlation coefficient is quite low, it implies that the bank offered longer-term, higher-value loans to skilled customers
<p align="center">
  <img src="https://github.com/user-attachments/assets/598309ef-ffbe-4184-9299-67019a37a383" alt="Centered Image">
</p>
  
| Variables                  | t-value | p-value | Correlation (r) |
|----------------------------|---------|---------|------------------|
| credit_amount vs duration  | 25.29   | < 0.01  | 0.62             |
| credit_amount vs job       | 9.41    | < 0.01  | 0.29             |
| credit_amount vs housing   | 5.50    | 0.00    | 0.17             |
| duration vs job            | 6.82    | 0.00    | 0.21             |
| duration vs housing        | 4.38    | 0.00    | 0.14             |

**Table.** Table of correlation test of each variable

## Relationship with duration 
The ascending mean values confirm the positive relationship between credit amount and duration. However, outliers cluster in short and medium-term loans, with only one in the long-term category. There are 2 possible scenarios explaining the distribution: 
1) The outliers are fraudulent loans because they are significantly different from other customers.
2) These customers have a lower risk profile, proven by stable income and valuable collateral assets
Further analysis is conducted to determine the outliers’ profiles and the loan purposes to assess the overall risk of this portfolio.
<p align="center">
  <img src="https://github.com/user-attachments/assets/e2482471-92b2-4b79-b7c7-31e311a92590" alt="Centered Image">
</p>

## Relationship with checking and savings accounts
The figure highlights that most customers have low savings and checking balances. Further, outliers are distributed primarily among these groups. Low balances may imply weak financial health, posing potential repayment risk. However, low checking and savings balances unnecessarily result from poor financial status because customers may prioritize alternative investments or prefer using cash. Therefore, other factors need to be assessed to have a better understanding. 
<p align="center">
  <img src="https://github.com/user-attachments/assets/5fabef42-ad86-46d5-9e5f-b86550e9b294" alt="Centered Image">
</p>

## Relationship with purpose
“Radio/TV”, “furniture/equipment”, “domestic appliances", and "repairs" observations are grouped into the “household” observation to facilitate the data visualization and interpretation. Household, car and business groups are dominant purposes of the dataset. Car and business purposes have a high proportion of outliers in the total credit amount, which spread widely from short to long-term duration. 
<p align="center">
  <img src="https://github.com/user-attachments/assets/60ac5ba0-aa3e-450d-b3ae-fdc2b95143e4" alt="Centered Image">
</p>

Car and business outlier loans were given to customers with low account balances (Figure). There are two possible reasons behind these findings: this bank had poor risk assessment, or it prioritized using job and housing status to offer loans.
<p align="center">
  <img src="https://github.com/user-attachments/assets/1e084301-96b1-43d4-bbb6-1f3befce0ad2" alt="Centered Image">
</p>

## Relationship with job status
The figure indicates that the bank primarily offered higher-value, longer-term loans to customers with high-skilled jobs. High-skilled workers tended to receive higher salaries and have better job security, suggesting a strong and stable cash flow.
<p align="center">
  <img src="https://github.com/user-attachments/assets/7cfa648e-6192-4b05-a366-eee95506ae41" alt="Centered Image">
</p>

Noticeably, most outlier loans were borrowed by customers belonging to this group. All purposes share a similar pattern in the distributions of outliers which indicates a clear loan policy giving large loans to low-risk customers. This marks the focus on repayment ability over account balances.
<p align="center">
  <img src="https://github.com/user-attachments/assets/93166f2a-8ac8-4e47-9afe-046ba4e2d362" alt="Centered Image">
</p>

## Relationship with housing status
Overall, most loans were granted to customers with house ownership. Bars’ magnitude indicates that homeowners could receive urgent and high-value loans secured by real estate ownership. Thus, the bank’s policy might favor homeowners, who had good housing stability and more disposable income, to minimize the loans’ default risks. 
<p align="center">
  <img src="https://github.com/user-attachments/assets/802c02ea-4b32-4489-b5eb-fe4bd3c9c30b" alt="Centered Image">
</p>

The extreme consumer debts from household and vacation purposes may indicate poor financial planning among these customers. Further, business loans are associated with risks of poor business performance affecting repayment ability. Therefore, the bank needed valuable collateral assets to mitigate the inherent risks of poor financial management. Regarding car loan outliers, customers were primarily non-renter from the “own” and “free” housing groups. Although car loans outliers were high value, posing repayment risk, customers having a free house were still granted high-value loans. The finding is explainable because loans are usually secured by the car itself (Figure). Therefore, lending to non-renters appeared to be safe due to their low monthly expenses, guaranteeing loan repayment. 
<p align="center">
  <img src="https://github.com/user-attachments/assets/37994493-7907-49cd-8f75-385a8ae0ecf7" alt="Centered Image">
</p>

# Conclusion
The analysis highlights the bank's comprehensive lending strategies which involved through customer evaluation and lending conditions. The extremely high-value loans reflected a strategic lending approach rather than being indicators of fraud or poor evaluation. High credit amount loans were usually tied with longer duration to ensure the customers' repayment abilities. Although the presence of extremely high-value loans, the portfolio had a low-to-moderate risk thanks to a comprehensive risk evaluation. The loan policy was clear that income level, housing security and purposes were important factors to decide the loans’ values, duration and purposes. Although thge majority of the portfolio was accounted by customers who had low account balance, they were high-skilled and owning a house. It may indicate a preference of using cash, which was suitable to the 1990s context of the dataset. Further, these high-skilled customers might prefer altertive investing instead of depositing money into their savings account. While house ownership was a must-have in high-value consumption loans, it was a nice-to-have in car loans because the cars themselves were collateral assets. This approach might help the banks secure its loan portfolio by leveraging collateral and assessing customers’ profiles carefully.
























