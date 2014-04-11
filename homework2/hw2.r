library(ggplot2)
library(scales)
data(movies)

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

movies <- cbind(movies, genre)
movies$genre <- factor(movies$genre, levels=c('Action',
                                              'Animation',
                                              'Comedy',
                                              'Documentary',
                                              'Drama',
                                              'Mixed',
                                              'Romance',
                                              'Short',
                                              'None'))


#incGenres <- c('Action')
incGenres <- levels(movies$genre)
#incRating <- c('R')
incRating <- levels(movies$mpaa)
#palette <- palette("default")

#scale_color_brewer(palette = "Pastel1")
#scale_color_brewer(palette = "Accent")
#scale_color_brewer(cpalette = "Accent")

test <- scale_colour_hue(n=4)

cpalette <- brewer_pal(type = "qual", palette = "Set1")(4)
#cpalette1 <- brewer_pal(type = "qual", palette = "Accent")(4)

gg_color_hue <- function(n) {
  hues = seq(15, 375, length=n+1)
  hcl(h=hues, l=65, c=100)[1:n]
}

millions_formatter <- function(x) {
  #label <- round(x / 1000)
  return(sprintf("$%dM", round(x / 1000000)))
}

dpalette <- gg_color_hue(4)


dotAlpha <- 1
dotSize <- 4

makePlot <- function (movies, incRating, incGenres, cpalette, dotSize, dotAlpha, scale) {
  genres <- levels(movies$genre)
  p <- ggplot(subset(movies, movies$genre %in% incGenres & movies$mpaa %in% incRating), 
              aes(x=budget, y=rating, color=mpaa))
  p <- p + geom_point(size=dotSize, alpha=dotAlpha)
  p <- p + xlab('Budget (Millions)')
  p <- p + ylab('Rating')
  #p <- p + scale_x_continuous(label = millions_formatter)
  
  p <- p + scale_y_continuous(breaks = seq(0,10,2))
  p <- p + scale_color_manual(values = cpalette)
  if (scale == TRUE) {
    p <- p + scale_x_continuous(trans=log10_trans(), 
                    breaks = trans_breaks("log10", function(x) 10^x), 
                   labels = dollar)
  }
  else {
    p <- p + scale_x_continuous(label = millions_formatter)
  }
  p <- p + theme(legend.position = 'bottom', 
        legend.justification = c(1, 0),
        legend.direction = "horizontal",
        legend.key.size = unit(1.5,"lines"),
        panel.background = element_rect(fill = NA),
        axis.ticks = element_line(colour = "black"),
        axis.line = element_line(colour = "black"),
        axis.text.x  = element_text(size=12, color='black'),
        axis.text.y  = element_text(size=12, color='black')) 
  print(p)
}

makePlot(movies, incRating, incGenres, dpalette, dotSize, dotAlpha, scale)
scale <- TRUE


