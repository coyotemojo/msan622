Homework 1: Basic Charts
==============================

Visualizations
------------------------------

You must create the following plots in a single `R` script:

- **Plot 1: Scatterplot.** Produce a scatterplot from the `movies` dataset in the `ggplot2` package, where `budget` is shown on the x-axis and `rating` is shown on the y-axis. Save the plot as `hw1-scatter.png`.

![scatter plot](hw1-scatter.png)

In the scatter plot I explored several parameters.  First, I noticed that many of the points overlap one another, so I played with the size of the point, the transparency of the point, and the shape of the point to make sure the viewer could see most of the locations of all points as well as wehre the points were the most dense.   I also investigated using a log scale on the x axis so that the points would be more spread out, but I decided that the benefit was not worth the congnitive effort required to understand the relationship of movie budget on the log scale.  I change the axis labels on both axes - for the x axis I reduced the budget to millions and for the y axis I set the labels to range from 2 to 10 in increments of 2 rather than the ggplot default of 2.5, 5, 7.5 and 10 because I thought the plot needed just a little more detail in that sense.  I also change the axis text font color to black for more visibility and I chose a color from a color brewer palette with the plan of using another color from the same palette for future plots in the assignment.

- **Plot 2: Bar Chart.** Count the number of action, adventure, etc. movies in the `genre` column of the `movies` dataset. Show the results as a bar chart, and save the chart as `hw1-bar.png`.

![scatter plot](hw1-bar.png)

For the bar plot I first sorted the genres by decreasing counts so that the most frequent genre would show up on the left-hand side of the plot.  Then I set about removing as much 'chart junk' as possible, such as the axis titles, the x axis tick marks, and the x axis gridlines.  I also chose a complementary color from the same colorbrewer palette as the scatter plot above for all genres and decided against coloring each bar differently, since doing so wouldn't add any information to the plot.  Finally, I shrank the size of the axis label text so that the 'documentary' label wasn't so crowded by adjacent labels.  

- **Plot 3: Small Multiples.** Use the `genre` column in the `movies` dataset to generate a small-multiples scatterplot using the `facet_wrap()` function such that `budget` is shown on the x-axis and `rating` is shown on the y-axis. Save the plot as `hw1-multiples.png`.

![scatter plot](hw1-multiples.png)

- **Plot 4: Multi-Line Chart.** Produce a multi-line chart from the `eu` dataset (created by transforming the `EuStockMarkets` dataset) with `time` shown on the x-axis and `price` on the y-axis. Draw one line for each index on the same chart. Save the plot as `hw1-multiline.png`.

  You will need to perform some additional transformations of the dataset before being able to generate this chart. See the multi-line plot code from class for an example.

For each chart, use `ggsave()` to save each chart as a `png` image. Make sure to set a reasonable width and height.

To receive full points, you are required to add an appropriate chart title and axis labels to your charts *and* use color consistently in your charts. Optionally, consider the other aesthetic aspects of your chart. Play around with the settings for the major/minor tick marks, colors, shape, text, and the legend. 

:warning: You will not receive full points if you only specify the data and use all the default values for the other parameters.

Discussion
------------------------------

In your discussion, include each of the four images generated and a brief discussion following each image about the customization performed. For example, how did you use color? Why did you move the legend? (And so on.) The discussion for each image should be limited to a single paragraph with approximately 3 to 5 sentences.

Submission
------------------------------

Place all of your `R` code in a single file, and include it and all generated images in a `homework1` directory within your `msan622` repository on GitHub. Make sure to include a `README.md` file with your name, USF email, instructions on running your code, and brief discussion.

After all of the necessary files are pushed to your repository, submit a link to your `homework1` directory on Canvas.

:warning: Please note that late submissions are not accepted. GitHub shows when you modified a file, so be sure not to modify your code after the deadline!

