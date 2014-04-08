library(ggplot2)
library(shiny)
library(grid)

df <- data.frame(state.x77,
                 State = state.name,
                 Abbrev = state.abb,
                 Region = state.region,
                 Division = state.division
)

#creating a couple of possibly interesting calculated metrics
df$pop_density <- df$Population/df$Area
df$inc_density <- df$Income/df$Area

p <- ggplot(df, aes(
            x = Population,
            y = Income,
            color = Division,
            size = Murder))

p <- p + geom_point()
p #bubble plot is pretty easy - not sure how informative it is in this case

m <- lm(Murder ~ Population * Income * Illiteracy * Life.Exp * HS.Grad * Frost + Area, data = df)

#work on heat map

def processStates <- function (state_data) {
  
}


hm <- df[1:8]
hm <- rescaler(hm, type='range')
hm$sstate <- state.abb
melted<- melt(hm,id.vars='sstate')

p <- ggplot(melted, aes(x = sstate, y = variable))
p <- p + geom_tile(aes(fill = value), colour = "white")
p <- p + theme_minimal()
p







if(midrange[1] == midrange[2]) {
  # use a 3 color gradient instead
  p <- p + scale_fill_gradient2(low = palette[1], mid = palette[2], high = palette[4], midpoint = midrange[1])
}
else {
  # use a 4 color gradient (with a swath of white in the middle)
  p <- p + scale_fill_gradient(colours = palette, values = c(0, midrange[1], midrange[2], 1))
}

palette <- c("#008837", "#f7f7f7", "#f7f7f7", "#7b3294")
midrange <- c(.5,.5)
incVars <- colnames(df)[1:8]


getHeatmap <- function (df, incVars) {
  p <- ggplot(subset(df, df$variable %in% incVars), 
              aes(x=sstate, y=variable))
  p <- p + geom_tile(aes(fill = value), colour = "white")
  p <- p + theme_minimal()
  # remove axis titles, tick marks, and grid
  p <- p + theme(axis.title = element_blank())
  p <- p + theme(axis.ticks = element_blank())
  p <- p + theme(panel.grid = element_blank())
  # remove legend (since data is scaled anyway)
  p <- p + theme(legend.position = "none")
  p <- p + coord_flip()
  print(p)
}

getHeatmap(melted, incVars)
