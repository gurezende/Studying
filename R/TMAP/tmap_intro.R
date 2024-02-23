#####################################
# Imports
#####################################

library(tidyverse)
library(tmap)
library(sf)

#####################################
# Basics - Tmap 101
#####################################

# loading the toy dataset "World"
data("World")

# Basic map plot mode, by default
tmap_mode("plot")


# "Hello Plot". Most basic plot in Tmap
tm_shape(World) +
  tm_polygons(col= 'life_exp')


# Plot with many elements
tm_shape(World) + #main shape
  tm_polygons(col= 'life_exp', palette= 'RdYlBu') + #polygon for choropleth
  tm_dots(col= 'brown', size= 'pop_est', scale=2.5, alpha=0.5, shape=15) + # squares
  tm_text(text= 'iso_a3', size=0.5, just = 'bottom') #text


# Set maps to Interactive mode
tmap_mode("view")


# Plot with facets (side-by-side graphics)
tm_shape(World) + #main shape
  tm_polygons(col= c('gdp_cap_est', 'life_exp'), 
              style='quantile', palette= 'Blues',
              popup.vars=c(Country= 'iso_a3', Life_Exp= 'life_exp', GDP_capita='gdp_cap_est')) + #polygon for choropleth
  tm_facets(nrow=2) #you can use ncol for side-by-side


#####################################
# Car Crashes in London
#####################################

# path
path <- 'C:/Users/.../urbanGB.csv'
path2 <- 'C:/Users/.../urbanGB_labels.csv'

#Load Files
df <- read_csv(path, col_names = c("Longitude", "Latitude"))
labels <- read_csv(path2, col_names = c("labels"))


# Bind both datasets and filter Downtown London
# You can use label == 1  as filter too.
df2 <- df %>% 
  bind_cols(labels) %>% 
  filter(Latitude > 51.49 & Latitude < 51.55 &
            Longitude > -0.20 & Longitude < -0.02)

# error (Not a Shapefile)
tm_shape(df2) +
  tm_dots(col= 'label')


# We must transform the file to a Shapefile object
sf_df <- st_as_sf(x = df2, 
                  coords = c("Longitude", "Latitude"), 
                  crs = 4326)

# plot points
tm_shape(sf_df) +
  tm_dots(alpha=0.3, col='red', 
          border.col='gray90', 
          border.alpha=0.1)


# Load Attractions lat long
path3 <- 'C:/Users/.../attractions.csv'
attractions <- read_csv(path3)


# Transform to Shapefile for plotting
attractions_sf <- st_as_sf(x = attractions, 
                  coords = c("longitude", "latitude"), 
                  crs = 4326)


# plot points
tm_shape(sf_df) + # car accidents data
  tm_dots(alpha=0.3, col='red', #dots configs for the car crashes
          border.col='gray90', 
          border.alpha=0.1) +
  tm_shape(attractions_sf) + #attractions data
  tm_symbols(size = 2, col='blue') #config for the attractions points


# plot markers
tm_shape(sf_df) +
  tm_markers(size=0.25, alpha=0.75)+
  tm_shape(attractions_sf) + #attractions data
  tm_symbols(size = 2, col='blue') #config for the attractions points



#----
#####################################
# Buffer Analysis
#####################################
# To use buffer analysis, we need just lat/long info in a Shapefile
attr_latlong <- attractions %>% select(-1)


# Convert to Shapefile
attr <- SpatialPoints(coords = attr_latlong,
                          proj4string = CRS("+proj=longlat"))

# Convert distances to euclidean, for gBuffer function to work properly
attr_UTM <- spTransform(x = attr,
                            CRSobj = CRS("+init=epsg:22523"))

# Buffer Analysis: distance from a point
buffer_attractions <- gBuffer(spgeom = attr_UTM,
                              width = 500,
                              byid = TRUE)


# Plot graphic + buffer
tm_shape(buffer_attractions) + # buffer
  tm_borders(col = "darkred") + #buffer border
  tm_fill(col = "blue",  alpha = 0.1)+ #buffer fill
  tm_shape(attractions_sf) + # attractions
  tm_dots(size=0.5, col='blue')+ # attractions points
  tm_shape(sf_df) + # car accidents data
  tm_dots(alpha=0.3, col='red', #dots configs for the car crashes
          border.col='gray90', 
          border.alpha=0.1)


#####################################
# Saving Maps
#####################################
to_save = tm_shape(sf_df) +
  tm_markers(size=0.25, alpha=0.75)+
  tm_shape(attractions_sf) + #attractions data
  tm_symbols(size = 2, col='blue') #config for the attractions points


# save an image
tmap_save(to_save, filename = "My_Map.png")

# save as interactive HTML file
tmap_save(to_save, filename = "My_Map.html")

