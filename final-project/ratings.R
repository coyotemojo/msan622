

ratings <- read.csv('./ratings.dat', sep='\t')

colnames(ratings) <- c('user_id', 'movie_id', 'rating', 'timestamp')
#ratings$timestamp <- as.POSIXct('1970-01-01') + ratings$timestamp
ratings$timestamp <- NULL




