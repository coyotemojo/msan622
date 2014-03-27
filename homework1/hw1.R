setwd('~/Documents/msan/classes/data_visualization/msan622/homework1/')

library(ggplot2)
library(scales)
library(reshape2)
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




scatter <- ggplot(movies, aes(x=budget, y=rating)) +
  geom_point(size=1, alpha=.9, color='blue') +
  xlab('Budget (Log Scale)') +
  ylab('Rating') +
  ggtitle('Movie Ratings by Budget') + 
  scale_x_continuous(trans=log10_trans(), 
                     breaks = trans_breaks("log10", function(x) 10^x), 
                     labels = dollar) +
  scale_y_continuous(breaks = seq(0,10,1)) +
  theme(panel.grid.minor=element_blank()) +
  ggsave(filename = 'hw1-scatter.png.', scale=1.8, width = 4, height = 3, 
         dpi = 150, bg = "transparent")
scatter

#order the genre factor by frequency so bar chart is sorted
movies <- transform(movies, genre = ordered(genre, 
          levels = names(sort(table(movies$genre), decreasing=TRUE))))

bar <- ggplot(movies, aes(x=genre)) +
  geom_bar(colour='black', fill = '#FF9999',stat='bin') +
  xlab('Genre') +
  ylab('Count') +
  scale_y_continuous(labels=comma)
  ggtitle('Frequency of Movies by Genre')
bar

facet_plot <- scatter + 
  facet_wrap(~ genre)
facet_plot


## eu stock markets
#eu <- transform(data.frame(test), time = time(test))


eu <- melt(EuStockMarkets)
eu <- transform(eu, time=rep(time(EuStockMarkets),4))
eu$Var1 <- NULL
names(eu)[2] <- 'Index'

ggplot(eu, aes(x=time, y=value, group=Index, color=Index)) + 
  geom_line(alpha=.75, size=.5) + 
  ylab('Closing Value') + 
  scale_y_continuous(labels = comma) +
  theme(axis.title.x=element_blank(), axis.title.y=element_blank()) +
  scale_x_continuous(breaks = c(seq(1992, 1999))) +
  ggtitle('Daily Closing Prices of European Stock Indices')


eu_melted <- cbind(eu_melted, rep(test, 4))
ggplot(eu, aes(x=rep(test, 4), y='Closing Value', group = Index, color=Index)) + geom_line()




