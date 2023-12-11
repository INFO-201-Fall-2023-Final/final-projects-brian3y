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
  titlePanel('Comparing Housing vs. Homeless Population Data'),
  
  fluidRow(
    column(width = 12,
           h4('In this shiny presentation, we will be comparing and contrasting the total housing
              population between U.S counties, and its total homeless population within a U.S state.
              As we examine the numbers,  we wish to spotlight the contrast between the population
              of those with stable housing, and those facing homelessness. The bar graph representation
              will be a straightforward exploration to highlight the current state of housing disparities
              within our communities between U.S states.
              '),

           br()
    ),
    
    br(),
    
    column(width = 12,
           offset = 1,
           selectInput(inputId = 'state_name', 
                       label = 'Choose a State',
                       choices = final_df$State.Name)
    ),
    
    br(),

    column(width = 12,
           plotlyOutput(outputId = 'bar', width = "100%", height = "500px")),
    
  ),
  
  br(),
  
  tags$style(
    HTML("
        #text {
          text-align: center;
          font-size: 20px;
          font-weight: bold;
        }
      "),
    
    HTML("h2 {
            background-color: #ccd5d8;
            color: Black;
            }"),
  ),
  
  textOutput(outputId = 'text')
)


# Define server logic
server <- function(input, output) {
  output$bar <- renderPlotly({
    
    if(!is.null(input$state_name) && input$state_name != '') {
      state_df <- filter(final_df,
                         final_df$State.Name == input$state_name,
                         final_df$Tenure == 'Owner occupied')
      
      filtered_state <- state_df %>% 
        select(County.Name, Total.Households)
      
      homeless_count <- state_df$`Total Homeless`[1]
      homeless_row <- data.frame(County.Name = "Total Homeless", Total.Households = homeless_count)
      filtered_state <- rbind(filtered_state, homeless_row) 
      
      filtered_state <- arrange(filtered_state, desc(filtered_state$Total.Households))
      filtered_state$County.Name <- factor(filtered_state$County.Name, levels = filtered_state$County.Name)
  
      p <- ggplot(filtered_state,
                  aes(x = County.Name,
                      y = Total.Households,
                      fill = County.Name)) +
           geom_bar(stat='identity') +
           labs(x = "County + Homeless",
                y = "Population",
                fill = 'County + Homeless') +
           theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
           scale_fill_manual(values = ifelse(filtered_state$County.Name == 'Total Homeless', 'red', 'steelblue')) +
           ggtitle(paste('Housing vs. Homeless Population Data in', input$state_name))
            
      
      p <- ggplotly(p)
      return(p)
    } else {
      return(NULL)
    }
  })
  
  output$text <- renderText({
    if(!is.null(input$state_name) && input$state_name != '') {
      state_df <- filter(final_df,
                         final_df$State.Name == input$state_name,
                         final_df$Tenure == 'Owner occupied')
      
      county_count <- sum(state_df$Total.Households < state_df$`Total Homeless`)
    
      result <- paste('The homeless population is greater than the population of', county_count,
                      'counties within the state of ', input$state_name, '!')
      
      return(result)
    } else {
      return(NULL)
    }
  })
}


# Run the app
shinyApp(ui = ui, server = server)