library(ggplot2)
library(shiny)
require(plyr)
library(reshape)
library(scales)
require(grid)

source('./movies.r')
source('./users.r')
source('./ratings.r')

# create the big merged table
top9_genres <- names(sort(table(movies$genre), decreasing=TRUE)[1:9])
#merged <- merge(ratings, subset(movies, select = c(1:4)), by.x='movie_id', by.y='movie_id')
merged <- merge(ratings, movies, by.x='movie_id', by.y='movie_id')
merged <- merge(merged, users, by.x='user_id', by.y='user_id')
merged <- ddply(merged, .(movie_id, gender, genre, age, cross_genre), summarize, avg_rating=mean(rating))
merged$genre <- ifelse(merged$genre %in% top9_genres, merged$genre, 'Other')

levels(merged$gender)[levels(merged$gender)=="F"] <- "Female"
levels(merged$gender)[levels(merged$gender)=="M"] <- "Male"

getTopGenres <- function(df, limit=1) {
  cooc_matrix <- data.frame(crossprod(as.matrix(df[,genres]), as.matrix(df[,genres])))
  names(cooc_matrix) <- genres
  melted_mat <- melt(data.frame(genres, cooc_matrix))
  levels(melted_mat$variable) <- genres
  melted_mat$variable <- factor(melted_mat$variable, names(sort(apply(cooc_matrix, 1, max), decreasing=TRUE)))
  melted_mat$genres <- factor(melted_mat$genres, names(sort(apply(cooc_matrix, 1, max), decreasing=TRUE)))
  p <- ggplot(melted_mat, aes(x=genres, y=variable))
  p <- p + geom_tile(aes(fill=value), color='white')
  p <- p + scale_y_discrete(expand = c(0, 0))
  p <- p + scale_x_discrete(expand = c(0, 0))
  p <- p + theme(axis.ticks = element_blank(),
                 axis.title = element_blank(),
                 axis.text.y = element_text(colour = 'black'),
                 panel.border = element_rect(colour = 'grey', fill=NA))
  #               legend.direction = "horizontal",
  #               legend.position = "bottom")
  p <- p + ggtitle('Genre and Genre Co-occurrence Frequencies')
  p <- p + scale_fill_gradient(name='Occurrences',low = "white", high = "steelblue", 
                               limits=c(0,limit * max(melted_mat$value)),
                               labels=comma)
  p <- p + theme(axis.text.x = element_text(angle = 45, hjust = 1, color='black'))
  return(p)
}

getUserDist <- function(df, genders) {
  df <- df[df$gender %in% genders,]
  p <- ggplot(df, aes(y = occupation,
                      x = age,
                      color = gender))
  p <- p + geom_point(alpha = 0.6, position = "jitter")
  p <- p + theme_bw()
  p <- p + theme(panel.grid.major = element_blank(),
                 panel.grid.minor = element_blank(),
                 axis.ticks = element_blank())
  p <- p + scale_y_discrete(expand = c(0, 0))
  p <- p + scale_x_discrete(expand = c(0, 0))
  p <- p + theme(axis.title = element_blank())
  p <- p + geom_hline(yintercept = c(seq(.5, 21.5, by=1)), color='grey')
  p <- p + geom_vline(xintercept = c(seq(.5, 7.5, by=1)), color='grey')
  p <- p + ggtitle('Age, Gender, and Occupation of Movie Lens Users')
  p <- p + theme(legend.direction = "horizontal",
                 legend.position = "bottom")
  p <- p + guides(color=guide_legend(title=NULL))
  p <- p + scale_color_discrete(limits = levels(df$gender))
  return(p)
}

getGenderRats <- function(df) {
  p <- ggplot(df, aes(x = genre, y=avg_rating, fill=age)) +
    geom_boxplot()
  p <- p+ facet_wrap(~gender, nrow=2)
  p <- p + theme_bw()
  p <- p + theme(axis.title = element_blank())
  p <- p + theme(panel.grid.major.x = element_blank())
  p <- p + theme(axis.ticks = element_blank())
  p <- p + ylab('Mean Star Rating')
  p <- p + theme(legend.direction = "horizontal",
                 legend.position = "bottom",
                 legend.key = element_blank(),
                 strip.background = element_rect(colour='grey', fill='white'),
                 panel.border = element_rect(colour = 'grey', fill=NA))
  p <- p + guides(fill=guide_legend(title=NULL))
  p <- p + theme(axis.text.x = element_text(angle = 45, hjust = 1))
  p <- p + ggtitle('Mean Star Ratings Within Genres by Age and Gender')
  return(p)
}


getRecoScatter <- function(df) {
  p <- ggplot(df, aes(
    y = Ratings,
    x = Mean.Rating,
    size = cross_genre,
    color= decade))
  p <- p + geom_point(alpha = 0.6, position = "jitter")
  p <- p + scale_color_discrete(name="Release Decade")
  p <- p + scale_size_continuous(range = c(1, 10), guide='none')
  p <- p + ylab('Number of Individual Ratings')
  p <- p + xlab('Mean Star Rating')
  p <- p + scale_x_continuous(limits=c(1, 5), breaks=seq(1,5,1))
  p <- p + theme(panel.background = element_rect(fill = 'NA', colour = 'grey'))
  max_count = max(df$Ratings)
  p <- p + annotate(
    "text", x = 1.5, y = max_count + 1,
    hjust = 0.25, color = "grey40",
    label = "Circle area proportional to number of genres associated with title.")
  return(p)
}

filterUsers <- function(df, genders, ages, occupations) {
  filtered_users <- df[(df$gender %in% genders &
                          df$age %in% ages &
                          df$occupation %in% occupations),]
  return(filtered_users)
}

filterRatings <- function(df, movies, users) {
  mean_ratings <- ddply(subset(df, df$user_id %in% users$user_id),
                        .(movie_id), summarize, Mean.Rating = mean(rating),
                        Ratings = length(movie_id),
                        Disagreement = round(sd(rating)),2)
  movies_w_ratings <- merge(movies, mean_ratings, by.x='movie_id', by.y='movie_id')
  movies_w_ratings$genre <- ifelse(movies_w_ratings$genre %in% top9_genres, movies_w_ratings$genre, 'Other')
  movies_w_ratings$Disagreement <- ifelse(is.na(movies_w_ratings$Disagreement), 0, movies_w_ratings$Disagreement)
  movies_w_ratings <- movies_w_ratings[order(-movies_w_ratings[,'Ratings'],
                                             -movies_w_ratings[,'Mean.Rating'],
                                             -movies_w_ratings[,'Disagreement']),]
  return(movies_w_ratings[,c(2:4,23:27)])
}


#shared data
#gender_palette <- c('#e7298a','#7570b3' ) 

shinyServer(function(input, output) {

  localMovies <- movies
  localUsers <- users
  localRatings <- ratings
  localSummary <- merged
  
  genderFilter <- reactive({
    if (length(input$selectGender) == 0) {
      return(c('Female','Male'))
    }
    else {
      return(input$selectGender)  
    }
  })
  
  genderFilter2 <- reactive({
    if (length(input$chooseGender) == 0) {
      return(c('Female', 'Male'))
    }
    else {
      return(input$chooseGender)
    }
  })
  
  ageFilter <- reactive({
      return(input$selectAge)  
  })
  
  occFilter <- reactive({
      return(input$selectOcc)
  })
  
  output$topGenres <- renderPlot({
    topGenres <- getTopGenres(
      localMovies,
      input$limit) 
    print(topGenres)
  })
  
  output$userDist <- renderPlot({
    userDist <- getUserDist(
      localUsers,
      genderFilter()
      )
    print(userDist)
  })
  
  output$ratingsTable <- renderDataTable({
    filterRatings(localRatings,
                  localMovies,
                  filterUsers(
                    localUsers,
                    genderFilter2(),
                    ageFilter(),
                    occFilter()
                    )
    )[,-c(4:5)]
  })
  
  output$recoScatter <- renderPlot({
    recoScatter <- getRecoScatter(
      filterRatings(localRatings,
                    localMovies,
                    filterUsers(
                      localUsers,
                      genderFilter2(),
                      ageFilter(),
                      occFilter()
                    )
      )
    )
    print(recoScatter)
  })

  output$genderRats <- renderPlot({
    genderRats <- getGenderRats(
      localSummary
      )
    print(genderRats)
})
})
