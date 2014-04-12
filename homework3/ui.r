library(shiny)

# Define UI for random distribution application 
shinyUI(fluidPage
  (
  
  # Application title
  headerPanel("U.S. State Data, 1977"),
  
  # Sidebar with controls to select the random distribution type
  # and number of observations to generate. Note the use of the br()
  # element to introduce extra vertical spacing
  fluidRow(
    column(3,
      wellPanel(
        radioButtons("highlightRegion",
          label = "Explore by region:",
          c("All", "Northeast", "South", "North Central","West"),
          selected = "All"
        ),
        conditionalPanel(
          condition = "input.tab == 'Heatmap' | input.tab== 'Parallel Coordinates'",
          checkboxGroupInput(
            "incVars",
            "Variables to include in plot:",
            c("Population", "Income", "Illiteracy", "LifeExp", "Murder", "HSGrad", "Frost", "Area"),
            selected = c("Population", "Income", "Illiteracy", "LifeExp", "Murder", "HSGrad", "Frost", "Area")
         )
        ),
        conditionalPanel(
          condition = "input.tab == 'Scatterplot Matrix'",
          br(),
            helpText(paste("Use the region radio buttons above to explore the distributions and correlations of several key 
                            variables across the various regions."))
          )
        )
      ),
    column(9,
      tabsetPanel(
        tabPanel("Heatmap",plotOutput("heatMap")),
        tabPanel("Scatterplot Matrix", plotOutput("scatterPlotMatrix")),
        tabPanel("Parallel Coordinates", plotOutput("parallelCoord")),
      id='tab'  
      )
    )
  ),
  fluidRow(
    column(3,
      conditionalPanel(
        condition = "input.tab == 'Heatmap'",     
        wellPanel(
          selectInput(
            "sortVar",
            "Variable to sort by:",
            c("Population", "Income", "Illiteracy", "LifeExp", "Murder", "HSGrad", "Frost", "Area"),
            selected = "Population"
          ) 
        )
      )
    ),
    column(9,
      conditionalPanel(
        condition = "input.tab == 'Heatmap'",
        div("Low values are orange, mid values are white, and high values are blue.", align = "center"),
        wellPanel(
          sliderInput(
            "range",
            "Heatmap Gradient Range:",
            min = 0,
            max = 1,
            value = c(0.45, 0.55),
            step = 0.05,
            format = "0.00",
            ticks = TRUE
          ),
      
        helpText(paste("This will control the",
                     "middle break points for the color",
                     "gradient. The selected range will",
                     "become white.")
        )
      )
    )
  )
)
))