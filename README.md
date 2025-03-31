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



