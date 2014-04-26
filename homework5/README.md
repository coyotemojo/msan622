Homework [#]: [HOMEWORK NAME]
==============================

| **Name**  | Jasons Ament |
|----------:|:-------------|
| **Email** | jeament@dons.usfca.edu |

## Instructions ##

The following packages must be installed prior to running this code:

- `ggplot2`
- `shiny`
- `grid`
- `reshape`
- `scales`

To run this code, please enter the following commands in R:

```
library(shiny)
shiny::runGitHub('msan622', 'coyotemojo', subdir='homework5')
```

## Discussion ##

For this assignment, I chose two visualizations in Shiny.  The first plot is a stacked area plot on the upper half of the page focusing in on a particular part of the time series with an accompanying overview line plow below providing context on where exactly the viewer is in the time series.  I wanted to try to understand how total deaths and injuries changed over the years and specifically how they changed when the new seatbelt law was enactec in Feb 2003.  I thought that a stacked area chart would allow the viewer to see how total deaths/injuries were composed across those of drivers, front passengers, and rear passengers.  A stacked area plot allows all three series to be presented at one time, which increases the data ink ratio for the plot.  Yet another boost to the data/ink ratio comes from including the overview plot at the bottom of the page.  In one viewpoint, the user can see detail on the series, overall location of the series, and get a general sense of the proportion of injuries by position.  In addition, the user can initiate an animation that will scroll through each year in the series.

I had wanted to apply brushing as well so that the user could select a particular category of car position and see that value positioned at the base of the y axis in color, while keeping the total stacked area on the chart at the same time but greyed out.  That way the viewer could focus in on a particular category and understand the specific trend for that category while still seeing the total injury count across all categorie.  The viewer could also get a sense for how the proportion of total injuries accounted for by that category changed over time.  I had difficulty reordering the data so that I could place the correct variable on the base of the axis and maintain color assignment, so I abandoned this attempt.  

My last tweak to the stacked area/overview plot was to color in red the part of the overview plotlie corresponding to the time when the new seatbelt law went into effect.  I added an annotation to call out the meaning of the line as well.

For the second plot, I chose to create a heatmap, but I wanted to normalize the deaths/injuries by the number of kilometers driven to get a sense for how dangerous driving per kilometer actually has been over the years. I had to do some work to play with the color scales so that less death/injuries per km showed up as lighter colors and more death/injuries showed up as darker colors.  That seemed to make more sense.  Other than normalizing by km driven and playing with the scales I didn't really do much else to this plot.  Of course, there is some lie factor inherent in the heatmap as the color scale is very disjointed - it's difficult to see how specific numbers match up to the death/injury per km in each month.  
