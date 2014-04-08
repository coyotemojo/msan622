library(shiny)

# Define UI for random distribution application 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("State Data"),
  
  # Sidebar with controls to select the random distribution type
  # and number of observations to generate. Note the use of the br()
  # element to introduce extra vertical spacing
  sidebarPanel(
    checkboxGroupInput(
      "incVars",
      "Variables to include:",
      c("Population", "Income", "Illiteracy", "Life Exp", "Murder", "HS Grad", "Frost", "Area"),
      selected = c("Population", "Income", "Illiteracy", "Life Exp", "Murder", "HS Grad", "Frost", "Area")
    ),
    radioButtons(
      "sortVar",
      "Variable to sort by:",
      c("Population", "Income", "Illiteracy", "Life Exp", "Murder", "HS Grad", "Frost", "Area"),
      selected = "Population"
    )
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Heatmap", plotOutput("heatMap")),
      tabPanel("Small Multiples")
    )
  )
))