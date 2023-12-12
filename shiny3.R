library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)

# Read the dataset
data <- read.csv("final.csv", stringsAsFactors = FALSE)

# Preprocess the data for scatter plot
data_scatter <- data %>%
  group_by(State.Name) %>%
  summarise(
    TotalHouseholds = sum(as.numeric(gsub(",", "", Total.Households))),
    BurdenOver50 = sum(as.numeric(gsub(",", "", `Housing.cost.burden.is.greater.than.50.`))),
    TotalHomeless = sum(as.numeric(gsub(",", "", `Total.Homeless`)))
  )

# Preprocess the data for pie chart
data_pie <- data %>%
  group_by(State.Name) %>%
  summarise(
    Burden30to50 = sum(as.numeric(gsub(",", "", `Housing.cost.burden.is.greater.than.30..but.less.than.or.equal.to.50.`))),
    BurdenOver50 = sum(as.numeric(gsub(",", "", `Housing.cost.burden.is.greater.than.50.`))),
    BurdenUnder30 = sum(as.numeric(gsub(",", "", `Housing.cost.burden.is.less.than.or.equal.to.30.`))),
    BurdenNotComputed = sum(as.numeric(gsub(",", "", `Housing.cost.burden.not.computed..household.has.no.negative.income.`)))
  )

# Define the Shiny UI
ui <- fluidPage(
  titlePanel("State-Level Analysis of Housing Burden and Homelessness"),
  sidebarLayout(
    sidebarPanel(
      selectInput("state", "Choose a State:", choices = unique(data_pie$State.Name))
    ),
    mainPanel(
      HTML("<h2>Exploring the Intersection of High Housing Cost Burden and Homelessness</h2>
            <p>Our analytical investigation delves into the correlation between households facing a high housing cost burden—indicated by a parameter over 50—and the prevalence of homelessness within states. The scatter plot uncovers a potential trend: states with more households surpassing the burden indicator of 50 also tend to experience higher rates of homelessness.</p>
            <h3>Nut Graf:</h3>
            <p>The pivotal discovery of our research is the apparent link between extreme housing cost burden and increased homelessness, signaling that when households spend disproportionately on housing, their vulnerability to homelessness escalates. This emphasizes the critical nature of the housing cost burden as a factor influencing homelessness, meriting immediate attention from community leaders and policymakers.</p>
            <h3>About This Analysis:</h3>
            <p>The conclusions drawn here are informed by data sourced from authoritative housing and homelessness datasets. Our approach provides stakeholders with a clear visual and statistical representation of housing stress factors, aiming to spur actionable strategies that alleviate high housing cost burdens and reduce homelessness.</p>"),
      plotOutput("scatterPlot"),
      plotOutput("pieChart")
    )
  )
)

# Define the Shiny server logic
server <- function(input, output) {
  
  # Render the scatter plot
  output$scatterPlot <- renderPlot({
    ggplot(data_scatter, aes(x = BurdenOver50, y = TotalHomeless)) +
      geom_point() +
      geom_smooth(method = "lm", se = FALSE, color = "red") +  # Add a linear regression line
      labs(title = "Scatter Plot of Total Households Burden Over 50 vs Total Homeless by State",
           x = "Total Households Burden Over 50",
           y = "Total Homeless") +
      theme_minimal()
  })
  
  # Render the pie chart
  output$pieChart <- renderPlot({
    selected_data <- filter(data_pie, State.Name == input$state)
    pie_data <- selected_data %>% select(-State.Name) %>% gather(key = "Category", value = "Value")
    ggplot(pie_data, aes(x = "", y = Value, fill = Category)) +
      geom_bar(width = 1, stat = "identity") +
      coord_polar("y", start = 0) +
      labs(title = paste("Housing Burden Proportions in", input$state)) +
      theme_void()
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)