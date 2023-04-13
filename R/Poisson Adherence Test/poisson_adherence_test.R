# observed frequencies
"Choose one of the two options: (1) Write your data counts as a vector or (2) use table to create a contingency table
# (1)
obs_freq <- c(3686, 3657, 1300  ,292 ,  57 ,   8 )
# (2)
obs_freq <- table(r)


# expected frequencies from Poisson distribution with lambda = 1.7401
k <- 0:8 #use the same range from your values
exp_freq <- dpois(k, 1.7401) * sum(obs_freq)
alpha <- 0.05

# calculate chi-square statistic and p-value
chi2_statistic <- sum((obs_freq - exp_freq)^2 / exp_freq)
df <- length(obs_freq) - 1  # degrees of freedom
p_value <- 1 - pchisq(chi2_statistic, df)
crit_value <- qchisq(1 - alpha, df)

# print results
cat("Observed frequencies:", obs_freq, "\n")
cat("Expected frequencies:", exp_freq, "\n")
cat("Chi-square statistic:", chi2_statistic, "\n")
cat("Degrees of freedom:", df, "\n")
cat("p-value:", p_value, "\n")
cat("Critical value:", crit_value, "\n")
