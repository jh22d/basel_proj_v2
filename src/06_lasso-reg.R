library(glmnet)
library(tidyverse)
data <- read.csv("data/processed/df_for_stata.csv")

# OLS Significant check
summary(lm(y~x)) # rir and year not significant


# Lasso Variable selection
data_narm <- data%>% filter(complete.cases(.))
x <- data_narm %>% 
  select(
    # "t1cr"
         ,"stock_price"
         ,"mkt_cap"
         # ,"leverage_ratio"
         , "adj_ebitda"
         # ,"log_t1c_B"
         ,"GSIB", "rir","gdp","cpi"
         # ,"year"
         # ,"country","bank","Group"
         ) %>% 
  as.matrix() 
y <- data_narm$roe

#perform k-fold cross-validation to find optimal lambda value
cv_model <- cv.glmnet(x,y,alpha = 1)

#find optimal lambda value that minimizes test MSE
lambda_best <- cv_model$lambda.min
lambda_best

lambda_1se <- cv_model$lambda.1se
lambda_1se

#produce plot of test MSE by lambda value
plot(cv_model)

#find coefficients of best model
best_model <- glmnet(x, y, alpha = 1)
coef(best_model)
coef(cv_model, s = "lambda.1se") 

