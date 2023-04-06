library(psych)
library(tidyverse)

data("mtcars")

# Bartlett Test
cortest.bartlett(mtcars)

#PCA with all the 11 components
pca <- pca(mtcars, nfactors=dim(mtcars)[2], rotate='none')
prin <- pca(mtcars, nfactors=dim(mtcars)[2], rotate='varimax')

# Scree Plot
barplot(pca$Vaccounted[2,], col='purple')

# Eigenvalues
pca$values
prin$values

# Proportion of variance captured by each component
pca$Vaccounted
prin$Vaccounted


# PCA after Kaiser's rule applied: Keep eigenvalues > 1
pca2 <- pca(mtcars, nfactors=2, rotate='none')
prin2 <- pca(mtcars, nfactors=2, rotate='varimax')

# Comparison of communalities (Variance captured of each variable)
communalities <- as.data.frame(unclass(pca2$communality)) %>%
  rename(comm_no_rot = 1) %>%
  cbind(unclass(prin2$communality)) %>% 
  rename(comm_varimax = 2)


# PCA Not rotated Loadings (how correlated to the PCs)
loadings <- as.data.frame(unclass(pca2$loadings))
loadings <- loadings %>% rownames_to_column('vars')

# Plot variables
ggplot(loadings, aes(x = PC1, y = PC2, label = vars))+
  geom_point(color='purple', size=8)+
  geom_text_repel() +
  theme_classic()


# PCA Rotated Loadings
loadings2 <- as.data.frame(unclass(prin2$loadings))
loadings2 <- loadings2 %>% rownames_to_column('vars')

# Plot variables
ggplot(loadings2, aes(x = RC1, y = RC2, label = vars))+
  geom_point(color='tomato', size=8)+
  geom_text_repel() +
  theme_classic()

### Rankings ####

#Prop. Variance Not rotated
variance <- pca2$Vaccounted[2,]

# Scores
factor_scores <- as.data.frame(pca2$scores)

# Rank
mtcars <- mtcars %>% 
  mutate(score_no_rot = (factor_scores$PC1 * variance[1] + 
                           factor_scores$PC2 * variance[2]))


#Prop. Variance Varimax
variance2 <- prin2$Vaccounted[2,]

# Scores Varimax
factor_scores2 <- as.data.frame(prin2$scores)


# Rank Varimax
mtcars <- mtcars %>% 
  mutate(score_rot = (factor_scores2$RC1 * variance2[1] + 
                        factor_scores2$RC2 * variance2[2]))


# Numbered Ranking
mtcars <- mtcars %>% 
  mutate(rank1 = dense_rank(desc(score_no_rot)),
         rank2 = dense_rank(desc(score_rot)))

#############################
# Use only MPG and drat, am

# PCA after Kaiser's rule applied: Keep eigenvalues > 1
pca3 <- pca(mtcars[,c(1,5,9)], nfactors=2, rotate='none')

#Prop. Variance Not rotated
variance3 <- pca3$Vaccounted[2,]

# Scores
factor_scores3 <- as.data.frame(pca3$scores)

# Rank
mtcars <- mtcars %>% 
  mutate(score_ = (factor_scores3$PC1 * variance3[1] + 
                           factor_scores3$PC2 * variance3[2])) %>% 
  mutate(rank = dense_rank(desc(score_)) )




