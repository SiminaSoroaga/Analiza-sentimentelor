#citirea bazei de date
uber=read.csv("uber.csv")
str(uber)
head(uber)

#construirea corpusului
install.packages("tm")
library(tm)
#CREAREA CORPUSUI
corpus<-iconv(uber$ride_review, "UTF-8","ASCII")
corpus<-Corpus(VectorSource(corpus))
inspect(corpus[1:5])
#CURATAREA DATELOR
corpus<-tm_map(corpus,stripWhitespace)
inspect(corpus[1:5])
corpus<-tm_map(corpus,tolower)
inspect(corpus[1:5])
corpus<-tm_map(corpus,removePunctuation)
corpus<-tm_map(corpus,removeNumbers)
cleanset<-tm_map(corpus,removeWords,stopwords('english'))
#inspect(cleanset[1:5])
cleanset<-tm_map(cleanset,stripWhitespace)


#eliminam cuvantul "uber" din corpus, obervam ca este cel mai frecvent
cleanset<-tm_map(cleanset, removeWords,c("uber"))

#inlocuim cuv drivers,driver, driving cu drive
cleanset<-tm_map(cleanset,gsub,
                 pattern='driving',
                 replacement='drive')
cleanset<-tm_map(cleanset,gsub,
                 pattern='driver',
                 replacement='drive')
cleanset<-tm_map(cleanset,gsub,
                 pattern='drives',
                 replacement='drive')
#called->call
cleanset<-tm_map(cleanset,gsub,
                 pattern='called',
                 replacement='call')
#times->time
cleanset<-tm_map(cleanset,gsub,
                 pattern='times',
                 replacement='time')
#charges->charge
cleanset<-tm_map(cleanset,gsub,
                 pattern='charges',
                 replacement='charge')
#charged->charge
cleanset<-tm_map(cleanset,gsub,
                 pattern='charged',
                 replacement='charge')
#using->use
#used->use
cleanset<-tm_map(cleanset,gsub,
                 pattern='used',
                 replacement='use')
cleanset<-tm_map(cleanset,gsub,
                 pattern='using',
                 replacement='use')

#took=>take
cleanset<-tm_map(cleanset,gsub,
                 pattern='took',
                 replacement='take')
#construim matricea termenilor
tdm=TermDocumentMatrix(cleanset)
tdm
tdm=as.matrix(tdm)
tdm[1:10,1:10]

#barplot
w<-rowSums(tdm)
w<-subset(w,w>=100)
barplot(w,las=2,col=rainbow(50))

#analiza sentimentelor
#install.packages("syuzhet")
library(syuzhet)
#install.packages("lubridate")
library(lubridate)
#install.packages("ggplot2")
library(ggplot2)
#install.packages("scales")
#install.packages("reshape2")
#install.packages("dplyr")
library(scales)
library(reshape2)
library(dplyr)

review<-read.csv("uber.csv")
t<-iconv(review$ride_review,"UTF-8","ASCII")
#obtinem scorul sentimentului

head(sentiment)
#sentiment=get_sentiment(t, method = "syuzhet", path_to_tagger = NULL,
             # cl = NULL, language = "english", lexicon = NULL)


sentiment=get_nrc_sentiment(t,language = "english")
head(sentiment)
#salvam scorurile intr-un data.frame
sentiment_rev<-dplyr::bind_cols(review,data.frame(sentiment))
str(sentiment_rev)
head(sentiment_rev)

#scorul sentimentului
#install.packages("pacman")
library(pacman)
pacman::p_load(sentimentr, dplyr, magrittr)
sent=sentiment_by(as.character(uber$ride_review))
sentiment_df=data.frame(sent)
words=sentiment_df[,2]
score_sent=sentiment_df[,4]
#salvam nr de cuv si scorul in baza de date
sentiment_rev["no_words"]=words
sentiment_rev["sent_score"]=score_sent
str(sentiment_rev)

head(sentiment_rev)
sentiment_rev["final_sent"]=ifelse(sentiment_rev["sent_score"]>0,1,-1)

#ANALIZA STATISTICA -1. Regresie liniara
model=lm(final_sent~ride_rating+anger+anticipation+disgust+fear+joy+sadness+surprise+trust+no_words+negative+sent_score, data=sentiment_rev)
summary(model)

#multiple R-squared=0.62 adica 62% din varianta variabilei final_sent este explicata de varianta variabilelor independente
#testam puterea de pezicere a modelului si acuratetea
pred <- predict(model, newdata = sentiment_rev, type = "response")
y_pred_num <- ifelse(pred > 0, 1, -1)
y_pred <- factor(y_pred_num)
y_act <- sentiment_rev$final_sent
mean(y_pred == y_act) #acuratete de 97%
#confusion matrix
table(y_act,y_pred)

#328 de cazuri u fost prezise corect cu -1, si 409 cu 1, 6 cazuri au fost prezise 1, dar erau -1, si 17 au fost prezise -1, dar erau 1


#ANALIZA STATISTICA -2. RETELE NEURONALE
attach(sentiment_rev)
final_sent=as.numeric(final_sent)
ride_rating=as.numeric(ride_rating)
anger=as.numeric(anger)
anticipation=as.numeric(anticipation)
disgust=as.numeric(disgust)
fear=as.numeric(fear)
joy=as.numeric(joy)
sadness=as.numeric(sadness)
surprise=as.numeric(surprise)
trust=as.numeric(trust)
no_words=as.numeric(no_words)
negative=as.numeric(negative)
positive=as.numeric(positive)
sent_score=as.numeric(sent_score)
library(neuralnet)
library(nnet)
library(plyr)
sentiment_rev=sentiment_rev[-c(1,2)]
f<-final_sent~ride_rating+anger+anticipation+disgust+fear+joy+sadness+surprise+trust+no_words+negative+positive+sent_score
set.seed(1)
n=nrow(sentiment_rev)
train<-sample(1:n, 500, FALSE)
fit<-neuralnet(f,data=sentiment_rev[train,],hidden = 1,algorithm = "rprop+",
               err.fct = "sse",act.fct = "logistic",linear.output = FALSE)
#print(fit)
plot(fit, intercept = FALSE,show.weights = FALSE)
#attributes(fit)

#fit$result.matrix
plot(fit, intercept = TRUE, show.weights=TRUE)

#previziuni pe baza retelei
pred<-compute(fit, sentiment_rev[-train,1:13])
head(pred$net.result,5)
#valorile sunt probabilitati si pot fi transformate in valori binare 
r2<-ifelse(pred$net.result<=0, -1,1)
head(r2, 5)
#rata erorii
dim(r2)
error_rate=(1-sum(sign(r2)==sign(sentiment_rev[-train,14])/260))
round(error_rate,3)
table(sign(r2), sign(sentiment_rev[-train,14]), dnn=c("Predicted","Observed"))





