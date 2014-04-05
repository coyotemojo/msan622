library(shiny)

# Create a simple shiny page.
shinyUI(
  pageWithSidebar(
    headerPanel("Movie Ratings vs. Production Budget"),
    
    sidebarPanel(
      radioButtons(
        "incRatings",
        "MPAA Rating",
        c("All", "PG", "PG-13", "NC-17", "R"),
        selected = "All"
      ),
      
      checkboxGroupInput(
        "incGenres",
        "Movie Genres:",
        c("Action", "Animation", "Comedy", "Documentary", "Drama", "Mixed", "Romance", "Short", "None"),
        selected = c("Action", "Animation", "Comedy", "Documentary", "Drama", "Mixed", "Romance", "Short", "None")
        ),
      
      selectInput(
        "cpalette",
        "Color Scheme:",
        list("Default" = "default",
             "Accent" = "accent",
             "Set 1" = "set1",
             "Set 2" = "set2",
             "Set 3" = "set3",
             "Dark 2" = "dark2",
             "Pastel 1" = "pastel1",
             "Pastel 2" = "pastel2")),
      
      checkboxInput("logScale", "Use log scale for budget", FALSE),

      sliderInput("dotSize", "Dot Size:", 
                  min = 1, max = 10, value = 4, step= 1),
    
      sliderInput("dotAlpha", "Dot Alpha:", 
          min = 0, max = 1, value = 0.5, step= 0.1)
    ),  
    
    mainPanel(
      plotOutput("scatterPlot")
      )
    )
  )


