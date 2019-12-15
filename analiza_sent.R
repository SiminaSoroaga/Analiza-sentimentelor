install.packages("pacman")
library(pacman)
pacman::p_load(sentimentr, dplyr, magrittr)
#import baza de date
dataset=read.csv("Uber_Ride_Reviews.csv", sep=',')
dataset
#pastram doar variabilele ride_review, ride_rating
dataset=dataset[c(1,2)]
#transformam variabila ride_review din factor in character
dataset$ride_review=as.character(dataset$ride_review)
#folosim algoritmul de analiza a sentimentelor pentru fiecare review
sentiment_rev=sentiment_by(dataset$ride_review)
sentiment_df=data.frame(sentiment_rev)
words=sentiment_df[,2]
sentiment=sentiment_df[,4]
dataset$sentiment=sentiment
dataset$word=words
dataset
