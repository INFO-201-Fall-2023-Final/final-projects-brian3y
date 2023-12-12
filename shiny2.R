library(dplyr)
library(stringr)
library(ggplot2)
library(plotly)


df <- read.csv("final.csv")
distinct_state <- slice(group_by(df, State.Name), 1)


ui <- fluidPage(
  titlePanel("Examining the total homeless and the unsheltered homeless"),
  
  br(), # the br() function adss line breaks
  
  p("Let's examine the Total homeless and 
      the unsheltered homeless people in each state and the compare to each state"),
  br(),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "selected_state", label = "Choose a State", choices= c("All", distinct_state$State.Name)),
      br()
    ),
    mainPanel(
      h3("Comparing unsheltered homeless and total homeless in each state"),
      plotlyOutput(outputId = "scatter")
    )
  )
)


server <- function(input, output) {
  output$scatter <- renderPlotly({
    selected <- subset(distinct_state, State.Name == input$selected_state)
    if (input$selected_state == "All") {
      p <- ggplot(distinct_state,
                  aes(x = State.Name, fill = State.Name)) +
        geom_bar(aes(y = Total.Homeless, fill = "Total.Homeless"), stat = "identity", color = "black", position = "stack") +
        geom_bar(aes(y = Unsheltered.Homeless, fill = "Unsheltered.Homeless"), stat = "identity", color = "black", position = "stack") +
        scale_y_continuous(labels = scales::number_format(big.mark = ",")) +
        labs(x = "States", 
             y = "number of homeless people",
             fill = "Category") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    } else {
      p <- ggplot(selected,
                  aes(x = State.Name, fill = State.Name)) +
        geom_bar(aes(y = Total.Homeless, fill = "Total.Homeless"), stat = "identity", color = "black", position = "stack", width = 0.2) +
        geom_bar(aes(y = Unsheltered.Homeless, fill = "Unsheltered.Homeless"), stat = "identity", color = "black", position = "stack", width = 0.2) +
        scale_y_continuous(labels = scales::number_format(big.mark = ",")) +
        labs(x = "States", 
             y = "number of people",
             fill = "Category") +
        theme_minimal()
    }
    p <- ggplotly(p)
    return(p)
    
  })
}

shinyApp(ui, server)
