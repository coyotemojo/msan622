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

# book_corpus <- tm_map(
#   book_corpus, 
#   stemDocument,
#   lang = "porter") # try porter or english

book_corpus <- tm_map(
  book_corpus, 
  stripWhitespace)

#print(book_corpus[['siddhartha.txt']])

book_tdm <- TermDocumentMatrix(book_corpus)

#findFreqTerms(book_tdm, 20)

book_matrix <- as.matrix(book_tdm)
colnames(book_matrix) <- c("Beyond Good and Evil", "Siddhartha")
#swapping order of the columns for the comparison cloud
book_matrix <- book_matrix[,c(2,1)]

#Create single frequency data frame
freq_df <- data.frame(
  word = rownames(book_matrix), 
  # necessary to call rowSums if have more than 1 document
  freq = rowSums(book_matrix),
  stringsAsFactors = FALSE) 

# Sort by frequency
freq_df <- freq_df[with(
  freq_df, 
  order(freq, decreasing = TRUE)), ]

rownames(freq_df) <- NULL



#Find most frequent words for both texts
sid_freq_df <- sort(book_matrix[,1], decreasing=TRUE)[1:15]
sid_freq_df <- data.frame(
  word = names(sid_freq_df),
  freq = sid_freq_df)
sid_freq_df <- sid_freq_df[order(sid_freq_df$freq),]

sid_freq_df$word <- factor(sid_freq_df$word,
                           levels = sid_freq_df$word,
                           ordered = TRUE)
rownames(sid_freq_df) <- NULL


bge_freq_df <- sort(book_matrix[,2], decreasing=TRUE)[1:15]
bge_freq_df <- data.frame(
  word = names(bge_freq_df),
  freq = bge_freq_df)
bge_freq_df <- bge_freq_df[order(bge_freq_df$freq),]

bge_freq_df$word <- factor(bge_freq_df$word,
                           levels = bge_freq_df$word,
                           ordered = TRUE)
rownames(bge_freq_df) <- NULL


#Create comparison data frame
comp_df <- data.frame(
  "Siddhartha" = book_matrix[,1],
  "Beyond.Good.and.Evil" = book_matrix[,2],
  stringsAsFactors = FALSE)

rownames(comp_df) <- rownames(book_matrix)

comp_df <- comp_df[order(
  rowSums(comp_df), 
  decreasing = TRUE),]

comp_df_top <- head(comp_df, 25)


#indexing by regex on rowname
#book_matrix[grep('philosop', rownames(book_matrix)),]


