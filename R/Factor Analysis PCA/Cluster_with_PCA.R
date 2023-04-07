CLUSTERING WITH PCA
"The library Psych in R allows us to cluster values based on PCA scores"
------------------------------------------------------------------------

# Loading libraries
library(psych)
library(tidyverse)
library(ggrepel)
library(ggthemes)

# Data
data("mtcars")

# PCA using only MPG and HP of the cars
# Rotation 'cluster' to find the best matches
pca <- pca(mtcars[,c(1,4)], rotate='cluster')

# Add clusters
mtcars <- mtcars %>% # dataset
  rownames_to_column('car') %>%  #names of the cars to a column
  mutate(scores = unlist(pca$scores), #add columns scores and cluster
         cluster = cut(scores, breaks=3, labels=c("1","2","3")) )

#Plot
ggplot(mtcars, aes(x=mpg, y=hp, label=car)) +
  geom_point(aes(color= cluster)) +
  geom_text_repel() + 
  theme_stata()
