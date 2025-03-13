library(tidyverse)
#install.packages("tidytext")
#install.packages("janeaustenr")
#install.packages("textdata")
#install.packages("wordcloud")
#install.packages("reshape2")
#install.packages("rtweet")
library(tidytext)
library(janeaustenr)
library(textdata)
library(wordcloud)
library(reshape2)
library(rtweet)

text <- c("Because I could not stop for Death -",
          "He kindly stopped for me -",
          "The Carriage held but just Ourselves -",
          "and Immortality")
text

text_df <- tibble(line = 1:4,
                  text = text)
text_df

text_df %>%
  unnest_tokens(output = word, #new column name
                input = text #column name in df
  ) %>%
  print(n = 4)

janeaustenr::prideprejudice %>% head(12)

original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(
           str_detect(text,
                      regex("^chapter [\\divxlc]",
                            ignore_case = TRUE)))) %>%
  ungroup()
original_books %>% print(n = 6)


tidy_books <- original_books %>%
  unnest_tokens(word, text, token = "words")
tidy_books

data(stop_words)
stop_words

tidy_books <- tidy_books %>%
  anti_join(stop_words)

tidy_books %>%
  count(word, sort = TRUE)

g <- tidy_books %>%
  count(word, sort = TRUE) %>%
  filter(n > 600) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()
g

get_sentiments("afinn") #-5 to +5
get_sentiments("nrc") # joy, fear etc
get_sentiments("bing") #positive, negative

sentiments


tns <- getNamespace("textdata")
assignInNamespace(x = "printer", value = function(...) 1, ns = tns)
nrc_joy <- get_sentiments("nrc") %>%
  filter(sentiment == "joy")
nrc_joy


tidy_books %>%
  filter(book == "Emma") %>%
  inner_join(nrc_joy) %>%
  count(word, sort = TRUE) %>%
  print(n = 6)

jane_austen_sentiment <- tidy_books %>%
  inner_join(get_sentiments("bing")) %>%
  count(book, index = linenumber %/% 80, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative)
jane_austen_sentiment %>% print(n = 6)

g <- ggplot(jane_austen_sentiment, aes(index, sentiment, fill = book)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~book, nrow = 2, scales = "free_x")
g

n_lines <- 80
original_books %>%
  filter(book == "Pride & Prejudice",
         between(linenumber, n_lines*80, n_lines*90 )) %>%
  print(n=10)


bing_word_counts <- tidy_books %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()
bing_word_counts %>% print(n=8)


g <- bing_word_counts %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(y = "Contribution to sentiment",
       x = NULL) +
  coord_flip()

g


custom_stop_words <- bind_rows(tibble(word = c("miss"),
                                      lexicon = c("custom")),
                               stop_words)
custom_stop_words

tidy_books %>%
  anti_join(custom_stop_words)

tidy_books %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))

pal <- brewer.pal(9,"BuGn")
pal <- pal[-(1:4)] #remove light colours
tidy_books %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100, colors = pal,
                 rot.per = 0, fixed.asp = FALSE))

tidy_books %>%
  inner_join(get_sentiments("bing"), by = "word") %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("darkred", "darkgreen"),
                   title.colors=c("darkred", "darkgreen"),
                   max.words = 100, title.size = 2)


austen_bigrams <- austen_books() %>%
  unnest_tokens(bigram, text,
                token = "ngrams", n = 2) %>%
  filter(!is.na(bigram)) # remove NAs
austen_bigrams

austen_bigrams %>%
  count(bigram, sort = TRUE)

bigrams_separated <- austen_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")
bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)
# new bigram counts:
bigram_counts <- bigrams_filtered %>%
  count(word1, word2, sort = TRUE)
bigram_counts %>% print(n = 4)

bigrams_united <- bigrams_filtered %>%
  unite(bigram, word1, word2, sep = " ")
bigrams_united %>%
  count(bigram) %>%
  with(wordcloud(bigram, n, max.words = 100,
                 rot.per = 0, fixed.asp = FALSE))


#--------------Twitter Data
load("twitter_data_2021.Rdata")
rt_archie_vs_don <- bind_rows(list(archie = rt_archie,
                                   don = rt_don), .id = "id")

(tidy_tweets <- rt_archie_vs_don %>%
    unnest_tokens(word, text, token = "words") %>%
    anti_join(custom_stop_words, by = "word") %>%
    select(word, id) %>%
    mutate(word = str_replace_all(word, "[^a-z0-9]", "")) %>%
    select(word, id))

tweet_sentiment <- tidy_tweets %>%
  inner_join(get_sentiments("nrc"), by = "word")
tweet_sentiment

(tweet_sentiment_summary <- tweet_sentiment %>%
    count(id, sentiment))

g <- ggplot(tweet_sentiment_summary) +
  geom_col(mapping = aes(x = sentiment,
                         y = n,
                         fill = sentiment)) +
  facet_wrap(~id) +
  coord_flip() +
  theme(legend.position = "none")
g

g <- ggplot(tweet_sentiment) +
  geom_bar(mapping = aes(x = sentiment,
                         y = ..prop.., group = 1
  ),
  stat="count") +
  facet_wrap(~id) +
  coord_flip()
g

pal <- brewer.pal(4,"Dark2")
tidy_tweets %>%
  inner_join(get_sentiments("bing"), by = "word") %>%
  count(word, sentiment, id, sort = TRUE) %>%
  acast(word ~ sentiment + id, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = pal, title.colors=pal, title.size=2)
