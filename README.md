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
1. Import packages
```
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
2. Load the data
```
German_Credit_Dataset <- read_csv("German Credit Dataset.csv", 
                                      na = "NA")
```
3. Create a datafram for the analysis
```
df <- German_Credit_Dataset %>% 
  unique()
```
4. Summary table of variables

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


### Data Cleaning
1. Skim through the data
```
skim(German_Credit_Dataset)
```
```
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



