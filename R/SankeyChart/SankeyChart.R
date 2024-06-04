# Libraries
library(networkD3)
library(dplyr)

# A connection data frame is a list of flows with intensity for each flow
links <- data.frame(
  source=c("TOTAL SALES", "TOTAL SALES", 
           "Products", "Products", 
           "Services", "Services"), 
  target=c("Products", "Services", "Product A", 'Product B', "Maintenance", 'Upgrade'), 
  value=c(22, 5, 10, 12, 2, 3)
)

# From these flows we need to create a node data frame: it lists every entities involved in the flow
nodes <- data.frame(
  name=c(as.character(links$source), 
         as.character(links$target)) %>% unique()
)

# With networkD3, connection must be provided using id, not using real name like in the links dataframe.. So we need to reformat it.
links$IDsource <- match(links$source, nodes$name)-1 
links$IDtarget <- match(links$target, nodes$name)-1

# Make the Network
p <- sankeyNetwork(Links = links, Nodes = nodes,
                   Source = "IDsource", Target = "IDtarget",
                   Value = "value", NodeID = "name", 
                   sinksRight=FALSE,
                   fontSize = 12, fontFamily = "Arial Black")
# View
p