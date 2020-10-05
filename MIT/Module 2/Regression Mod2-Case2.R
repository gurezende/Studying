# R Code for a variation of MIT Course Data Science and Bid Data Analytics
#-----------------------------------------------------------------------------
# Case Study 2.2 - Variation
## What is the difference in sleep time between 2 control groups taking different medications?

## Clear workspace
rm(list=ls())

# Load knitr library to print table in the console in a better format
library(knitr)
library(datasets)

# Set Directory
setwd("/Users/santos@us.ibm.com/Downloads/Module2_CS2_Gender-wage-gap")

# Load Dataset and see variables and the number of observations.
data(sleep)
str(sleep)
dim(data)

# Remove column ID
sleep <- sleep[,-3]
# Create new column for the example exercise
sleep$hours <- c(8., 8.5, 9, 8.1, 7., 7., 6., 8., 7., 7.,8.,5.7,8.2,6.7,7.3,9.,10.,7.,7.,7.)
sleep <- sleep[, c(2,1,3)]

# Compute Basic Statistics
mean_g1 <- as.matrix(apply(sleep[sleep$group==1,2:3], 2, mean))
mean_g2 <- as.matrix(apply(sleep[sleep$group==2,2:3], 2, mean))
stats_table <- cbind(mean_g1, mean_g2)



# Print basic stats
colnames(stats_table) = c("Group 1 averages", "Group 2 averages")
print(kable(stats_table))


###########################################
########### Linear Regression #############

lm_model <- lm(extra ~ ., data=sleep)

# Run OlS regression, get coefficients, standard errors and 95% confidence interval
est1 <- summary(lm_model)$coef[2,1:2]
conf_interval1 <- confint(lm_model)[2,]

# Linear regression: Quadratic specification
lm_model2 <- lm(extra ~  group + (hours)^2, data=sleep)

# Run OlS regression, get coefficients, standard errors and 95% confidence interval
est2      <- summary(lm_model2)$coef[2,1:2]
conf_interval2 <- confint(lm_model2)[2,]

#Create table to store regression results
table1     <- matrix(0, 2, 4)
table1[1,] <- c(est1,conf_interval1)
table1[2,] <- c(est2,conf_interval2)

#Give column and  row names
colnames(table1) <- c("Estimate", "Standard Error", "Lower Conf. Bound", "Upper Conf. Bound")
rownames(table1) <- c("basic reg", "flex reg")

View(table1)
print(kable(table1))

"Our conclusion is that the group that took the drug 2 (GROUP 2) has increased, on average, their sleep
in 1.57 hours, being the confidence interval between -0.26 hours to an increase of 3.41 hours."



