library(shiny)

# Define UI for random distribution application 
shinyUI(fluidPage
  (
  
  # Application title
  headerPanel("MovieLens Dataset Explorer"),
  
  # Sidebar with controls to select the random distribution type
  # and number of observations to generate. Note the use of the br()
  # element to introduce extra vertical spacing
  fluidRow(
    column(3,
        conditionalPanel(
          condition ="input.tab == 'Genres'",
          wellPanel(
            h5('Exploring genre co-occurrence'),
            helpText('The genre co-occurrence heatmap provides perspective on
                     which genres tend to be associated together with a single
                     movie as well as how those frequencies compare to the
                     frequency of movies with only a single associated genre.  
                     Counts of single genre movies occupy the diagonal of the 
                     heatmap.'
                    )
            ),
          wellPanel(
            sliderInput(
              "limit",
              "% of Maximum Frequency to Display:",
              min = 0,
              max = 1,
              value = c(1),
              step = 0.05,
              format = "0.00",
              ticks = TRUE
            ),
            
            helpText(paste("This slider will limit",
                           "the maximum count of genre/genre co-occurrence",
                           "to include in the heatmap.")
            )
          )
          ),
        conditionalPanel(
          condition ="input.tab == 'User Demographics'",
          wellPanel(
            h5('Demographics of MovieLens Users'),
            helpText('Each dot represents a single MovieLens user in each
                     demographic bucket.'
            )
          )
          ),
        conditionalPanel(
          condition = "input.tab == 'User Demographics'",
            wellPanel(
              checkboxGroupInput("selectGender",
                       label = "Explore by gender:",
                       c("Female", "Male"),
                       selected = c("Female", "Male")
            )
          )
        ),
        conditionalPanel(
          condition = "input.tab == 'Ratings by Demo and Genre'",
            wellPanel(
              h5('Exploring ratings by demographic profile'),
              helpText('The distribution of mean ratings for individual movies within each genre 
                        varies by gender and age.  The boxplots provide insight into how those ratings are
                        distributed.'
              )
            )
            ),
        conditionalPanel(
          condition = "input.tab == 'Bubbleplot Recommender'",
          wellPanel(
            h5('Bubbleplot Recommender'),
            helpText("Using the input lists below, choose your precise demograpic profile, or a
                     demographic profile of interest.  The plot will display bubbles for movies and
                     plot them based on ratings from within that demographic.   Use the table below to 
                     explore how various movies have been rated within that demographic.  The 'Disagreement' 
                     column in the table is the standard deviation of ratings."
            )
          ),
        wellPanel(
          selectInput("chooseGender",
                      label = "Select your gender:",
                      c("Female","Male")
            ),
          selectInput("selectAge",
                           label = "Select your age:",
                           c("Under 18",
                             "18-24",
                             "25-34",
                             "35-44",
                             "45-49",
                             "50-55",
                             "56+")
        ),
        selectInput("selectOcc",
                           label = "Select your occupation:",
                    c("Other",
                      "Academic/Educator",
                      "Artist",
                      "Clerical/Admin",
                      "College/Grad Student",
                      "Customer Service",
                      "Doctor/Health Care",
                      "Executive/Managerial",
                      "Farmer",
                      "Homemaker",
                      "K-12 Student",
                      "Lawyer",
                      "Programmer",
                      "Retired",
                      "Sales/Marketing",
                      "Scientist",
                      "Self-employed",
                      "Technician/Engineer",
                      "Tradesman/Craftsman",
                      "Unemployed",
                      "Writer")
        )
      )
      )
    ),
    column(9,
      tabsetPanel(
        tabPanel("Genres",
                plotOutput("topGenres", width="100%",height="400px")),
        tabPanel("User Demographics",
                plotOutput("userDist", width="100%", height="400px")),
        tabPanel("Ratings by Demo and Genre",
                plotOutput("genderRats", width="100%", height="400px")),
        tabPanel("Bubbleplot Recommender",
                 plotOutput("recoScatter", width="100%", height="300px"),
                 dataTableOutput('ratingsTable')),
        id='tab'  
      )
    )
  )
)
)
