#Histogram of Credit Amount, Duration and Age 
  {credit_amount_histogram <- 
    ggplot(df1, aes(x = credit_amount)) + 
    geom_histogram(fill = "#0F4761", alpha = 1, colour = "white") + theme_classic() +
    labs(x = "Credit Amount", y = "Count")+
    theme(
      axis.title = element_text(size = 12, color = "#0F4761"),
      axis.text = element_text(size = 9, color = "#0F4761"))
  
  duration_histogram <- 
    ggplot(df1, aes(x = duration)) + 
    geom_histogram(fill = "#0F4761", alpha = 1, colour = "white") + theme_classic() + 
    labs(x = "Duration (months)", y = "Count")+
    theme(
      axis.title = element_text(size = 12, color = "#0F4761"),
      axis.text = element_text(size = 9, color = "#0F4761"))
  
  age_histogram <- 
    ggplot(df1, aes(x = age)) + 
    geom_histogram(fill = "#0F4761", alpha = 1, colour = "white") + theme_classic() + 
    labs(x = "Age (years)", y = "Count")+
    theme(
      axis.title = element_text(size = 12, color = "#0F4761"),
      axis.text = element_text(size = 9, color = "#0F4761"))
  
  Histogram_of_Credit_Amount_Duration_and_Age <- 
    grid.arrange(credit_amount_histogram,
                 duration_histogram,
                 age_histogram,
                 ncol = 3,
                 top = textGrob("Histograms of Credit Amount, Duration and Age",
                                gp = gpar(fontsize = 15, fontface = "bold", col = "#0F4761")))
  }
#Boxplots of Credit Amount, Duration and Age  
  {credit_amount_boxplot <- 
      ggplot(df1, aes(y = credit_amount)) + 
      geom_boxplot(fill = "#0F4761", alpha = 0.7,
                   outlier.colour =  "#0F4761",
                   color =  "#0F4761") + 
      theme_classic() +
      labs(x = "Credit Amount", y = "Credit Amount")+
      theme(
        axis.title = element_text(size = 10, color = "#0F4761"),
        axis.text = element_text(size = 9, color = "#0F4761"))
      
    
    duration_boxplot <- 
      ggplot(df1, aes(y = duration)) + 
      geom_boxplot(fill = "#0F4761", alpha = 0.7,
                   outlier.colour =  "#0F4761",
                   color =  "#0F4761") + 
      theme_classic() +
      labs(x = "Duration", y = "Months")+
      theme(
        axis.title = element_text(size = 10, color = "#0F4761"),
        axis.text = element_text(size = 9, color = "#0F4761"))
    
    age_boxplot <- 
      ggplot(df1, aes(y = age)) + 
      geom_boxplot(fill = "#0F4761", alpha = 0.7,
                   outlier.colour =  "#0F4761",
                   color =  "#0F4761") + 
      theme_classic() +
      labs(x = "Age", y = "Years")+
      theme(
        axis.title = element_text(size = 10, color = "#0F4761"),
        axis.text = element_text(size = 9, color = "#0F4761"))
    
    Boxplots_of_Credit_Amount_Duration_and_Age <- 
      grid.arrange(credit_amount_boxplot,
                   duration_boxplot,
                   age_boxplot,
                   ncol = 3,
                   top = textGrob("Boxplots of Credit Amount, Duration and Age",
                                  gp = gpar(fontsize = 11, fontface = "bold", col = "#0F4761")))
  }
  
  
  
