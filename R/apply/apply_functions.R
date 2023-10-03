# data
dtf <- data.frame(
  id = 1:100,
  product= sample(c('product A', 'product B', 'product C', 'product D'), size=100, replace=T),
  qty = as.integer( rnorm(100, 10, 2) ),
  amt = rnorm(100, 1280, 300),
  amt2 = rnorm(100, 1280, 300)
)

### APPLY ###

# Apply: Apply a function to all the columns 
apply( X= dtf[,c(3,4, 5)], MARGIN= 2, FUN= mean)

# Apply: Apply a function to all the rows
apply( X= dtf[, c(4,5)], MARGIN= 1, FUN= mean)

# Average of the amounts
dtf$avg_amounts <- apply( X= dtf[, c(4,5)], MARGIN= 1, FUN= mean)

# See first 5 rows
dtf |> head(5)

# Average AMT by product QTY
dtf$amt_by_qty <- apply(
  X= dtf[, c(3,4)],
  MARGIN= 1,
  FUN= function(x){ x[2]/x[1]}
       )

# See first 5 rows
dtf |> head(5)


### LAPPLY ###
# Creating a list
l <- list(c(1,2), 'l', 1.6, TRUE)

# Check the type of each object in the list
lapply(l, FUN= class)


### SAPPLY ###

# Use sapply for the same list
sapply(l, FUN = class)

# Using sapply to remove the word 'product' from the description
dtf$product <- sapply(dtf$product,
                      FUN= function(x){ strsplit(x, ' ')[[1]][2] })


### TAPPLY ###

# Using tapply to calculate the mean of amt by product 
tapply(X= dtf$amt, INDEX = dtf$product, FUN = mean)


