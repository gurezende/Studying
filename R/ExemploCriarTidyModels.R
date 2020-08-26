library(tidyverse)
library(tidymodels)
library(ggpubr)
library(corrplot)


data("quakes")

head(quakes)

df <- quakes %>% select(-lat, -long)

#missing data
sum(is.na(df))
'No missing data'

# plot ggplot2 magnitude vs depth and mag vs stations
g1 = ggplot(data = df, aes(x=mag, y = stations)) +
  geom_point(color = 'red', alpha = 0.8) +
  geom_smooth(method = 'lm') + ggtitle('Quantas Estações reportaram a Magnitude do Terremoto')

g2 = ggplot(data = df, aes(x=mag, y = depth)) +
  geom_point(color = 'coral2', alpha = 0.8) +
  geom_smooth(method = 'lm') + ggtitle('Profundidade vs. a Magnitude do Terremoto')
ggarrange(g1, g2, ncol = 2, nrow = 1)

#correlação
corrplot(cor(df), method='circle', type='lower', addCoef.col = "orange")


# Split treino teste
quakes_split <- initial_split(df, strata = mag)
quakes_train <- training(quakes_split)
quakes_teste <- testing(quakes_split)


#Criando booststrap: separa os dados em vários samples
quakes_boot <- bootstraps(quakes_train)
quakes_boot


#Regressão Linear
#------
# creating instancia
modelo_linear <- linear_reg() %>%
  set_engine('lm')
model

# criando workflow
quakes_wf <- workflow() %>%
  add_formula(mag ~ .)
quakes_wf

# Fit do modelo
quakes_rs <- quakes_wf %>%
  add_model(modelo_linear) %>%
  fit_resamples(resamples = quakes_boot,
                control = control_resamples(save_pred = TRUE))

quakes_rs

# Avaliando
collect_metrics(quakes_rs)


#####
#####
#Random Forest
#------

#instancia
modelo_rf <- rand_forest() %>%
  set_mode('regression') %>%
  set_engine('ranger')

#workkflow
quake_wf <- workflow() %>%
  add_formula(mag ~ .)

#fit modelo
rf_rs <- quake_wf %>%
  add_model(modelo_rf) %>%
  fit_resamples(resamples = quakes_boot,
                control = control_resamples(save_pred = TRUE))

# Avaliacao
collect_metrics(rf_rs)


#######

#Last Fit Linear Model
quakes_final <- quakes_wf %>%
  add_model(modelo_linear) %>%
  last_fit(quakes_split)

quakes_final$.predictions

test_results <- data.frame(quakes_final$.predictions)
