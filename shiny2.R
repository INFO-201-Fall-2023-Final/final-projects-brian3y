library(dplyr)
library(stringr)
library(ggplot2)
library(shiny)
library(plotly)

df <- read.csv("final.csv")
distinct_state <- slice(group_by(df, State.Name), 1)


ui <- fluidPage(
  titlePanel("Examining the total homeless and the unsheltered homelss"),

  br(), # the br() function adss line breaks

  p("Let's examine the homeless and 
      (i.e. all those in the Power Five conferences (the ACC, Big Ten, Big 12, Pac-12 and SEC), plus Notre Dame).
      Our analysis looks at how many times certain words appear in the lyrics to see how each song compares.
      We also look at song length and speed of each song based on the official versions availible on spotify"),
  br(),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "selected_state", label = "Choose a State", choices= distinct_state$State.Name),
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
    p <- ggplot(distinct_state,
                aes(x = State.Name, fill = State.Name)) +
      geom_bar(aes(y = Total.Homeless), stat = "identity", color = "black", fill = "blue", position = "stack") +
      geom_bar(aes(y = Unsheltered.Homeless), stat = "identity", color = "black", fill = "green",position = "stack") +
      labs(x = "Unsheltered Homeless", 
           y = "Total.Homeless",
           fill = "Category") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    p <- ggplotly(p)
    return(p)
  })
}

shinyApp(ui, server)