library(scales)

data('iris')

p <- ggplot(iris, aes(x = Sepal.Length,
                      y = Sepal.Width,
                      color = Species))
p <- p + xlab('Sepal Length')
p <- p + ylab('Sepal Width')
p <- p + ggtitle('Iris Data')
p <- p + labs(color="Iris Species")
p <- p + geom_point(size = 4,                                 
                    position='jitter')
#p <- p + xlim(4,8)
#p <- p + ylim(1,5)

p <- p + scale_x_continuous(limits = c(4,8), expand = c(0,0))
p <- p + scale_y_continuous(limits = c(1,5), expand = c(0,0))
p <- p + coord_fixed(ratio = 1)
p <- p + theme(panel.background = element_rect(fill = NA))
p <- p + theme(legend.key = element_rect(fill = NA))
p <- p + theme(panel.border = element_rect(fill=NA, color= 'grey60'))
p <- p + panel.grid.major = element_line(color = 'grey90')
p <- p + panel.grid.minor = element_line(color = 'grey90', linetype='dotted')

p <- p + theme(legend.position=c(0,0))
p <- p + theme(legend.justification = c(0,0))
p <- p + theme(legend.direction = 'horizontal')
p <- p + theme(legend.background = element_blank())

palette <- brewer_pal(type='qual', palette = 'Set1')(3)

p <- p + scale_color_manual(values = palette)
print(p)

species <- levels(iris$Species)
highlight <- c("Versicolor", "Virginica")
highlight <- c("Versicolor")

palette[which(!species %in% highlight)] <- "#EEEEEE"

levels(iris$Species) <- c('Setosa', 'Versicolor', 'Virginica')

str(iris)
