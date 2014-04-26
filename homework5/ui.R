library(shiny)

# Define UI for random distribution application 
shinyUI(fluidPage
  (
  
  # Application title
  headerPanel("UK Driving Deaths, Before and After Seatbelt Law"),
  
  # Sidebar with controls to select the random distribution type
  # and number of observations to generate. Note the use of the br()
  # element to introduce extra vertical spacing
  fluidRow(
    column(3,
      conditionalPanel(condition = "input.tab == 'Stacked Area'",
        wellPanel(
        sliderInput(
          "num", 
          "Months:", 
          min = 4, 
          max = 24,
          value = 12, 
          step = 1
        ),
        
        sliderInput(
          "start", 
          "Starting Point:",
          min = 1969, 
          max = 1984,
          value = 1969, 
          step = 1 / 12,
          round = FALSE, 
          ticks = TRUE,
          format = "####.##",
          animate = animationOptions(
            interval = 800, 
            loop = TRUE
            )
          )
        )
      )
      ),
    column(9,
      tabsetPanel(
        tabPanel("Stacked Area",
                 plotOutput("stackedArea1", width="100%",height="400px"), 
                 plotOutput("overview",width="100%",height="200px")),
        tabPanel("Heatmap", 
                 plotOutput("heatmap", width="100%", height="600px")),
        id='tab'  
      )
    )
  )
)
)