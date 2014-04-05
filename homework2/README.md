Homework2: Interactivity
==============================

| **Name**  | Jason Ament  |
|----------:|:-------------|
| **Email** | jeament@dons.usfca.edu |

## Instructions ##

The following packages must be installed prior to running this code:

- `ggplot2`
- `shiny`

To run this code, please enter the following commands in R:

```
library(shiny)
shiny::runGitHub('msan622', 'coyotemojo', 'homework2')
```

This will start the `shiny` app. See below for details on how to interact with the visualization.

## Discussion ##
![movies scatter plot](shiny-scatter.png)

This is an interactive visualization of the movies dataset using the shiny R package.  For the most part, this visualization meets the basic requirements of the assignment along with a host of tweaks to various cosmetic elements of the plot.  The cosmetic adjustments are listed here:
* No plot title, since the heading of the shiny panel works as an overall title for the page
* Removed gray background in the plot area so that the data points would show up clearer on a white background
* Removed minor gridlines as they didn't seem to add anything but visual noise to the chart
* Drew a black rectangular line around the plot area to help it stand out against the white page
* Many tweaks to the axes:
  * Removed excess padding between axes and plot area
  * Made tick marks, axis titles and text all black to stand out better against the white background
  * Increased the size of the axis titles so that they were more visible
  * Set y label breaks to 0 through 10 so that all movies would be visible in the context of all possible ratings values.
  * Set x label breaks to be fairly spares and formatted to millions, with a $ and M around the numbers
  * Moved axis titles a little away from the axes themselves to avoid crowding
* Many tweaks to the legeng:
  * Moved the legend into the lower-righthand corner of the plot area which is always unused by data points
  * Made legend horizontal, increased the size of both the legend title and legend text to improve readability, removed background fill so that legend would blend in better with the plot
  * Changed title to "MPAA Rating" instead of "mpaa," which is how the field is labeled in the dataset to improve readability and context
  * Made sure that the legend title and axes title were similar in appearance in terms of size/font face
* Made sure that movies of each MPAA Rating category keep their assigned color regardless of how the dataset is filtered in the interface
* Beyond the basic required functionality, I also added the ability to change the x axis to a log scale of budget, since by default many of the movies clump together at the lower end of the budget scale.  This allows the viewer to decide he/she would like to explore the distribution of movies on the budget scale.  When the scale changes, the labels and breaks are updated appropriately to reflect the change
  
