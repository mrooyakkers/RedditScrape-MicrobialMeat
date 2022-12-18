# Reddit Scrape + Analysis 

# Import Data + Sentiment Database
rm(list=ls())
setwd("~/Desktop/Portfolio/RedditScrape")
reddit_df <- read.csv("~/Desktop/Portfolio/RedditScrape/reddit_data.csv", sep=";")
reddit_df <- reddit_df[ , 2:ncol(reddit_df)]
nrc_list <- read.csv("~/Desktop/Portfolio/RedditScrape/nrc_list.csv", sep=";")

# The reddit links where the data came from -- for reference.
links <- c("https://www.reddit.com/r/wheresthebeef/comments/xjmt3x/what_types_of_meat_do_you_want_designed/", 
           "https://www.reddit.com/r/wheresthebeef/comments/mqrxbq/new_subscribers_introduce_yourself_here/",
           "https://www.reddit.com/r/wheresthebeef/comments/y1iuaf/most_vegans_support_labgrown_meat_but_wont_eat_it/",
           "https://www.reddit.com/r/technology/comments/y6lt69/redefine_meat_strikes_partnership_to_boost/", 
           "https://www.reddit.com/r/IAmA/comments/qc51s7/we_are_new_harvest_the_cellular_agriculture/",
           "https://www.reddit.com/r/vegan/comments/x491ku/do_you_consider_beyond_or_impossible_meats_as/",
           "https://www.reddit.com/r/vegan/comments/p32vf8/is_anyone_else_not_going_to_be_eaten_so_called/",
           "https://www.reddit.com/r/collapse/comments/s1nwxm/air_protein_and_microbegrown_food_should_be/",
           "https://www.reddit.com/r/collapse/comments/v2mgho/replacing_some_meat_with_microbial_protein_could/",
           "https://www.reddit.com/r/science/comments/ui8z8z/swapping_20_of_beef_for_microbial_protein_like/ ",
           "https://www.reddit.com/r/Futurology/comments/uke9fv/a_californian_company_is_selling_real_dairy/")

colNames(reddit_df) <- links 


## Part 1: Sentiment + emotion scores for each comment.
# Apply sentiment classification for each comment 
library(dplyr)
reddit_lat <- as.data.frame(matrix(nrow=0, ncol=2))

# Rework reddit_df laterally 
for (i in 1:length(links)) {
  cur <- reddit_df[ , i] 
  cur <- cur[!is.na(cur)]
  Title <- rep(links[i], length(cur))
  temp_df <- data.frame(cbind(Title, cur))
  reddit_lat <- data.frame(rbind(reddit_lat, temp_df))
}

# Vectors for negativity/positivity score 
Negative <- rep(NA, nrow(reddit_lat))
Positive <- rep(NA, nrow(reddit_lat))
reddit_lat <- data.frame(cbind(reddit_lat, Negative, Positive))

library(stringr)
# Function that cleans the comment of punctuation 
sentance_clean <- function(sentence) {
  sentence = gsub('https://','',sentence)
  sentence = gsub('http://','',sentence)
  sentence = gsub('[^[:graph:]]', ' ',sentence)
  sentence = gsub('[[:punct:]]', '', sentence)
  sentence = gsub('[[:cntrl:]]', '', sentence)
  sentence = gsub('\\d+', '', sentence)
  sentence = str_replace_all(sentence,"[^[:graph:]]", " ")
  # and convert to lower case:
  sentence = tolower(sentence)
  # split into words. str_split is in the stringr package
  word.list = str_split(sentence, '\\s+')
  # sometimes a list() is one level of hierarchy too much
  words = unlist(word.list)
  return(words)
}

# Count the number of positive and negative words in each comment 
for (i in 1:nrow(reddit_lat)) {
  cur_comment <- reddit_lat$cur[i] %>% str_replace("/n", " ")
  cur_comment <- cur_comment %>% sentance_clean()
  sentiment_score_vector <- NULL
  unique_nrc_list <- unique(nrc_list$sentiment)
  for (j in 1:length(unique_nrc_list)) {
    sentiment1 <- unique_nrc_list[j]
    sentiment_list1 <- nrc_list$word[nrc_list$sentiment == sentiment1]
    sentiment_score <- sum(!is.na(pmatch(sentiment_list1, cur_comment)))
    sentiment_score_vector <- c(sentiment_score_vector, sentiment_score)
  }
  reddit_lat[i , 3] <- sentiment_score_vector[3]
  reddit_lat[i , 4] <- sentiment_score_vector[7]
}

# Count the number of emotional words in each comment 
names <- c("links", "comment", unique_nrc_list)
reddit_lat2 <- as.data.frame(matrix(nrow = 316, ncol = length(names)))
colnames(reddit_lat2) <- names
reddit_lat2$links <- reddit_lat$Title
reddit_lat2$comment <- reddit_lat$cur
#
for (i in 1:nrow(reddit_lat2)) {
  cur_comment <- reddit_lat2$comment[i] %>% str_replace("/n", " ")
  cur_comment <- cur_comment %>% sentance_clean()
  sentiment_score_vector <- NULL
  unique_nrc_list <- unique(nrc_list$sentiment)
  for (j in 1:length(unique_nrc_list)) {
    sentiment1 <- unique_nrc_list[j]
    sentiment_list1 <- nrc_list$word[nrc_list$sentiment == sentiment1]
    sentiment_score <- sum(!is.na(pmatch(sentiment_list1, cur_comment)))
    sentiment_score_vector <- c(sentiment_score_vector, sentiment_score)
  }
  reddit_lat2[i , 3] <- sentiment_score_vector[1]
  reddit_lat2[i , 4] <- sentiment_score_vector[2]
  reddit_lat2[i , 5] <- sentiment_score_vector[3]
  reddit_lat2[i , 6] <- sentiment_score_vector[4]
  reddit_lat2[i , 7] <- sentiment_score_vector[5]
  reddit_lat2[i , 8] <- sentiment_score_vector[6]
  reddit_lat2[i , 9] <- sentiment_score_vector[7]
  reddit_lat2[i , 10] <- sentiment_score_vector[8]
  reddit_lat2[i , 11] <- sentiment_score_vector[9]
  reddit_lat2[i , 12] <- sentiment_score_vector[10]
}

## Make the score relative to the length of the comment
for (i in 1:nrow(reddit_lat2)) {
  cur_numbers <- reddit_lat2[i, seq(3,12,1)]/nchar(reddit_lat2$comment)*1000 %>% as.integer()
  reddit_lat2[i, seq(3,12,1)] <- lapply(cur_numbers, as.integer)
}
# Save the final df for backup
write.csv2(reddit_lat2, "reddit_lat2.csv")


## Part 2 is understanding what each reddit thread is talking about
# Function that turns the text base into a word list + count 
word_counter <- function(collapsed_timeline) {
  sentence <- collapsed_timeline
  sentence %<>%
    gsub('https://','', .) %>%  
    gsub('http://','', .) %>% 
    gsub('[^[:graph:]]', ' ', .) %>% 
    gsub('[[:punct:]]', ' ', .) %>% 
    gsub('[[:cntrl:]]', ' ', .) %>% 
    gsub('\\d+', '', .) %>% 
    str_replace_all("[^[:graph:]]", " ") %>% 
    tolower() %>% str_split('\\s+') %>% unlist()
  test <- paste(sentence[nchar(sentence) >= 5], collapse=" ")
  words <- str_split(test, '\\s+') %>% unlist()
  stopwords <- c( "newstatus", stopwords::data_stopwords_smart, 
                  stopwords::stopwords(language = "en")) 
  sentance_cleaned <- words[!words %in% stopwords]
  sentance_cleaned <- unique(sentance_cleaned)
  # bring in the word counter 
  final_word_count <- data.frame(Word = character(), Count = character())
  for (i in 1:length(sentance_cleaned)) {
    current_word <- sentance_cleaned[i]
    total <- length(grep(current_word, words))
    together <- c(current_word, total)
    final_word_count <- rbind(final_word_count, together) 
  }
  # replace headers
  names(final_word_count) <- c("word", "count")
  final_word_count$count <- as.numeric(final_word_count$count)
  final <- final_word_count[order(-final_word_count$count),]
  # remove rows with NA
  final <- head(final, 5)
  final$word
}

# then word counter 
names <- c("links", "words")
reddit_lat3 <- as.data.frame(matrix(nrow = 11, ncol = length(names)))
colnames(reddit_lat3) <- names
reddit_lat3$links <- links

#
for (i in 1:nrow(reddit_lat3)) {
  smaller_df <- reddit_lat[reddit_lat$Title == links[i],] 
  spec_copy <- paste(smaller_df$cur, collapse = " ")
  words <- word_counter(spec_copy) %>% paste0(collapse = ", ")
  reddit_lat3$words[i] <- words
}

# The top words for every link.
write.csv2(reddit_lat3, "wordcounter.csv")


## Part 3: The top comments for different emotions 
top_emotions <- as.data.frame(matrix(nrow = 10, ncol = 10))
top_emotions[ ,1] <- unique_nrc_list
#
# order df by column 
cur_df <- reddit_lat2[order(reddit_lat2$trust, decreasing = TRUE),] 
top_emotions[1,2:10] <- head(cur_df$comment, 9)
#
cur_df <- reddit_lat2[order(reddit_lat2$fear, decreasing = TRUE),] 
top_emotions[2,2:10] <- head(cur_df$comment, 9)
#
cur_df <- reddit_lat2[order(reddit_lat2$negative, decreasing = TRUE),] 
top_emotions[3,2:10] <- head(cur_df$comment, 9)
#
cur_df <- reddit_lat2[order(reddit_lat2$sadness, decreasing = TRUE),] 
top_emotions[4,2:10] <- head(cur_df$comment, 9)
#
cur_df <- reddit_lat2[order(reddit_lat2$anger, decreasing = TRUE),] 
top_emotions[5,2:10] <- head(cur_df$comment, 9)
#
cur_df <- reddit_lat2[order(reddit_lat2$surprise, decreasing = TRUE),] 
top_emotions[6,2:10] <- head(cur_df$comment, 9)
#
cur_df <- reddit_lat2[order(reddit_lat2$positive, decreasing = TRUE),] 
top_emotions[7,2:10] <- head(cur_df$comment, 9)
#
cur_df <- reddit_lat2[order(reddit_lat2$disgust, decreasing = TRUE),] 
top_emotions[8,2:10] <- head(cur_df$comment, 9)
#
cur_df <- reddit_lat2[order(reddit_lat2$joy, decreasing = TRUE),] 
top_emotions[9,2:10] <- head(cur_df$comment, 9)
#
cur_df <- reddit_lat2[order(reddit_lat2$anticipation, decreasing = TRUE),] 
top_emotions[10,2:10] <- head(cur_df$comment, 9)

write.csv2(top_emotions, "topemotions.csv")

# From here, you could just read the top answers based on the emotion or sentiment.

# Also break it down for top word counts associated with every emotion
top_words <- rep(" ", 10)
reddit_lat4 <- data.frame(cbind(top_emotions$V1, top_words))

# then fill in the word counts into reddit_lat4






