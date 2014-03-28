setwd('~/Documents/msan/classes/data_visualization/msan622/homework1/')

library(ggplot2)
library(scales)
library(reshape2)
library(knitr)

data(movies)
data(EuStockMarkets)

movies <- movies[which(movies$budget >0),]

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

#Create a scatterplot of movie ratings vs.  movie budget
scatter <- ggplot(movies, aes(x=budget, y=rating)) +
  geom_point(size=1, alpha=.75, color='#7fc97f', shape=1,
             position=position_jitter(width=1,height=.5)) +
  xlab('Budget in Millions, USD') +
  ylab('Rating') +
  ggtitle('Movie Ratings vs. Budget') + 
  #scale_x_continuous(trans=log10_trans(), 
  #                   breaks = trans_breaks("log10", function(x) 10^x), 
  #                   labels = dollar) +
  scale_x_continuous(breaks = seq(0, 200000000, 50000000), 
                     labels = c('$0', '$50', '$100', '$150', '$200')) +
  scale_y_continuous(breaks = seq(0,10,2)) +
  theme(panel.grid.minor=element_blank(),
        axis.text.x  = element_text(size=9, color='black'),
        axis.text.y  = element_text(size=9, color='black'))  +
  ggsave(filename = 'hw1-scatter.png', scale=1.8, width = 4, height = 3, 
         dpi = 300, bg = "transparent", units='in')
scatter

#order the genre factor by frequency so bar chart is sorted
movies <- transform(movies, genre = ordered(genre, 
          levels = names(sort(table(movies$genre), decreasing=TRUE))))

bar <- ggplot(movies, aes(x=genre)) +
  geom_bar(color = 'black', fill = '#beaed4',stat='bin') +
  xlab('Genre') +
  ylab('Frequency') +
  scale_y_continuous(labels=comma,
                     expand = c(0,50)) +
  ggtitle('Count of Movies by Genre') +
  theme(axis.ticks.x = element_blank(), 
        panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.x  = element_text(size=9, color='black'),
        axis.text.y  = element_text(size=9, color='black')) +
  ggsave(filename = 'hw1-bar.png', scale=1.8, width = 4, height = 3, 
         dpi = 300, bg = "transparent", units='in')
bar

facet_plot <- scatter + 
  facet_wrap(~ genre) +
  ggsave(filename = 'hw1-multiples.png', scale=1.8, width = 4, height = 3, 
         dpi = 300, bg = "transparent", units='in')
facet_plot


## eu stock markets
eu <- melt(EuStockMarkets)
eu <- transform(eu, time=rep(time(EuStockMarkets),4))
eu$Var1 <- NULL
names(eu)[2] <- 'Index'

ggplot(eu, aes(x=time, y=value, group=Index, color=Index)) + 
  geom_line(alpha=.75, size=1) + 
  ylab('Closing Value') + 
  scale_y_continuous(labels = comma) +
  theme(axis.title.x=element_blank(), axis.title.y=element_blank()) +
  scale_x_continuous(breaks = c(seq(1992, 1999))) +
  ggtitle('Daily Closing Value of European Stock Indices') +
  theme(legend.position = c(.05, .9), 
       legend.justification = c(.025, .9), 
       legend.background = element_rect(colour = NA, fill = "white", size=.5),
       axis.text.x  = element_text(size=9, color='black'),
       axis.text.y  = element_text(size=9, color='black')) +
       #legend.key.size = unit(2)) +
  ggsave(filename = 'hw1-multiline.png', scale=1.8, width = 4.5, height = 3, 
         dpi = 300, bg = "transparent", units='in')




