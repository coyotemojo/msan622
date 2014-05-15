Final Project
==============================

| **Name**  | Jason Ament |
|----------:|:-------------|
| **Email** | jeament@dons.usfca.edu |

## MovieLens Dataset Exploration

My final proect consists of an exploration of the MovieLens 1M dataset, a set of 3 tables of data relating 1 million individual ratings by 6,000 users on 4,000 movies.  Full details and the dataset can be found [here.](http://grouplens.org/datasets/movielens/)


###Technique 1 - Heatmap###

![Heatmap](Heatmap.png)

 For the first technique, I wanted to explore and visualize the frequency of movie genres within the dataset.  Each movie could be tagged with one or more of 18 distinct genres, and I wanted the viewer to be able to understand which genres occurred the most frequently, both as single genres and as instances of co-occurrence with other genres.  The co-occurence heatmap seemed to be a good choice to convey this information.  
 
 To accomplish this effect, I encoded the data so that the movie data frame had columns for every single distinct genre.  I then looped through the dataset and searched for each single genre within the movie's complete genre descritpion, and if a single genre was present in the compelete genre column the matching single genre columns each receive a '1' to indicate presence of that genre.  Otherwise, the non-matching genres for that title received a '0'.  I therefore had a matrix of title and genres which I was able to use to create a co-occurence matrix by multiplying the genre matrix by itself, creating an 18 X 18 matrix with counts of individual genres on the diagonal and counts of co-occurences on the intersecting cells.
 
 The lie factor in the heatmap is present as the user may have difficulty knowing the exact number of occurrences based only on the color gradient.  This is somewhat unavoidable in a heatmap however.  The data density is fairly low, with signifigant portions of the plot displaying as white, especially when the slider is in default position and the full range of frequencies is being displayed in the plot.  The data to ink ratio is quite good - there is very little to distract the viewer from what he/she is meant to gleen from the plot. 
 
 This visualization excels at introducing the viewer to the various genres present in the dataset as well as the overall frequency of films with individual genres and the frequency of co-occurrence between genres.  The viewer can interact with the plot to easily discover that drama is the most frequent single genre in the dataset and that the most frequently co-occurring genres are drama/romance, drama/comedy, and romance/comedy.  The viewer can see how frequent children's/animation movies are compared to war/drama movies as well.  
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

 All but one of my plots featured interactivity.  The heatmap, for example, allows the user to adjust a slider to set the maximum genre count to include in the heatmap color scale.  This way, the viewer can lop off the most frequently occurring genres, which become gray, and see how some of the less-frequently occurring and co-occurring genres match up in terms of frquency.  In this way, the user isn't faced with a static plot that masks the relationships of the lower-frequency genres but instead can explore the frequencies and get a true sense of how often certain genres occur in the dataset.
 
  * Type of interactivty
  * How it enhances visualiation

###Prototype Feedback###

 When I presented my rough genre co-occurence heatmap, I received quite a bit of helpful feedback.  For one, at the time the color scale I was trying to use involved a divergent color scheme.  I had thought that I would use this to 'white out' the middle values in the heatmp so that the higher and lower values would stand out more.  The nature of the dataset is that the single genre counts are significantly higher than the co-occurrence counts, so the higher end of the scale dominated the color gradient.  It was suggested that I use a gradient starting with white on the low end and darkening to a final color at the high end.  This was very helpful.
 
 One bit of feedback that I did not find helpful on the heatmap was a suggestion to start the diagonal at the upper left and set the tiles to be 1:1.  I considered this but decided against it.  For one, it appears that you cannot set the x axis labels on the top of a plot.  I liked that the dark diagonal starts at the lower left corner and that is where the two axes labels meet, so the viewer is drawn to a point of the most information.  From there, the viewer can proceed into the plot with knowledge of where they are in the genre list.  In addition, setting the ratio to 1:1 would have resulted in a squarish heatmap, which would not have filled the page well, and the genre labels would have become cramped.
 
  * Description of prototype presented
  * Changes made based on feedback
  * Feedback you found helpful and why
  * Feedback you did not agree with and why

###Challenges###

 Once challenge I faced was g
  * how you addressed
  * why you did not address
  * what would you have done with more time
