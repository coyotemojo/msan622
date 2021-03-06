require(tm)
require(SnowballC)
require(ggplot2)

book_source <- DirSource(
  directory = 'Documents/msan/classes/data_visualization/msan622/homework4/books/',
  encoding='UTF-8',
  pattern = '*.txt',
  ignore.case=TRUE)

book_corpus <- Corpus(
  book_source,
  readerControl = list(
    reader = readPlain)
  )

book_corpus <- tm_map(book_corpus, tolower)

book_corpus <- tm_map(
  book_corpus, 
  removePunctuation,
  preserve_intra_word_dashes = TRUE)

book_corpus <- tm_map(
  book_corpus, 
  removeWords, 
  stopwords("english"))

# book_corpus <- tm_map(
#   book_corpus, 
#   stemDocument,
#   lang = "porter") # try porter or english

book_corpus <- tm_map(
  book_corpus, 
  stripWhitespace)

# Remove specific words
#sotu_corpus <- tm_map(
#  sotu_corpus, 
#  removeWords, 
#  c("will", "can", "get", "that", "year", "let"))

#print(book_corpus[['siddhartha.txt']])

book_tdm <- TermDocumentMatrix(book_corpus)

#findFreqTerms(book_tdm, 20)

book_matrix <- as.matrix(book_tdm)

freq_df <- data.frame(
  word = rownames(book_matrix), 
  # necessary to call rowSums if have more than 1 document
  freq = rowSums(book_matrix),
  stringsAsFactors = FALSE) 

# Sort by frequency
freq_df <- freq_df[with(
  freq_df, 
  order(freq, decreasing = TRUE)), ]

# Do not need the row names anymore
rownames(freq_df) <- NULL

# Check out final data frame
# View(sotu_df)

comp_df <- data.frame(
  "Siddhartha" = book_matrix[, "siddhartha.txt"],
  "Beyond Good and Evil" = book_matrix[, "beyondgande.txt"],
  stringsAsFactors = FALSE)

rownames(comp_df) <- rownames(book_matrix)

comp_df <- comp_df[order(
  rowSums(comp_df), 
  decreasing = TRUE),]

comp_df_top <- head(comp_df, 15)

# Plot frequencies
p <- ggplot(comp_df_top, aes(Siddhartha,Beyond.Good.and.Evil))

p <- p + geom_text(
  label = rownames(comp_df_top),
  position = position_jitter(
    width = 2,
    height = 2))
print(p)




