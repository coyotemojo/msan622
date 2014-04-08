library(ggplot2)
library(shiny)
require(grid)
library(reshape)

loadData <- function(){
  #load the data
  state_data <- data.frame(state.x77,
                           State = state.name,
                           Abbrev = state.abb,
                           Region = state.region,
                           Division = state.division)
  #get rid of 'categorical' data
  state_data <- state_data[,1:8]
  state_data <- rescaler(state_data, type='range')
  state_data$State <- state.abb
  colnames(state_data) <- gsub("\\.", " ", colnames(state_data))
  return(state_data)
}

getSorted <- function (original, melted, sort_var1) {
  sortOrder <- original[order(original[sort_var1], decreasing = TRUE),'State']                  
  melted$State <- factor(melted$State,
                             levels = sortOrder,
                             ordered= TRUE)
  return(melted)
}

getHeatmap <- function (df, incVars, midrange, sort_var1) {
  melted_df <- melt(df,id.vars='State')
  sorted_df <- getSorted(df, melted_df, sort_var1)
  p <- ggplot(subset(sorted_df, sorted_df$variable %in% incVars), 
              aes(x=State, y=variable))
  p <- p + geom_tile(aes(fill = value), colour = "white")
  p <- p + theme_minimal()
  # remove axis titles, tick marks, and grid
  p <- p + theme(axis.title = element_blank())
  p <- p + theme(axis.ticks = element_blank())
  p <- p + theme(panel.grid = element_blank())
  # remove legend (since data is scaled anyway)
  p <- p + theme(legend.position = "none")
  #p <- p + coord_flip()
  palette <- c("#008837", "#f7f7f7", "#f7f7f7", "#7b3294")
  if(midrange[1] == midrange[2]) {
    # use a 3 color gradient instead
    p <- p + scale_fill_gradient2(low = palette[1], mid = palette[2], high = palette[4], midpoint = midrange[1])
  }
  else {
    # use a 4 color gradient (with a swath of white in the middle)
    p <- p + scale_fill_gradientn(colours = palette, values = c(0, midrange[1], midrange[2], 1))
  }
  return(p)
}

#shared data
globalData <- loadData()
midrange <- c(.3,.7)

shinyServer(function(input, output) {
  
  localFrame <- globalData
  
  varsFilter <- reactive({
    vars <- colnames(globalData)[1:8]
    if (length(input$incVars) == 0) {
      return(vars)
    }
    else {
      return(input$incVars)  
    }
  })
  
  sortChooser <- reactive({
    return(input$sortVar)
  })
  
  output$heatMap <- renderPlot({
    # Use our function to generate the plot.
    heatMap <- getHeatmap(
      localFrame,
      varsFilter(),
      midrange,
      sortChooser()
    )
    # Output the plot
    print(heatMap)
  })
})
