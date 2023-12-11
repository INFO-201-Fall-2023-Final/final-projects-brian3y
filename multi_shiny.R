# app.R
library(shiny)

# Source the UI, server, and global files
source("shiny1.R")
source("shiny2.R")

# Run the Shiny app
shinyApp(ui = ui, server = server)
