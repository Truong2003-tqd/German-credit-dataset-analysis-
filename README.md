# Overview
Welcome to my analysis of German Credit dataset, which sourced from [Kaggle - German Credit Risk](https://www.kaggle.com/datasets/uciml/german-credit), containing customers' information on age, duration, credit amount, checking and savings account statuses, job and housing status, and purposes. The report examines the lending strategy of the bank in the German credit dataset, established in 1990, one year after the fall of the Berlin Wall. This dataset has 10 variables and 1000 rows, a modified version of the German credit dataset created in 1994 with 20 variables. Table 1 provides descriptions and the types of each variable. The Deutsche Mark was the official currency of Germany from 1948 until being replaced by Euro in 2002. In the 1990s, Germany experienced different key socio-economic events, including the reunification and the end of the Cold War, challenging the German financial system.

| Variable           | Variable Type | Description                                                                 |
|--------------------|----------------|-----------------------------------------------------------------------------|
| id                 | Numeric        | Customers’ ID                                                              |
| age                | Numeric        | Customers’ age                                                             |
| sex                | Character      | Gender: male or female                                                     |
| job                | Numeric        | Employment type:<br>0 - Unskilled, non-resident<br>1 - Unskilled, resident<br>2 - Skilled<br>3 - Highly skilled |
| housing            | Character      | Housing status: own, rent, or free                                         |
| saving_accounts    | Character      | Savings: little, moderate, quite rich, rich, unknown                       |
| checking_account   | Character      | Checking: little, moderate, rich, unknown                                  |
| credit_amount      | Numeric        | Credit amount (in Deutsche Marks - DM)                                     |
| duration           | Numeric        | Loan duration (in months)                                                  |
| purpose            | Character      | Loan purpose: radio/TV, education, furniture/equipment, car, business, domestic appliances, repairs, vacation/others |
  


# The Questions
Below are questions I want to answer in my project:
1) Who were the primary customers in this credit portfolio? 
2) Are there any unusual patterns in the data, and what can explain their occurrences?
3) Which factors most influenced the bank’s lending decisions and how consistent were they?

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
This section outline steps taken to prepare and clean the data to ensure high accuracy and usability. View my code with detailed steps here: [1. Pre-processing.R](https://github.com/Truong2003-tqd/German-credit-dataset-analysis-/blob/4011ed4459def0bc822990ee4412a1bfa968dc04/1.%20Pre-processing.R)

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
This table describes the original meaning and data type of each variable.

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

**Table.** Summary table of variables


**5. Convert categorical variables to factor data type**

Categorical variables, including sex, job, saving_accounts, checking_account and purpose, are converted into factor variables to support the analysis with accurate statistics. Regarding housing, unique observations are arranged based on the perceived customer risks following the ascending order from “own”, “free” to “rent”.

```r
#Convert into categorical variables
df$sex <- factor(df$sex, levels = c("male", "female"))
df$job <- as.factor(df$job)
df$housing <- factor(df$housing, levels = c("own", "free","rent"))
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

To facilitate the analysis, credit amount, age and duration are discretized into different categories. The credit amount is segmented into 4 categories using the 1st, 2nd and 3rd quantiles for the intervals, allowing for meaningful analysis across segments.
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

**Table.** New category table 

### Data Cleaning
View the detailed code here: [2. Missing values handling.R](https://github.com/Truong2003-tqd/German-credit-dataset-analysis-/blob/4011ed4459def0bc822990ee4412a1bfa968dc04/2.%20Missing%20values%20handling.R)

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
The data has 183 and 394 missing values in saving_account and checking_account, respectively. Missing data can arise from human error, machine malfunctions or respondents' refusal to answer. The removal of a significant number of missing values will substantially reduce the sample size and distort the underlying patterns; therefore, a proper imputation method is necessary to handle the missingness. An appropriate method is selected based on the types of missingness, defined in the table below. 
| Missing Randomness        | Definition                                                                                                                 |
|--------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| **Missing Completely at Random (MCAR)** | The missingness occurs at random, and its pattern cannot be explained by observed or unobserved data points.             |
| **Missing at Random (MAR)**            | The missingness occurs at random, but its pattern can be explained by other observed data points.                         |
| **Missing Not at Random (MNAR)**       | The missingness is neither MCAR nor MAR; its reasons are directly related to the missing value itself.                   |

**2. Handle missing value** 

Figures below illustrate the distribution of missing and non-missing data points by credit categories across duration, age, job and housing categories. The missingness is MCAR because there is no noticeable pattern across the variables.
<p align="center">
  <img src="https://github.com/user-attachments/assets/4ba88876-2653-4852-bfbb-f3df958a23cf" alt="Centered Image">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/d10cab87-9a5d-48f5-a92d-6d5b5983afb4" alt="Centered Image">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/75a356f1-cd0f-4614-910c-391e0b693082" alt="Centered Image">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/34ff6bab-b6c5-4896-af79-1a968337a2b2" alt="Centered Image">
</p>

Consequently, instead of introducing an “unknown” category that contributes limited insights to the analysis, k-nearest-neighbors (kNN) imputation is chosen. The kNN imputer estimates the missing values by referencing k most similar data points, then imputing the most frequent value among neighbors to the categorical variables. 

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
The result returns no missing value after processing. After the imputation, the distribution of the data is largely preserved. While the changes of medians and IQRs are insignificant, outlier concentration slightly increases, which is acceptable in an exploratory data analysis. 
<p align="center">
  <img src="https://github.com/user-attachments/assets/15642f0b-1144-4355-b0bf-d895401a64c5" alt="Credit Category Distribution" width="600">
</p>

**3. Handle outliers**

View the detailed code here: [3. Handle outliers .R](https://github.com/Truong2003-tqd/German-credit-dataset-analysis-/blob/b1193f0af6fcd62254d03599ad867a881707705b/3.%20Handle%20outliers%20.R)

Due to the left-skewed distributions of credit amount, duration and age, using the boxplot is the best way to detect outliers.
<p align="center">
  <img src="https://github.com/user-attachments/assets/d6f1edea-4683-47f9-8e8f-b4e5c6dd21f0" alt="Credit Category Distribution" width="600">
</p
  
In R, the boxplot determines lower and upper bounds for the dataset by using equations 1 and 2. 

(1) Lower bound=Q1-1.5*IQR 

(2) Upper bound=Q3+1.5*IQR 

These outliers naturally represent customers and loan profiles rather than error. Methods, such as outlier deletion or winsorization, replacing outliers with less extreme values, unnecessarily distort the underlying data trend. Therefore, these outliers are treated as special customer segments to explore insights about the lending strategy.  
<p align="center">
  <img src="https://github.com/user-attachments/assets/2329a892-cafa-4f1d-abc1-e4c0ce3dcaeb" alt="Centered Image">
</p>

# Data Exploration
Banks assess risk profile using financial health, cash flow stability and mortgage assets. In the context of this dataset, financial health can be assessed by checking and savings account balances; high balances may indicate stronger financial health. Next, cash flow stability and mortgage assets are assessed through job and housing variables. The highly skilled workers are paid higher salaries, indicating better financial stability. Further, house ownership serves as a tangible collateral asset, reducing the loan risk. Regarding observations of the housing variable, customers with the “own” status seemly have the lowest risk. In this analysis, credit_amount is the most important variables used to dive deeper into the data.

View the detailed steps here: [4. Measure of Association.R](https://github.com/Truong2003-tqd/German-credit-dataset-analysis-/blob/b1193f0af6fcd62254d03599ad867a881707705b/4.%20Measure%20of%20Association.R), [5. Relationship with duration](https://github.com/Truong2003-tqd/German-credit-dataset-analysis-/blob/b1193f0af6fcd62254d03599ad867a881707705b/5.%20Relationship%20with%20Duration.R), [6. Relationship with checking and savings accounts.R](https://github.com/Truong2003-tqd/German-credit-dataset-analysis-/blob/b1193f0af6fcd62254d03599ad867a881707705b/6.%20Relationship%20with%20checking%20and%20savings%20accounts.R), [7. Relationship with purpose.R](https://github.com/Truong2003-tqd/German-credit-dataset-analysis-/blob/b1193f0af6fcd62254d03599ad867a881707705b/7.%20Relationship%20with%20purpose.R), [8. Relationship with housing.R](https://github.com/Truong2003-tqd/German-credit-dataset-analysis-/blob/b1193f0af6fcd62254d03599ad867a881707705b/8.%20Relationship%20with%20housing.R), [9. Relationship with job.R](https://github.com/Truong2003-tqd/German-credit-dataset-analysis-/blob/b1193f0af6fcd62254d03599ad867a881707705b/9.%20Relationship%20with%20job.R)

## Measure of Association
Strong correlation highlights meaningful dependency and deviations between variables, thereby revealing significant irregularities. The correlation matrix indicates a moderate to strong positive relationship (0.62) between credit amount and duration. The coefficient is statistically significant because of a p-value < 0.05 and a t-value > 1.96. Therefore, the duration category and duration are primary indicators for understanding the bank and its customers. 
Regarding observations of the housing variable, the “own” housing status exhibits the lowest risk, thereby tending to receive larger loans. However, the correlation suggests no dependency between variables, indicating the low influence of housing on lending decisions. The correlation matrix also demonstrates a statistically significant positive relationship between credit amount and job. As correlation analysis is not applicable to nominal variables, visualizations and frequency analysis will examine the relationship between purpose and credit_amount.
<p align="center">
  <img src="https://github.com/user-attachments/assets/598309ef-ffbe-4184-9299-67019a37a383" alt="Centered Image">
</p>
  
| Variables                  | t-value | p-value | Correlation (r) |
|----------------------------|---------|---------|------------------|
| credit_amount vs duration  | 25.29   | < 0.01  | 0.62             |
| credit_amount vs job       | 9.41    | < 0.01  | 0.29             |
| credit_amount vs housing   | 5.50    | 0.00    | 0.17             |

**Table.** Table of correlation test of each variable

## Relationship with duration 
The ascending medians and IQRs across duration categories confirm the positive relationship between credit_amount and duration. Outliers cluster in short and medium-term loans, with only one in the long-term category. These outliers are extracted and analyzed throughout the report to identify potential policy gap. 
```r
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
```

There are 2 reasons behind the existence of these outliers: 
1) The extremely high-value loans might result from a poor customer evaluation
2) The outliers might have a low risk profile, reflected by high account balances, stable income and valuable collateral assets.

<p align="center">
  <img src="https://github.com/user-attachments/assets/e2482471-92b2-4b79-b7c7-31e311a92590" alt="Centered Image">
</p>

## Relationship with checking and savings accounts
The figure highlights that most customers have low to moderate savings and checking balances, who are regarded as having low balances throughout the report. Most outliers are distributed primarily among these groups, posing a high-risk exposure. From the risk management perspective, the low balance is an indicator of weak financial health (ADBC n.d.). However, low checking and savings balances unnecessarily result from poor financial status because customers may prioritize alternative investments (JP Morgan 2025). This latter fact is partly proven by the negligible correlations between credit amount and these two variables, suggesting that the account balances were insufficient creditworthiness predictors. 

<p align="center">
  <img src="https://github.com/user-attachments/assets/5fabef42-ad86-46d5-9e5f-b86550e9b294" alt="Centered Image">
</p>

“Radio/TV”, “furniture/equipment”, “domestic appliances”, and “repairs” observations are grouped into an aggregated “household” observation to facilitate data visualization and interpretation. Household, car and business groups are the dominant purposes of the dataset. Further breakdown reveals that the outliers primarily borrowed for these purposes, which span a wide range from short-term to long-term durations. The breakdown suggests no significant patterns between account balance and the loan value, suggesting account balance was not a sufficient creditworthiness predictor. 
<p align="center">
  <img src="https://github.com/user-attachments/assets/60ac5ba0-aa3e-450d-b3ae-fdc2b95143e4" alt="Centered Image">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/1e084301-96b1-43d4-bbb6-1f3befce0ad2" alt="Centered Image">
</p>

## Relationship with housing status
Homeowners account for the largest proportion of both customer volume and total granted credit amount. 
<p align="center">
  <img src="https://github.com/user-attachments/assets/802c02ea-4b32-4489-b5eb-fe4bd3c9c30b" alt="Centered Image" width = "600">
</p>

However, the “free” housing group has significantly higher average credit amounts in both the full dataset and within the outliers. Therefore, these visualizations validated the absence of a linear relationship between these 2 variables. The findings suggest that property ownership might not be mandatory in the bank’s lending policy.

<p align="center">
  <img src="https://github.com/user-attachments/assets/640721c9-0da8-4e6e-aebd-55c231fb57be" alt="image" width = "600"/>
</p>

A significant number of outlier loans were granted to homeowners for business, household and vacation.

<p align="center">
  <img src="https://github.com/user-attachments/assets/56b23dbe-c1e8-4b4e-98bc-2508189a302f" alt="image" width = "600"/>
</p>

In contrast, outlier car loans were granted to all customers, primarily to non-renters. Although there was no direct relationship with housing, the bank might informally favor homeowners for high-value consumption and business loans. From a risk management perspective, possession of greater net worth indicates a sign of stability and strong repayment ability. On the other hand, the broad accessibility of auto loans can be explained by the requirement of pledging the car as collateral. The practice is common to mitigate the default risk through movable asset collateral rather than homeownership.

<p align="center">
  <img src="https://github.com/user-attachments/assets/5a1e58f2-21eb-4f17-9d1f-4309c3bc5998" alt="image" width = "600" />
</p>

## Relationship with job status
High-skilled workers constitute the largest component of customers. Most outlier loans were also granted to these customers, indicating the bank’s confidence in customers' repayment ability, resulting from strong and stable cash flow. Therefore, the findings validated the positive relationship between the credit amount and job status. 

<p align="center">
  <img src="https://github.com/user-attachments/assets/eb020310-af83-4bb8-809e-3ed867085b5a" alt="image" />
</p>

The IQRs of groups 0, 1 and 2 are closely aligned, suggesting a low variability between groups, thereby contributing to the weak correlation.

<p align="center">
  <img src="https://github.com/user-attachments/assets/083a8d61-15ca-454b-accf-edb491659406" alt="image" />
</p>

Further analysis uncovers different housing distributions within each group. While most low-skilled outliers are homeowners, housing status among the high-skilled ones varies. The findings highlight the flexible risk evaluation, which alternated between employment profile and housing status when granting high-value loans. 

<p align="center">
  <img src="https://github.com/user-attachments/assets/9e09b139-85b4-44a8-9e01-4d5b49541b75" alt="image" />
</p>

# Discussion
The analysis reveals insightful findings of the bank’s lending and risk evaluation strategy during the period of economic restructuring after reunification. The primary customer groups were homeowners and high-skill laborers. Having analyzed the outliers, the findings suggest a dual-path evaluation approach in which either job quality or housing stability could be satisfied. Regarding the context, account balances alone could not fully reflect the repayment ability. The tension during the Cold War posed the risks of military wars, thereby triggering investment into gold or secured assets to protect their wealth instead of depositing money into banks.

<p align="center">
  <img src="https://github.com/user-attachments/assets/e06841b4-7c28-48f1-a504-754433885314" alt="image" />
</p>

**Figure.** Gold Price chart [(Gold Price 2025)](https://goldprice.org/)

Because of the high unemployment rate after reunification, the bank attempted to boost household consumption and entrepreneurship with flexible approaches.  However, the lending policy for household, business and vacation appeared to depend on the perceived customer stability, emphasizing a quantitative approach for creditworthiness assessment. Therefore, a more transparent and quantifiable credit assessment should be adopted to mitigate default risks.

# Conclusion

Although statistical measurements are weak and inconclusive, analyzing the outliers who unexpectedly received loans, reveals the lending decisions that focused the evaluation of either job quality or housing statbility rather than bank account balance. The flexibility in lending strategy resulted from the period of economic instability after the German reunification which triggered a spike in the unemployment rate and an economic downturn. In this context, the loose lending policy might have aim to boost economic growth by increasing household consumption and fostering entrepreneurship. 























