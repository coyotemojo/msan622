require(tm)
require(SnowballC)

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

book_corpus <- tm_map(
  book_corpus, 
  stemDocument,
  lang = "porter") # try porter or english

book_corpus <- tm_map(
  book_corpus, 
  stripWhitespace)

# Remove specific words
#sotu_corpus <- tm_map(
#  sotu_corpus, 
#  removeWords, 
#  c("will", "can", "get", "that", "year", "let"))

print(book_corpus[['siddhartha.txt']])

book_tdm <- TermDocumentMatrix(book_corpus)

findFreqTerms(book_tdm, 20)

book_matrix <- as.matrix(book_tdm)

book_df <- data.frame(
  word = rownames(book_matrix), 
  # necessary to call rowSums if have more than 1 document
  freq = rowSums(book_matrix),
  stringsAsFactors = FALSE) 

# Sort by frequency
book_df <- book_df[with(
  book_df, 
  order(freq, decreasing = TRUE)), ]

# Do not need the row names anymore
rownames(book_df) <- NULL

# Check out final data frame
# View(sotu_df)








