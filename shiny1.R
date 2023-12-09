library(dplyr)
library(stringr)
library(ggplot2)
library(shiny)
library(plotly)

source('final.R')

# Load in dataset
homeless_df <- read.csv("Homeless_Data.csv")
housing_df <- read.csv("Housing_Data.csv")

# We first mutate our dataframe
final_df <- mutate_dataframe(homeless_df = homeless_df, housing_df = housing_df)


# Define UI
ui <- fluidPage (
  
)


# Define server logic
server <- function(input, output) {
  
}


# Run the app
shinyApp(ui = ui, server = server)