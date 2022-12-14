#-------------------------------------------------------------------------------
#                        Individual Project 1
#-------------------------------------------------------------------------------


install.packages("tm")
install.packages("tidytext")
install.packages("plotly")
install.packages("wordcloud")
install.packages("RColorBrewer")
install.packages("dplyr")
install.packages("wordcloud2")
install.packages("syuzhet")
install.packages("magrittr")
install.packages("stringr")
install.packages("twitteR")

library(syuzhet)
library(wordcloud)
library(plotly)
library(tm)
library(tidytext)
library(dplyr)
library(RColorBrewer)
library(ggplot2)
library(magrittr)
library(stringr)
library(twitteR)


# KEYS & TOKENS.
CONSUMER_KEY <- "AVkKX52SdvJHVkL8FKkiWx1Zl"
CONSUMER_SECRET <- "rX4kXD8LJbeNa8p19MCQvEIjhNXLa5gyBBeAhorC3C2dCpgh1Y"
ACCESS_TOKEN <-  "1595206858142121986-NZNHhytlvCoFo7eAFlNomofNthZLFk"
ACCESS_SECRET <-  "K7qSpHI15utrwDkoI3OwOHHg6IlwKT5RO0QQXwgvhcdIu"

setup_twitter_oauth(consumer_key = CONSUMER_KEY,
                 consumer_secret = CONSUMER_SECRET,
                 access_token = ACCESS_TOKEN,
                 access_secret = ACCESS_SECRET)


# EXTRACTING TWEETS.
trendtwitts <- searchTwitter("#Pokemon -filter:retweets", n=10000, 
              lang="en", since="2022-11-22", until="2022-11-29", 
              retryOnRateLimit = 120)
trendtwitts


# CONVERTING LIST DATA TO DATA FRAME.
trendtwittsDF <- twListToDF(trendtwitts)
class(trendtwittsDF)
names(trendtwittsDF)
View(trendtwittsDF)
head(trendtwittsDF)[1:5]
head(trendtwittsDF$text)[1:5]


# SAVE DATA FRAME FILE.
save(trendtwittsDF,file = "trendingTweetsDF.Rdata")


# LOAD DATA FRAME FILE.
load(file = "trendingTweetsDF.Rdata")


# SAVING FILE AS RDATA.
save(trendtwittsDF, file = "tweetsDF2.Rdata")


# CHECKING FOR MISSING VALUES IN A DATA FRAME.
sapp <- sapply(trendtwittsDF, function(x) sum(is.na(x)))
sapp


# SUBSETTING USING THE dplyr() PACKAGE.
twittsDF <- trendtwittsDF %>%
  select(screenName,text,created,statusSource)
twittsDF


# GROUPING THE DATA CREATED. 
twittsDF %>%  
  group_by(1) %>%  
  summarise(max = max(created), min = min(created))

mutation <- twittsDF %>%  mutate(Created_At_Round = created %>% 
                                 round(units = 'hours') %>% as.POSIXct())
mutation

twittsDF %>% pull(created) %>% min() 
twittsDF %>% pull(created) %>% max()


# Plot on tweets by time using the library(plotly) and ggplot().
plot <- mutation %>% 
  dplyr::count(Created_At_Round) %>% 
  ggplot(mapping = aes(x = Created_At_Round, y = n)) +
  theme_light() +
  geom_line() +
  xlab(label = 'Date') +
  ylab(label = NULL) +
  ggtitle(label = 'Number of Tweets per Hour')

plot %>% ggplotly()


# GGPLOT.
ggplot(data = twittsDF, aes(x = created)) +
  geom_histogram(aes(fill = ..count..)) +
  theme(legend.position = "right") +
  xlab("Time") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "midnightblue", high = "aquamarine4")

# PLOTTING STATUS SOURCE.
encodesource <- function(x) {
  if(grepl(">Twitter for iPhone</a>", x)){
    "iphone"
  }else if(grepl(">Twitter for iPad</a>", x)){
    "ipad"
  }else if(grepl(">Twitter for Android</a>", x)){
    "android"
  } else if(grepl(">Twitter Web Client</a>", x)){
    "Web"
  } else if(grepl(">Twitter for Windows Phone</a>", x)){
    "windows phone"
  }else if(grepl(">dlvr.it</a>", x)){
    "dlvr.it"
  }else if(grepl(">IFTTT</a>", x)){
    "ifttt"
  }else if(grepl(">Facebook</a>", x)){  #This looks unreliable...
    "facebook"
  }else {
    "others"
  }
}


twittsDF$tweetsource = sapply(twittsDF$statusSource, 
                              encodesource)

tweet_appSource1 <- twittsDF %>% 
  select(tweetsource) %>%
  group_by(tweetsource) %>%
  summarize(count=n()) %>%
  arrange(desc(count))

ggplot(twittsDF[twittsDF$tweetsource != 'others',], aes(tweetsource, 
  fill = tweetsource)) + geom_bar() +
  theme(legend.position="none",
        axis.title.x = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  ylab("Number of tweets") +
  ggtitle("Tweets by Source")

# ACCOUNTS WHICH TWEET ABOUT ELON MUSK.
tweet_appScreen1 <- twittsDF %>%
  select(screenName) %>%
  group_by(screenName) %>%
  summarize(count=n()) %>%
  arrange(desc(count)) 


#convert to Corpus

#using ScreenName
corpusNames <- Corpus(VectorSource(twittsDF$screenName))  
class(twittsDF$screenName)

cls_data1 <- class(VectorSource(twittsDF$screenName))
cls_data1

str(corpusNames)

class(corpusNames)

nms <- corpusNames
nms

# WORDCLOUD FOR SCREEN_NAMES.
pal11 <- brewer.pal(8, "Dark2")
pal21 <- pal11[-(1:4)]
set.seed(123)

par(mar = c(0,0,0,0), mfrow = c(1,1))

wordcloud(words = corpusNames, scale=c(3,0.5),
          max.words=10000,
          random.order=FALSE,
          rot.per=0.5,
          use.r.layout=TRUE,
          colors=pal11)

