library(ggplot2)
library(shiny)
library(GGally)
require(grid)
library(reshape)
library(scales)

loadData <- function(){
  #load the data
  state_data <- data.frame(state.x77)
  #get rid of 'categorical' data
  state_data <- state_data[,1:8]
  state_data <- rescaler(state_data, type='range')
  state_data$State <- state.name
  state_data$Region <- state.region
  colnames(state_data) <- gsub("\\.", "", colnames(state_data))
  return(state_data)
}

getSorted <- function (original, melted, sort_var1) {
  sortOrder <- original[order(original[sort_var1], decreasing = TRUE),'State']                  
  melted$State <- factor(melted$State,
                             levels = sortOrder,
                             ordered= TRUE)
  return(melted)
}

getHeatmap <- function (df, incVars, midrange, sort_var1, highlight) {
  melted_df <- melt(df,id.vars=c('State', 'Region'))
  sorted_df <- getSorted(df, melted_df, sort_var1)
  sorted_df$variable <- relevel(sorted_df$variable, sort_var1)
  p <- ggplot(subset(sorted_df, variable %in% incVars & Region %in% highlight), 
              aes(x=State, y=variable))
  p <- p + geom_tile(aes(fill = value), colour = "white")
  p <- p + theme_minimal()
  p <- p + theme(axis.title = element_blank())
  p <- p + theme(axis.ticks = element_blank())
  p <- p + theme(panel.grid = element_blank())
  p <- p + theme(legend.position = "none")
  p <- p + coord_flip()
  #p <- p + ggtitle('')
  palette <- c("#ef8a62", "#f7f7f7", "#f7f7f7", "#67a9cf")
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

getScatter <- function (df, incVars, highlight) {
  p <- ggpairs(subset(df, Region %in% highlight),
  legends = TRUE,
  # Columns to include in the matrix
  columns = c('Illiteracy', 'Murder', 'HSGrad', 'Frost'),
  #columns = incVars,
               
  # What to include above diagonal
  # list(continuous = "points") to mirror
  # "blank" to turn off
  upper = "blank",
               
  # What to include below diagonal
  lower = list(continuous = "smooth"),
               
  # What to include in the diagonal
  diag = list(discrete = "bar"),
               
  # How to label inner plots
  # internal, none, show
  axisLabels = "none",
               
  # Other aes() parameters
  colour = "Region",
  )
  #p <- p + scale_color_manual(values = region_palette, limits=levels(df$Regions))

  for (i in 1:4) {
    for (j in 1:4) {
      # Get plot out of matrix
      inner = getPlot(p, i, j);
    
      # Add any ggplot2 settings you want
      inner = inner + theme(panel.grid = element_blank());
      inner <- inner + scale_color_manual(values = region_palette, limits=levels(df$Region))
      if (i == 1 && j == 1) {
        inner <- inner + theme(legend.position=c(3.75,.5),
                               legend.key.size = unit(2.5, "cm"),
                               legend.title = element_text(size=12))
      }
      else {
        inner <- inner + theme(legend.position='none')
        
      }
      
      # Put it back into the matrix
      p <- putPlot(p, inner, i, j);
    }
  }
  return(p)
}

getParallel <- function(df, incVars, highlight) {
  df$alphaLevel <- .1
  df$alphaLevel[which(df$Region %in% highlight)] <- .6
  p <- ggparcoord(data = df,
  #columns = c('Illiteracy', 'Murder', 'HSGrad', 'Frost'), 
  columns = incVars,
  groupColumn = 'Region', 
  # Allows order of vertical bars to be modified
  order = "anyClass",                
  showPoints = FALSE,
  # Turn off box shading range
  shadeBox = NULL,                
  # Will normalize each column's values to [0, 1]
  scale = "uniminmax", # try "std" also
  alphaLines = "alphaLevel",
  )
  p <- p + scale_y_continuous(expand = c(0.02, 0.02))
  p <- p + scale_x_discrete(expand = c(0.02, 0.02))
  p <- p + theme(axis.title = element_blank())
  p <- p + theme(legend.position = "bottom")
  p <- p + scale_color_manual(values = region_palette, limits=levels(df$Region))
  p <- p + scale_alpha_continuous(guide="none")
  return(p)
}

#shared data
globalData <- loadData()
midrange <- c(.3,.7)
region_palette <- c("Northeast" = "#1B9E77", "South" = "#D95F02", "North Central" = "#7570B3", "West" = "#E7298A")

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
  
  regionChooser <- reactive({
    regions <- levels(globalData$Region)
    if (input$highlightRegion == "All") {
      return(regions)
    }
    else {
      return(input$highlightRegion)
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
      input$range,
      sortChooser(),
      regionChooser()
    )
    # Output the plot
    print(heatMap)
  })
  
  output$scatterPlotMatrix <- renderPlot({
    # Use our function to generate the plot.
    scatterPlot <- getScatter(
      localFrame,
      varsFilter(),
      regionChooser()
    )
    # Output the plot
    print(scatterPlot)
  })
  
  output$parallelCoord <- renderPlot({
    # Use our function to generate the plot.
    parallelPlot <- getParallel(
      localFrame,
      varsFilter(),
      regionChooser()
    )
    # Output the plot
    print(parallelPlot)
  })
})
