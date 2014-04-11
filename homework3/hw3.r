library(ggplot2)
library(shiny)
library(grid)

state_data <- data.frame(state.x77,
                         State = state.abb,
                         Region = state.region)


p <- ggplot(df, aes(
            x = Population,
            y = Income,
            color = Division,
            size = Murder))

p <- p + geom_point()
p #bubble plot is pretty easy - not sure how informative it is in this case


#work on heat map
getHeatmap <- function (df, incVars, midrange, sort_var1) {
  melted_df <- melt(df,id.vars=c('State', 'Region'))
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
  p <- p + coord_flip()
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

getSorted <- function (df, melted_df, sort_var1) {
    sortOrder <- df[order(df[sort_var1], decreasing = TRUE),'State']                  
    melted_df$State <- factor(melted_df$State,
                               levels = sortOrder,
                               ordered= TRUE)
    return(melted_df)
}

palette <- c("#008837", "#f7f7f7", "#f7f7f7", "#7b3294")
midrange <- c(.3,.7)
incVars <- c('Population', 'Income', 'Illiteracy')
sortBy <- 'Illiteracy'

p <- getHeatmap(state_data, incVars, midrange, sortBy)
#  let's focus on a heatmap - allow sorting by columns, also perhaps filter by region?
#  scatter plot matrix - color/gray out selected region
#  parallel coordinates - sort by columns, highlight by region


#Sophie's example for inspiration
shiny::runGitHub('lectures', 'msan622', subdir = '/MultivariateData/Heatmap')

numColors <- length(levels(state_data$Region)) # How many colors you need
getColors <- brewer_pal('qual') # Create a function that takes a number and returns a qualitative palette of that length (from the scales package)
myPalette <- getColors(numColors)
names(myPalette) <- levels(state_data$Region) # Give every color an appropriate name
p <- p + theme(axis.text.y = element_text(colour=myPalette[state_data$Region]))
p
