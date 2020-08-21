setwd('')

###############################
###### Package Loads ##########
#------------------------------------------------------------------

library(shiny)
library(shinythemes)
library(plotly)
library(corrplot)
library(caret)
library(randomForest)

###############################
##### Loading the dataset #####
#------------------------------------------------------------------
df <- read.csv('')



###############################
####### User Interface ########
#------------------------------------------------------------------

ui <- fluidPage(theme = shinytheme("flatly"),
                # This is the panel with all the tabs on top of the pages
                navbarPage(
                  theme = 'flatly',
                  'Project Name',
                  
                  
                  # Tab About
                  tabPanel("TAB1 Name",
                           mainPanel(fluidRow(
                             h3('The Dataset'),
                             helpText('text')
                             ) # fluidRow-About
                             ) # mainPanel-About
                           ) #tabPanel-About
                ) # navbarPage
  
) #MainfluidPage-close





#############################
########## Server ###########
#------------------------------------------------------------------

server <- function(input, output) {}



##############################
######### Shiny App ##########
#------------------------------------------------------------------

shinyApp(ui = ui, server = server)


