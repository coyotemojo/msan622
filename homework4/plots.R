require(ggplot2)
require(wordcloud)

# Plot frequencies
p <- ggplot(sid_freq_df, aes(x = word, y = freq)) +
  geom_bar(stat = "identity", fill = "#018571") +
  ggtitle('Top 15 Words by Frequency in "Siddhartha"') +
  coord_flip() +
  ylab("Frequency") +
  theme_minimal() +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid = element_blank()) +
  theme(axis.ticks = element_blank()) +
  theme(axis.title.y = element_blank()) +
  theme(axis.text.y  = element_text(face='bold', size=12))
print(p)

q <- ggplot(bge_freq_df, aes(x = word, y = freq)) +
  geom_bar(stat = "identity", fill = "#a6611a") +
  ggtitle('Top 15 Words by Frequency in "Beyond Good and Evil"') +
  coord_flip() +
  ylab("Frequency") +
  theme_minimal() +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid = element_blank()) +
  theme(axis.ticks = element_blank()) + 
  theme(axis.title.y = element_blank()) +
  theme(axis.text.y  = element_text(face='bold', size=12))

print(q)

comparison.cloud(book_matrix,
  max.words=150,
  random.order=FALSE,
  colors=c('#018571', '#a6611a'),
  title.size=1)

commonality.cloud(book_matrix,random.order=FALSE, max.words=100, colors='blue')

