# ui_intro.R
library(shiny)
library(shinydashboard)

source("shiny1.R")
source("shiny2.R")
intro_ui <- dashboardPage(
  dashboardHeader(title = "Introductory"),
  dashboardSidebar(
  ),
  dashboardBody(
    fluidPage(
      h2("Welcome to the homeless and housing Project"),
      actionButton("go_to_shiny1", "Case compare 1"),
      actionButton("go_to_shiny2", "Case compare 2"),
      br(),
      h2("Story"),
      p("Our central theme is to uncover the underlying socio-economic factors 
        that contribute to homelessness, and we hope to present a thought-provoking
        perspective on the issue, where addressing homelessness is a concern that resonates 
        deeply within communities across the United States."),
      h2("Case comapre"),
      br(),
      p("case comapre one is about"),
      br(),
      p("case comapre two is about the total homeless comapre to the unsheltered homless people in each state.
        By licking on the all option we can also see who each state comapre to each otehr in terms of total homeless and
        the unsheltered homeless people"),
      uiOutput("selected_page")
    )
  )
)

intro_server <- function(input, output, session) {
  selected_page <- reactiveVal(NULL)
  
  observeEvent(input$go_to_shiny1, {
    selected_page(source("shiny1.R", local = TRUE))
  })
  
  observeEvent(input$go_to_shiny2, {
    selected_page(source("shiny2.R", local = TRUE))
  })
  
  output$selected_page <- renderUI({
    selected_page()
  })
  
  output$selected_page <- renderUI({
    selected_page()
  })
  
}

shinyApp(ui = intro_ui, server = intro_server)
