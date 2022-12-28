
#Project Marcos Youtube comments ####

library(tidyverse)
library(readr)

rm(list = ls())


# import raw data

marcos<- read_csv("marcos_youtube_comments.csv")


# data cleaning

marcos_data <- marcos[-1:-10,]
marcos_data <-marcos_data[-2197,]
colnames(marcos_data)[1] <- "Youtube Comments"

# save a new cleaned copy
write.csv(marcos_data, "marcos_data.csv", row.names =  F)

# upload the new data
library(readr)
youtube_comments_marcos <- read_csv("marcos_data.csv")
View(youtube_comments_marcos)

# save a new cleaned copy again
write.csv(youtube_comments_marcos, "clean_marcos_data.csv", row.names =  F)

# upload the new data again: work with this data ####

library(readr)
clean_marcos_data <- read_csv("clean_marcos_data.csv")
View(clean_marcos_data)


# data analysis using topic modelling#####

library(topicmodels)
library(tm)
library(tmap)
library(quanteda)
library(stm)
library(NLP)
library(RColorBrewer)
library(readtext)
library(wordcloud)
library(wordcloud2)
library(ggplot2)
library(lattice)
library(stringr)
library(dplyr) 
library(tidytext)
library(stopwords)

# Run and load Libraries
library(topicmodels)
library(lda)
library(slam)
library(stm)
library(ggplot2)
library(dplyr)
library(tidytext)
# try to make it faster
library(furrr)
plan(multicore)
library(tm) # Framework for text mining
library(tidyverse) # Data preparation and pipes %>%
library(ggplot2) # For plotting word frequencies
library(wordcloud) # Wordclouds!
library(Rtsne)
library(rsvd)
library(geometry)
library(NLP)
library(ldatuning) 


str(clean_marcos_data)

nrow(clean_marcos_data)

#isolate the texts
comments <-clean_marcos_data$`Youtube Comments`
str(comments)

#build a corpus

library(tm)

comments_source <- VectorSource(comments)

#make a volatile corpus
comments_corpus <-VCorpus(comments_source)

#print the corpus
comments_corpus

#print the 15th comment
comments_corpus[[15]]

#print the content of the 15th comment
comments_corpus[[15]][1]


str(comments_corpus[[15]])


removeWords(comments_corpus, new_stops)
#data preprocessing


# Create the custom function that will be used to clean the corpus: clean_coupus
clean_corpus <- function(corpus){
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeWords, stopwords("en"))
  corpus <-tm_map(corpus, removeWords, c("ang", "toni", "marcos", "bbm", "marcoses", "interview", "youre", "yung",
                                         "mga","bongbong", "filipinos","philippines", "president","bong", "will", "hindi", "para", "lang","ferdinand")) #dictionary
  corpus <-tm_map(corpus, removeWords, stopwords('English'))
  return(corpus)
}


# Apply your customized function to the tweet_corp: clean_corp
clean_corp <- clean_corpus(comments_corpus)

# Print out a cleaned up tweet
clean_corp[[227]][1]


# build a document term matrix

# Create the dtm from the corpus: 
comments_dtm <- DocumentTermMatrix(clean_corp)
# Print out tweets_dtm data
comments_dtm


# Convert tweets_dtm to a matrix: comments_m
comments_m <- as.matrix(comments_dtm)
# Print the dimensions of tweets_m
dim(comments_m)


# Review a portion of the matrix
comments_m[148:150, 2587:2590]


# Since the sparsity is so high, i.e. a proportion of cells with 0s/ cells with other values is too large,
# let's remove some of these low frequency terms
comments_dtm_rm_sparse <- removeSparseTerms(comments_dtm, 0.98)
# Print out tweets_dtm data
comments_dtm_rm_sparse


# Convert tweets_dtm to a matrix: tweets_m
comments_m <- as.matrix(comments_dtm_rm_sparse)
# Print the dimensions of tweets_m
dim(comments_m)


# Review a portion of the matrix
comments_m[148:158, 10:22]



#Create word clouds
wordcloud(clean_corp,min.freq = 50, colors = brewer.pal(8,"Dark2"), random.order=F,rot.per=.20)
wordcloud(clean_corp,min.freq = 50, rot.per = .20)

#Finding the most frequent terms
findFreqTerms(comments_dtm, lowfreq = 70)


#structurla topic modelling####
library(topicmodels)
library(tm)

inspect(comments_dtm) # at dtm 


####TF-IDF Test####


# Create the dtm from the corpus: 
comments_dtm_tfidf <- DocumentTermMatrix(clean_corp, control = list(weighting = weightTfIdf))
comments_dtm_tfidf = removeSparseTerms(comments_dtm_tfidf, 0.95)
comments_dtm_tfidf


# Check the document
inspect(comments_dtm_tfidf)

#Rearranged in decreasing order
freq <- data.frame(sort(colSums(as.matrix(comments_dtm_tfidf)), decreasing=TRUE))
View(freq)[1:25] #get the top 25

#Create a dataframe
TFIDF <- data.frame (freq)

colnames(TFIDF)[1] <- "score"
TFIDF$words <-TFIDF
TFIDF$

#Retain only the top 25
TFIDF_hist <-TFIDF[1:25,]
View(TFIDF_hist)


#plot####

marcos_df <- data_frame(Text = clean_marcos_data) # tibble aka neater data frame

head(marcos_df, n = 20)

library(tidytext)
library(ggplot2)


class(marcos_df$Text)
colnames(marcos_df)

marcos_df$Text <-as.character(marcos_df$Text)
class(marcos_df$Text)

marcos_words <- marcos_df  %>% 
  unnest_tokens(output = word, input = Text)

marcos_words <- marcos_words %>%
  anti_join(stop_words) # Remove stop words in peter_words

marcos_wordcounts <- marcos_words %>% count(word, sort = TRUE)

head(marcos_wordcounts)

marcos_wordcounts %>% 
  filter(n > 70) %>% 
  mutate(word = reorder(word, n)) %>% 
  ggplot(aes(word, n)) + 
  geom_col() +
  coord_flip() +
  labs(x = "Word \n", y = "\n Count ", title = "Frequent Words In the Toni Gonzaga Interview with Bongbong Marcos \n") +
  geom_text(aes(label = n), hjust = 1.2, colour = "white", fontface = "bold") +
  theme(plot.title = element_text(hjust = 0.5), 
        axis.title.x = element_text(face="bold", colour="darkblue", size = 12),
        axis.title.y = element_text(face="bold", colour="darkblue", size = 12))




ggplot(TFIDF, aes(x = score, color = score))+
  geom_histogram() + facet_wrap(~score)

#Output data in a Table
write.table(Cleanset_hist, file="ReplicationCodeMergeData.csv", sep=",")
write.table(TFIDF_hist, file="ReplicationCodeMergeData_TFIDF.csv", sep=",")


#Structural topic models####

clean_marcos_data


# Check for NAs - no NAs
sapply(clean_marcos_data, function(x) sum(is.na(x)))

# Overview of original dataset
str(clean_marcos_data)
sapply(clean_marcos_data, typeof) #see the datatypes


# Format and transform columns

clean_marcos_data$comments <- as.character(clean_marcos_data$`Youtube Comments`)

# Double-check format
sapply(clean_marcos_data, typeof)

# Pre-processing within the stm package before we run the topic meodel
# More info at https://search.r-project.org/CRAN/refmans/stm/html/textProcessor.html
# The stm package converts a vector of text and a dataframe of metadata into stm formatted objects 
# using the command textProcessor which calls the package tm for its pre-processing routines.
# * default parameters

processed <- textProcessor(clean_marcos_data$comments, metadata = clean_marcos_data,
                           lowercase = TRUE, #*
                           removestopwords = TRUE, #*
                           removenumbers = TRUE, #*
                           removepunctuation = TRUE, #*
                           stem = TRUE, #*
                           wordLengths = c(3,Inf), #*
                           sparselevel = 1, #*
                           language = "en", #*
                           verbose = TRUE, #*
                           onlycharacter = TRUE, # not def
                           striphtml = FALSE, #*
                           customstopwords = c("ang", "toni", "marcos", "bbm", "marcoses", "interview", "youre", "yung",
                           "mga","bongbong", "filipinos", "philippines", "president", "bong", "will", "hindi", "para", "lang","ferdinand"), #*
                           v1 = FALSE) #*

# The processed object is a list of four objects: documents, vocab, meta, and docs.removed. The documents 
# object is a list, one per document, of 2 row matrices; the first row indicates the index of a word found 
# in the document, and the second row indicates the (nonzero) counts. If preprocessing causes any documents 
# to be empty, they are removed, as are the corresponding rows of the meta object.

# filter out terms that don’t appear in more than 10 documents,
out <- prepDocuments(processed$documents, processed$vocab, processed$meta, lower.thresh=10)

docs <- out$documents
vocab <- out$vocab
meta <-out$meta

docs

# Check levels
levels(meta$comments)


# Run initial topic model at 15 topics and see how long it takes
# Run time: 2 seconds on i7 CPU (12 cores)
set.seed(831)
system.time({
  First_STM <- stm(docs, vocab, 15,
                   data = meta,
                   seed = 15, max.em.its = 5
  )
})

# Plot first Topic Model ####
plot(First_STM)



# Plot second Topic Model ####

# Run second topic model at 18 topics and 75 iterations and see how long it takes
# Run time: 19 seconds on i7 CPU (12 cores)
set.seed(832)
system.time({
  Second_STM <- stm(documents = out$documents, vocab = out$vocab,
                    K = 18,
                    max.em.its = 75, data = out$meta,
                    init.type = "Spectral", verbose = FALSE
  )
})

# Plot second Topic Model
plot(Second_STM)



# Choosing a value for k (FYI: This takes a long time to run! It takes 30 minutes!)
# Guideline: The held-out likelihood is highest and the residuals are lowest

# Find k: Approach 1 
# Run time: 23 minutes on i7 CPU (12 cores)
# 17 Topics
set.seed(833)
system.time({
  findingk <- searchK(out$documents, out$vocab, K = c(10:30), data = meta, verbose=FALSE
  )
})

# Plot
plot(findingk)


# Find k: Approach 2
# Run time: 5 minutes on i7 CPU (12 cores)
# 20 Topics
set.seed(834)
system.time({
  findingk_ver2 <- searchK(documents = out$documents, 
                           vocab = out$vocab,
                           K = c(10,20,30,40,50,60, 70), #specify K to try
                           N = 500, # matches 10% default
                           proportion = 0.5, # default
                           heldout.seed = 1234, # optional
                           M = 10, # default
                           cores = 1, # default=1
                           max.em.its = 75, #was 75
                           data = meta,
                           init.type = "Spectral",
                           verbose=TRUE
  )
})

# Plot
plot(findingk_ver2)




# Find k: Approach 3
# Run time: 28 seconds on i7 CPU (12 cores)
# 27 Topics
set.seed(835)
system.time({
  findingk_ver3.lee_mimno <- stm(documents = out$documents, 
                                 vocab = out$vocab,
                                 K = 0, # K=0 instructs STM to run Lee-Mimno
                                 seed = 1234, # randomness now, seed matters
                                 max.em.its = 75,
                                 data = meta,
                                 init.type = "Spectral",
                                 verbose=TRUE
  )
})

# Plot
plot(findingk_ver3.lee_mimno)



# Run final topic model at 20 topics and see how long it takes
# Run time: 21 seconds on i7 CPU (12 cores)
set.seed(836)
system.time({
  Third_STM <- stm(documents = out$documents, vocab = out$vocab,
                   K = 20, 
                   max.em.its = 75, data = out$meta,
                   init.type = "Spectral", verbose = FALSE
  )
})

#Plot
plot(Third_STM)


# Let’s see what our model came up with! The following tools can be used to evaluate the model:
# labelTopics gives the top words for each topic.
# findThoughts gives the top documents for each topic (the documents with the highest proportion of each topic).


# Top Words
labelTopics(Third_STM)

# We can find the top documents associated with a topic with the findThoughts function:
# top 2 paragraps for Topic #1 to 10
findThoughts(Third_STM, texts = meta$comments,n = 2, topics = 1:10)

# We can look at multiple, or all, topics this way as well. For this we’ll just look at the shorttext.
# top 3 paragraps for Topic #1 to 15
findThoughts(Third_STM, texts = meta$comments,n = 3, topics = 1:15)


# Graphical display of topic correlations
topic_correlation<-topicCorr(Third_STM)
plot(topic_correlation)


# Graphical display of convergence
plot(Third_STM$convergence$bound, type = "l",
     ylab = "Approximate Objective",
     main = "Convergence")



# Wordcloud:topic 17 with word distribution
set.seed(837)
cloud(Third_STM, topic=17, scale=c(10,2))


# Working with meta-data 
# Change topics # from 1:10 or larger
set.seed(837)
predict_topics<-estimateEffect(formula = 1:10 ~ comments, 
                               stmobj = Third_STM, 
                               metadata = out$meta, 
                               uncertainty = "Global",
                               prior = 1e-5) # Adding a small prior 1e-5 for numerical stability.

# Effect of Zacks vs . Seeking Alpha publishers
set.seed(837)
plot(predict_topics, covariate = "publisher", topics = c(1,4,10),
     model = Third_STM, method = "difference",
     cov.value1 = "Zacks", cov.value2 = "Seeking Alpha",
     xlab = "More Seeking Alpha ... More Zacks",
     main = "Effect of Zacks vs. Seeking Alpha",
     xlim = c(-.1, .1), labeltype = "custom",
     custom.labels = c('Topic 1','Topic 4','Topic 10'))


# Effect of 'TalkMarkets' vs. 'Investopedia' publishers
set.seed(837)
plot(predict_topics, covariate = "publisher", topics = c(1,4,10),
     model = Third_STM, method = "difference",
     cov.value1 = "TalkMarkets", cov.value2 = "Investopedia",
     xlab = "More Investopedia ... More TalkMarkets",
     main = "Effect of TalkMarkets vs. Investopedia",
     xlim = c(-.1, .1), labeltype = "custom",
     custom.labels = c('Topic 1','Topic 4','Topic 10'))



# We can use plot() and type = perspectives to compare two topics or a single topic across 
# two covariate levels to see how the terms differ. 
# We use set.seed() to make the output reproducible. Comparing the content in two topics
set.seed(831)
plot(Third_STM, 
     type="perspectives", 
     topics=c(17,12), 
     plabels = c("Topic 17","Topic 12"))


# Topic proportions within documents for 9 topics 
plot(Third_STM, type = "hist", topics = sample(1:20, size = 9))
plot(Third_STM, type="hist")


# The topicQuality() function plots these values and labels each with its topic number:
topicQuality(model=Third_STM, documents=docs)


# This code is free to use for academic purposes only, provided that a proper reference is cited. 
# This code comes without technical support of any kind. 
# Under no circumstances will the author be held responsible for any use of this code in any way.

