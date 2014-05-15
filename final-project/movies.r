require(stringr)
require(ggplot2)
require(reshape)

#setwd('~/Documents/career/sling/ml-1m/')

movies <- read.csv('movies.dat', sep='\t', header=FALSE, strip.white=TRUE, 
                   stringsAsFactors=FALSE, encoding='UTF-8', fileEncoding='iso-8859-1')

colnames(movies) <- c('movie_id', 'title', 'year', 'genre')

genres = c("Action", "Adventure", "Animation", "Children's", "Comedy", 
           "Crime", "Documentary", "Drama","Fantasy", "Film-Noir", "Horror", "Musical",
           "Mystery", "Romance", "Sci-Fi", "Thriller", "War", "Western")

##create genre columns
genre_bin <- vector('list', length(genres))
for (i in 1:length(genres)) {
  names(genre_bin)[i] <- genres[i]
  values <- rep(0, nrow(movies))
  values[which(str_detect(movies$genre, genres[i]))] <- 1
  genre_bin[[i]] <- values
}

movies <- cbind(movies, do.call(cbind, genre_bin))
movies$cross_genre <- rowSums(movies[,5:22])

movies$decade <- cut(movies$year, breaks = c(0, 1949, 1959, 1969, 1979, 1989, 1999, Inf),
                     labels = c('< 1950', '1950s', '1960s', '1970s', '1980s', '1990s', '2000s'))





