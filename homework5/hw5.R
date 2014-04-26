require(ggplot2)
require(reshape)
require(shiny)
require(scales)

##help functions
scale_months <- function() {
  return(
    scale_x_discrete(
      name = "Month",
      expand = c(0, 0),
    )
  )
}


##load and transform data
data(Seatbelts)
times <- time(Seatbelts)
years <- floor(times)
years <- factor(years, ordered = TRUE)

months <- factor(
  month.abb[cycle(times)],
  levels = month.abb,
  ordered = TRUE
)

d <- data.frame(
  years,
  months,
  time = as.numeric(times),
  drivers_kill = as.numeric(Seatbelts[,'DriversKilled']),
  drivers_kill_inj = as.numeric(Seatbelts[,'drivers']),
  front_kill_inj = as.numeric(Seatbelts[,'front']),
  rear_kill_inj = as.numeric(Seatbelts[,'rear']),
  kms = as.numeric(Seatbelts[,'kms']),
  petrol_price = as.numeric(Seatbelts[,'PetrolPrice']),
  van_kill = as.numeric(Seatbelts[,'VanKilled']),
  law = as.numeric(Seatbelts[,'law'])
  )

d$total_kill_inj <- (d$drivers_kill_inj + d$front_kill_inj + d$rear_kill_inj)
d$total_kill_inj_per_km <- d$total_kill_inj/d$kms
d$drivers_kill_inj_per_km <- d$drivers_kill_inj/d$kms
d$front_kill_inj_per_km <- d$front_kill_inj/d$kms
d$rear_kill_inj_per_km <- d$rear_kill_inj/d$kms

melted <- melt(d, id = c('years', 'months', 'time'))


theme_heatmap <- function() {
  return (
    theme(
      axis.text.y = element_text(
        angle = 90,
        hjust = 0.5),
      axis.ticks = element_blank(),
      axis.title = element_blank(),
      legend.direction = "horizontal",
      legend.position = "bottom",
      panel.background = element_blank()
    )
  )
}


##heatmap
p <- ggplot(
  subset(melted, variable == "total_kill_inj_per_km"), 
  aes(x = months, y = years)
)

p <- p + geom_tile(aes(fill = value), colour = "white")

p <- p + scale_fill_gradient(low='white', high='red')
p <- p + scale_months()
p <- p + scale_y_discrete(expand = c(0, 0))
p <- p + theme_heatmap()
p <- p + coord_fixed(ratio = 1)
p <- p + coord_flip()

print(p)


##overview + detail plt

grey <- "#dddddd"

plotOverview <- function(start = 1969, num = 12) {
  xmin <- start
  xmax <- start + (num / 12)
  
  ymin <- 1500
  ymax <- 4500
  
  p <- ggplot(d, aes(x = time, y = total_kill_inj))
  
  p <- p + geom_rect(
    xmin = xmin, xmax = xmax,
    ymin = ymin, ymax = ymax,
    fill = grey)
  
  p <- p + geom_line(color=ifelse(d$law ==1, 'red', 'black'))
  
  p <- p + scale_x_continuous(
    limits = range(melted$time),
    expand = c(0, 0),
    breaks = seq(1969, 1984, by = 1))
  
  p <- p + scale_y_continuous(
    limits = c(ymin, ymax),
    expand = c(0, 0),
    breaks = seq(ymin, ymax, length.out = 3))
  
  p <- p + theme(panel.border = element_rect(
    fill = NA, colour = grey))
  
  p <- p + theme(axis.title = element_blank())
  p <- p + theme(panel.grid = element_blank())
  p <- p + theme(panel.background = element_blank())
  
  return(p)
}

plotArea <- function(start = 1969, num = 12) {
  xmin <- start
  xmax <- start + (num / 12)
  
  ymin <- 0
  ymax <- 4500
  
  p <- ggplot(
    subset(melted, variable %in% c('drivers_kill_inj',
                                 'front_kill_inj',
                                 'rear_kill_inj')),
    aes(x = time, y = value, 
        group = variable,
        fill = variable))
  
  p <- p + geom_area()
  
  minor_breaks <- seq(
    floor(xmin), 
    ceiling(xmax), 
    by = 1/ 12)
  
  p <- p + scale_x_continuous(
    limits = c(xmin, xmax),
    expand = c(0, 0),
    oob = rescale_none,
    breaks = seq(floor(xmin), ceiling(xmax), by = 1),
    minor_breaks = minor_breaks)
  
  p <- p + scale_y_continuous(
    limits = c(ymin, ymax),
    expand = c(0, 0),
    breaks = seq(ymin, ymax, length.out = 5))
  
  p <- p + theme(axis.title = element_blank())
  
  p <- p + theme(
    legend.text = element_text(
      colour = "white",
      face = "bold"),
    legend.title = element_blank(),
    legend.background = element_blank(),
    legend.direction = "horizontal", 
    legend.position = c(0, 0),
    legend.justification = c(0, 0),
    legend.key = element_rect(
      fill = NA,
      colour = "white",
      size = 1))
  
  return(p)
}

test_start = 1969
print(plotOverview(start = test_start))

first = 'front_kill_inj'
first = 'drivers_kill_inj'

melted$variable <- relevel(melted$variable, first)

print(plotArea(start = test_start))




