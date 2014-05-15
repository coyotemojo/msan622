Final Project
==============================

| **Name**  | Jason Ament |
|----------:|:-------------|
| **Email** | jeament@dons.usfca.edu |

## MovieLens Dataset Exploration

My final proect consists of an exploration of the MovieLens 1M dataset, a set of 3 tables of data relating 1 million individual ratings by 6,000 users on 4,000 movies.  Full details and the dataset can be found [here.](http://grouplens.org/datasets/movielens/)


###Technique 1 - Heatmap###

![Heatmap](heatmap.png)

 For the first technique, I wanted to explore and visualize the frequency of movie genres within the dataset.  Each movie could be tagged with one or more of 18 distinct genres, and I wanted the viewer to be able to understand which genres occurred the most frequently, both as single genres and as instances of co-occurrence with other genres.  The co-occurence heatmap seemed to be a good choice to convey this information.  
 
 To accomplish this effect, I encoded the data so that the movie data frame had columns for every single distinct genre.  I then looped through the dataset and searched for each single genre within the movie's complete genre descritpion, and if a single genre was present in the compelete genre column the matching single genre columns each receive a '1' to indicate presence of that genre.  Otherwise, the non-matching genres for that title received a '0'.  I therefore had a matrix of title and genres which I was able to use to create a 
  * How you encoded the data
  * Evaluation of lie factor, data density, and data to ink ratio
  * What visualization excels at
  * What you learned about the dataset as a result

###Technique 2 - Scatterplot ###

  * How you encoded the data
  * Evaluation of lie factor, data density, and data to ink ratio
  * What visualization excels at
  * What you learned about the dataset as a result

###Technique 3 - Small Multiples ###

###Technique 4 - Bubble Plot ###

###Interactivity###

  * Type of interactivty
  * How it enhances visualiation

###Prototype Feedback###

  * Description of prototype presented
  * Changes made based on feedback
  * Feedback you found helpful and why
  * Feedback you did not agree with and why

###Challenges###

  * how you addressed
  * why you did not address
  * what would you have done with more time
