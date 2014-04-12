# SCATTERPLOT MATRIX: IRIS DATASET
# http://www.inside-r.org/packages/cran/GGally/docs/ggpairs

# Load required packages
require(GGally)

state_data <- data.frame(state.x77,
                           State = state.name,
                           Abbrev = state.abb,
                           Region = state.region,
                           Division = state.division)

colnames(state_data) <- gsub("\\.", "", colnames(state_data))

region_palette <- brewer_pal(palette='Dark2')(4)

ggplot <- function(...) ggplot2::ggplot(...)


# Create scatterplot matrix
p <- ggpairs(state_data,
             # Columns to include in the matrix
             columns = c('Illiteracy', 'Murder', 'HSGrad', 'Frost'),
             
             # What to include above diagonal
             # list(continuous = "points") to mirror
             # "blank" to turn off
             upper = "blank",
             
             # What to include below diagonal
             lower = list(continuous = "points"),
             
             # What to include in the diagonal
             diag = list(discrete = "bar"),
             
             # How to label inner plots
             # internal, none, show
             axisLabels = "none",
             
             # Other aes() parameters
             colour = "Region",
             title = "State Scatterplot Matrix"
)
p

# Remove grid from plots along diagonal
for (i in 1:4) {
  # Get plot out of matrix
  inner = getPlot(p, i, i);
  
  # Add any ggplot2 settings you want
  inner = inner + theme(panel.grid = element_blank());
  
  # Put it back into the matrix
  p <- putPlot(p, inner, i, i);
}

test = getPlot(p, 1,4)
test <- ggplot(state_data, aes(x=Region, fill=Region)) + geom_bar() +
  geom_text(x=1, y=5, label='Northeast') +
  geom_text(x=2, y=5, label='South') + 
  geom_text(x=3, y=5, label='North Central') + 
  geom_text(x=4, y=5, label='West') 
test

p <- putPlot(p, test, 1, 4)

# Show the plot
print(p)
