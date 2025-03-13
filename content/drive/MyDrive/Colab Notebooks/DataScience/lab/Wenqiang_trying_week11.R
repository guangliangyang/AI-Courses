# getting started
# List of packages
packages <- c("knitr",
              "tidyverse",
              "tidytext",
              "here",
              "janeaustenr" , #jane austen books
              "stringr", #string manipulation
              "wordcloud", # word-cloud generator
              "RColorBrewer", # color palettes
              "rtweet", #twitter
              "httr", #twitter
              "textdata",
              "reshape2", "gutenbergr"
)

# Install them, if required, by uncommenting the following code
# Find packages that are not installed
packages_to_install <- packages[!(packages %in% installed.packages()[,"Package"])]
# Install required packages
if(length(packages_to_install) > 0) {
install.packages(packages_to_install, dependencies=TRUE)
}
# Load the packages
sapply(packages, library, character.only=TRUE)

#  In this lab we will use the "here" package for smart relative referencing. Check the starting point
# using:
library(here)

# ------------ Tokenization ------------------
# (1) Consider the following text by Emily Dickinson
text <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")
text

# • Create a tibble of this data.
# line = 1:4: This part creates a column of data named line, whose content is a sequence from 1 to 4 (i.e. 1, 2, 3, 4).
# text = text: The text here is a variable that contains some text data.  The code assumes that a variable named text has been previously defined.
(text_df <- tibble(line = 1:4, text = text))

# • Tokenize by words
# unnest_tokens(tbl, output, input, ...)
# unnest_tokens(output = word, input = text): Split the text in the text column into
# words and store these words in the new word column.
tidy_text <- text_df %>%
  unnest_tokens(output = word, #new column name
                input = text #column name in df
  ) %>% print(n = 10)
 


# Remove the stopwords from the tibble
# anti_join() is a function in the dplyr package that is used to perform anti-join operations. 
# It returns all rows in the left table that do not have a match in the right table. 
# In other words, anti_join(x, y) will return all rows that are in data frame x but not in data frame y.
?stop_words
head(stop_words)
# Load a specific data set
data(stop_words)
#stop_words
tidy_text <- tidy_text %>% anti_join(stop_words)
tidy_text

# • Tokenize text_df by bigrams
# unnest_tokens:Used to split a column of text in a text data frame into multiple tokens (usually words) 
# and expand these tokens into new rows
text_df %>%
  unnest_tokens(output = word, #new column name
                input = text, #column name in df
                token = "ngrams",
                n = 2
  ) %>% print(n = 4)

# Analysing Jane Austen
# (2) Tidying the text
# • Extract the book data and split by chapter.


# This code uses the austen_books() function to
# extract some of Austen's works from the gutenbergr package and split them into chapters.
# mutate(.data, new_column = expression)
# str_detect is a function in the stringr package that detects whether a string vector contains a specified pattern.
# Its first argument is a vector of strings to detect, and its second argument is a regular expression that matches the pattern in the string.

# [\\divxlc] Matches a Roman numeral character（d、i、v、x、l or c）
# ignore_case = TRUE: Indicates that case matching is ignored, such as Chapter and CHAPTER both of them will be matched.


# ungroup() ungroups books.

class(austen_books())

original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(
           str_detect(text,
                      regex("ˆchapter [\\divxlc]",
                            ignore_case = TRUE)))) %>%
ungroup()

original_books %>% print(n = 60)

# • Create tokens and remove the stop words
tidy_books <- original_books %>%
  unnest_tokens(word, text, token = "words")%>%
  anti_join(stop_words)
tidy_books

# Using the ? get to the count function details 
?unnest_tokens()

# which appear greater than 600 times.
# count the numer of the words
tidy_books %>%
  count(word, sort = TRUE)

# select the values which one are greater than 600, and using ggplot2 to explain.
tidy_books %>%
  count(word, sort = TRUE) %>%
  filter(n > 600) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()


# (3) sentiments
# • Explore the sentimentsdata frame.
sentiments

class(sentiments)
?sentiments

head(sentiments, n = 5)

# • What values are used in the nrc lexicon?
# The NRC emotion dictionary contains various emotion categories, 
# such as "anger", "fear", "joy", etc., as well as positive and negative emotions.
# Use get_sentiments("nrc") to get a data frame of NRC sentiment lexicon
# Use count(sentiment) to count the number of words for each sentiment category.
get_sentiments("nrc") %>% count(sentiment)


# • What values are used in the bing lexicon?
get_sentiments("bing") %>% count(sentiment)

?get_sentiments()

# • What values are used in the AFINN lexicon?
tns <- getNamespace("textdata")
assignInNamespace(x = "printer", value = function(...) 1, ns = tns)
get_sentiments("afinn") %>% count(value)


# (4) Perform a sentiment analysis on Jane Austen’s novels using the bing lexicon.
# • Perform a sentiment analysis
jane_austen_sentiment <- tidy_books %>%
  inner_join(get_sentiments("bing"))

# • Count the number of positive and negative sentiments which occur in groups of 80 lines.
jane_austen_sentiment <- jane_austen_sentiment %>%
  count(book, index = linenumber %/% 80, sentiment)


# Rearrange the data frame so you have one column for positive and one for negative
jane_austen_sentiment <- jane_austen_sentiment %>%
  spread(sentiment, n, fill = 0)

# • Create a new column which computes the difference (positive - negative)
jane_austen_sentiment <- jane_austen_sentiment %>%
  mutate(sentiment = positive - negative)
jane_austen_sentiment %>% print(n = 6)

# • Plot the sentiment in the 6 novels.
ggplot(jane_austen_sentiment, aes(index, sentiment, fill = book)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~book, nrow = 2, scales = "free_x")

# Repeat the above exercise using the AFINN lexicon. Compute the average sentiment in each group
# of 80 lines and plot the results. Compare to the results obtained using the bing lexicon.
jane_austen_sentiment_afinn <- tidy_books %>%
  inner_join(get_sentiments("afinn")) %>%
  group_by(book) %>%
  mutate(index = linenumber %/% 80) %>%
  group_by(book, index) %>%
  summarise(mean_value = mean(value))
# ----------------------------------------------------------------
ggplot(jane_austen_sentiment_afinn, aes(index, mean_value, fill = book)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~book, nrow = 2, scales = "free_x")

      

# (5) Analysing word frequency using word clouds
# • Create a word cloud using all text from the Jane Austen books
tidy_books %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))

# The following code changes the colour palette to blues and greens. Pick a different palette from
# http://colorbrewer2.org/
pal <- brewer.pal(9,"BuGn")
pal <- pal[-(1:4)] #remove light colours
tidy_books %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100, colors = pal,
                 rot.per = 0, fixed.asp = FALSE))


# • Conduct sentiment analysis using the nrc lexicon. Create a word cloud which colour codes words
# based on sentitment.
pal <- brewer.pal(10,"Paired")
tidy_books %>%
  inner_join(get_sentiments("nrc"), by = "word") %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = pal,
                   title.colors=pal, scale = c(4, 0.5),
                   max.words = 100, title.size = 2)



# Twitter
# (6) Analysing twitter data
# • Download the sample twitter data from Blackboard. twitter_data.Rdata
# • Load the file into R. (You’ll need to change the file path)
load("twitter_data_2021.Rdata")

# Notice the new objects beginning with rt_. These objects contain 1000 tweets extracted using the
# following code:
rt_archie <- rtweet::search_tweets(
  "archie sussex", n = 1000, include_rts = FALSE)
rt_don <- rtweet::search_tweets(
  "Donald Trump", n = 1000, include_rts = FALSE)
rt_covid <- rtweet::search_tweets(
  "covid", n = 1000, include_rts = FALSE)
rt_olympics <- rtweet::search_tweets(
  "olympics", n = 1000, include_rts = FALSE)
rt_biden <- rtweet::search_tweets(
  "Joe Biden", n = 1000, include_rts = FALSE)

# Note: to extract the data yourself you will need to follow the steps in the lecture notes.
# • Choose one of the data sets and inspect the data
rt_don

# What does each row of the dataframe represent?
# Each row is a separate tweet.

# • Create a data frame containing the bigrams in the data set.
# • Add custom stop words
# • Remove bigrams containing stop words
# • Create a word cloud of all remaining bigrams
custom_stop_words <- bind_rows(tibble(word = c("t.co", "https"),
                                      lexicon = c("custom")),
                               stop_words)
don_bigrams <- rt_don %>%
  unnest_tokens(bigram, text,
                token = "ngrams", n = 2)
don_bigrams %>%
  count(bigram, sort = TRUE)

# ---------------------------------------
bigrams_separated <- don_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")
bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% custom_stop_words$word) %>%
  filter(!word2 %in% custom_stop_words$word)
# new bigram counts:
bigram_counts <- bigrams_filtered %>%
  count(word1, word2, sort = TRUE)
bigram_counts %>% print(n = 4)
# ------------------------------------------
bigrams_united <- bigrams_filtered %>%
  unite(bigram, word1, word2, sep = " ")
bigrams_united %>%
  count(bigram) %>%
  with(wordcloud(bigram, n, max.words = 100,
                 rot.per = 0, fixed.asp = FALSE))

