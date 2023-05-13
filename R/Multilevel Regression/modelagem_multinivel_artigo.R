library(nlme)
library(tidyverse)
library(ggridges)
library(patchwork)
library(viridis)
library(hrbrthemes)


# Function to calculate RMSE
rmse <- function(y, y_hat) {
  return(
    sqrt(
      mean( (y - y_hat)**2   ) 
    )
  )
}


# Function to calculate RMSE
mae <- function(y, y_hat) {
  return(
    mean( abs(y - y_hat)   ) 
    )
}



# Dataset
data("Gasoline")

# Check for the best correlations
cor(Gasoline[,-3])

#Plot Regression
ggplot(Gasoline, aes(x= endpoint, y= yield)) +
  geom_smooth( method='lm', formula = y ~ x, se=F)+
  geom_point(size=3) +
  scale_colour_viridis_d() +
  theme_classic()

#plot MLE
ggplot(Gasoline, aes(x= endpoint, y= yield, color= Sample)) +
  geom_smooth( method='lm', formula = y ~ x, se=F)+
  geom_point(size=3) +
  scale_colour_viridis_d() +
  theme_classic()

# Plot distributions
ggplot(Gasoline, aes(x = yield, y = Sample, fill = ..x..)) +
  geom_density_ridges_gradient(scale = 3, rel_min_height = 0.01) +
  scale_fill_viridis(name = "yield", option = "turbo", direction = -1) +
  labs(
    title = "Distributions of the variable y: 'yield' for each sample",
    x = "yield",
    y = "Endpoint") +
  theme_ipsum() +
  theme(
    legend.position="none",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 5)
  )


# OLS model
model_ols <- lm(yield ~ endpoint, data=Gasoline)
summary(model_ols)

# RMSE
rmse(Gasoline$yield, model_ols$fitted.values)
mae(Gasoline$yield, model_ols$fitted.values)
sd(Gasoline$yield)
# Loglik
logLik(model_ols)

#-------------
# OLS model2
model_ols2 <- lm(yield ~ endpoint + vapor, data=Gasoline)
# Loglik
logLik(model_ols2)

#-------------
# Null Multilevel Model
model_null <- lme(fixed = yield ~ 1, 
                        random = ~ 1 | Sample,
                        data = Gasoline,
                        method = "REML") #restricted estimation of maximum likelihood (Gelman)

#Parameter model
summary(model_null)
# Log like
logLik(model_null)

#-------------
# Multilevel Model with fixed slope and random intercept
model_multi <- lme(fixed = yield ~ endpoint,
                       random = ~ 1 | Sample,
                       data = Gasoline,
                       method = "REML")

#-------------
# Multilevel Model with random slope and intercept
model_multi2 <- lme(fixed = yield ~ endpoint + vapor,
                   random = ~ endpoint | Sample,
                   data = Gasoline,
                   method = "REML")

summary(model_multi)
logLik(model_multi2)

#-------------
# Results fitted values comparative table
results <- data.frame(
  yield = Gasoline$yield,
  pred_ols = model_ols$fitted.values,
  pred_ols2 = model_ols2$fitted.values,
  pred_multi = model_multi$fitted[,'Sample'],
  pred_multi2 = model_multi2$fitted[,'Sample']
)


### Evaluation ####

# Summary of the data
summary(Gasoline$yield)

# Performance Comparison
View(data.frame(
  model = c('OLS_endpt', 'OLS_endpt+vapor', 'HLM_endpt', 'HLM_endpt+vapor'),
  LogLik = c(logLik(model_ols)[1], logLik(model_ols2)[1], 
             logLik(model_multi)[1], logLik(model_multi2)[1]),
  MAE = c(mae(results$yield, results$pred_ols),mae(results$yield, results$pred_ols2),
          mae(results$yield, results$pred_multi),mae(results$yield, results$pred_multi2)),
  RMSE = c(rmse(results$yield, results$pred_ols),rmse(results$yield, results$pred_ols2),
           rmse(results$yield, results$pred_multi),rmse(results$yield, results$pred_multi2))
)
)


## Gaphic Comparisons

# Plot ols
g1 <-  ggplot(results) + 
  geom_point( aes(x= yield, y= pred_ols),
              size=3, color='tomato', alpha=0.8 ) +
  geom_abline(lwd=1, lty=2, color='gray10') +
  ggtitle('Actuals vs Predictions | OLS') +
  theme_gdocs()

# Plot ols2
g2 <-  ggplot(results) + 
    geom_point( aes(x= yield, y= pred_ols2),
                size=3, color='purple', alpha=0.8 ) +
    geom_abline(lwd=1, lty=2, color='gray10') +
    ggtitle('Actuals vs Predictions | OLS Endpt+vapor') +
  theme_gdocs()

# Plot multilevel1
g3 <-  ggplot(results) + 
  geom_point( aes(x= yield, y= pred_multi),
              size=3, color='blue', alpha=0.8 ) +
  geom_abline(lwd=1, lty=2, color='gray10') +
  ggtitle('Actuals vs Predictions | HLM Endpt') +
  theme_gdocs()

# Plot multilevel2
g4 <-  ggplot(results) + 
  geom_point( aes(x= yield, y= pred_multi2),
              size=3, color='forestgreen', alpha=0.8 ) +
  geom_abline(lwd=1, lty=2, color='gray10') +
  ggtitle('Actuals vs Predictions | HLM Endpt+vapor') +
  theme_gdocs()

# Patchwork
(g1|g2) / (g3|g4)
