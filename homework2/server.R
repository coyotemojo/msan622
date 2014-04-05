library(ggplot2)
library(shiny)
require(grid)

loadData <- function() {
  data("movies", package = "ggplot2")
  movies <- movies[which(movies$budget > 0),]
  movies <- movies[which(!is.na(movies$rating)),]
  movies <- movies[-c(which(movies$mpaa == '')),]
  movies$mpaa <- ordered(movies$mpaa, levels=c("PG", "PG-13", "NC-17", "R"))
  
  genre <- rep(NA, nrow(movies))
  count <- rowSums(movies[, 18:24])
  genre[which(count > 1)] = "Mixed"
  genre[which(count < 1)] = "None"
  genre[which(count == 1 & movies$Action == 1)] = "Action"
  genre[which(count == 1 & movies$Animation == 1)] = "Animation"
  genre[which(count == 1 & movies$Comedy == 1)] = "Comedy"
  genre[which(count == 1 & movies$Drama == 1)] = "Drama"
  genre[which(count == 1 & movies$Documentary == 1)] = "Documentary"
  genre[which(count == 1 & movies$Romance == 1)] = "Romance"
  genre[which(count == 1 & movies$Short == 1)] = "Short"
  
  df <- cbind(movies, genre)
  df$genre <- factor(df$genre, levels=c('Action',
                                        'Animation',
                                        'Comedy',
                                        'Documentary',
                                        'Drama',
                                        'Mixed',
                                        'Romance',
                                        'Short',
                                        'None'))
  
  return(df)
}

millions_formatter <- function(x) {
  return(sprintf("$%dM", round(x / 1000000)))
}

getPlot <- function (movies, incRatings, incGenres, cpalette, dotSize, dotAlpha, scale) {
  p <- ggplot(subset(movies, movies$genre %in% incGenres &
                       movies$mpaa %in% incRatings), 
              aes(x=budget, y=rating, color=mpaa))
  p <- p + geom_point(size = dotSize, alpha=dotAlpha)
  p <- p + xlab('Budget (Millions)')
  p <- p + ylab('Rating')
  
  if (scale == TRUE) {
    p <- p + scale_x_log10(labels = dollar, expand=c(0.01,.1))
    p <- p + xlab('Budget (Log Scale)')
  }
  else {
    p <- p + scale_x_continuous(label = millions_formatter, expand=c(0.01,.1))
    p <- p + xlab('Budget (Millions)')
  }
  
  p <- p + scale_y_continuous(breaks = seq(0,10,2), limits=c(0,10), expand = c(0.01, .1))
  p <- p + scale_color_manual(name='MPAA Rating',values = cpalette, limits=levels(movies$mpaa))
  p <- p + theme_bw()
  p <- p + theme(legend.position = c(1, 0), 
                 legend.justification = c(1, 0),
                 legend.direction = "horizontal",
                 legend.text = element_text(size = 14),
                 legend.key.size = unit(4, "lines"),
                 legend.title = element_text(size=16),
                 panel.background = element_rect(fill = NA),
                 panel.grid.minor = element_blank(),
                 axis.ticks = element_line(colour = "black"),
                 axis.text.x  = element_text(size=14, color='black'),
                 axis.text.y  = element_text(size=14, color='black'),
                 axis.title.x = element_text(size =16, face='bold', vjust=-.5),
                 axis.title.y = element_text(size =16, face='bold'))
  print(p)
}

#shared data
globalData <- loadData()
dpalette <- c("#F8766D","#7CAE00","#00BFC4","#C77CFF")

shinyServer(function(input, output) {

  localFrame <- globalData
  
  ratingsFilter <- reactive({
    ratings <- levels(globalData$mpaa)
    if (input$incRatings == "All" ) {
      return(ratings)
    }
    else {
      return(input$incRatings)  
    }
})

  genresFilter <- reactive({
    genres <- levels(globalData$genre)
    if (length(input$incGenres) == 0) {
      return(genres)
      }
    else {
      return(input$incGenres)  
      }
})

  colorChooser <- reactive({    
    if (input$cpalette == 'default') {
      return(dpalette)
    }
    else if (input$cpalette == 'accent') {
      return(brewer_pal(type = "qual", palette = "Accent")(4))
    }
    else if (input$cpalette == 'set1') {
      return(brewer_pal(type = "qual", palette = "Set1")(4))
    }
    else if (input$cpalette == 'set2') {
      return(brewer_pal(type = "qual", palette = "Set2")(4))
    }
    else if (input$cpalette == 'set3') {
      return(brewer_pal(type = "qual", palette = "Set3")(4))
    }
    else if (input$cpalette == 'dark2') {
      return(brewer_pal(type = "qual", palette = "Dark2")(4))
    }
    else if (input$cpalette == 'pastel1') {
      return(brewer_pal(type = "qual", palette = "Pastel1")(4))
    }
    else if (input$cpalette == 'pastel2') {
      return(brewer_pal(type = "qual", palette = "Pastel2")(4))
    }
})
  budgetScale <- reactive({
    return(input$logScale)
  })
  sizeSlider <- reactive({
    return(input$dotSize)
})
  alphaSlider <- reactive({
    return(input$dotAlpha)
})
  output$scatterPlot <- renderPlot({
    # Use our function to generate the plot.
    scatterPlot <- getPlot(
      localFrame,
      ratingsFilter(),
      genresFilter(),
      colorChooser(),
      sizeSlider(),
      alphaSlider(),
      budgetScale()
    )
    
    # Output the plot
    print(scatterPlot)
    },
    width = 900,
    height = 600)
})

