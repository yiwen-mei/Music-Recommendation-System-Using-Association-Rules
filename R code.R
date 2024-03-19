# Recommendation System
# a) Data Prepocessing
library(arules) 
df = read.csv("music.csv", stringsAsFactors=T)
str(df)
df$customer <- factor(df$customer)
head(df, 19)
df = df[, -c(3, 4)]
original = dim(df)[1]
# remove all rows with unknown artists name from df
df = df[df$artist != "[unknown]",]
new = dim(df)[1]
original - new
# There are 553 songs from unknown artists are in the dataset.

# b) Convert the dataframe into a transactions dataset
# create a list of users (each with the songs of their preference)
playlist = split(df$artist,f=df$customer)
# see first user's songs
playlist[[1]]
# see first two users' songs
playlist[1:2]
# remove song duplicates, if any
playlist = lapply(playlist,unique)
# convert the list of users to transactions object
df.trans <- as(playlist,"transactions")
inspect(head(df.trans,2))
length(playlist[[1]])
length(playlist[[2]])
# The first transaction includes 16 artists.
# The second transaction includes 29 artists.

# c)
# display barplot showing all artists downloaded by more than 8% of the customers (support at least 0.08)
itemFrequencyPlot(df.trans,support=.08,cex.names=1.5)
# radiohead is the most popular artist.

# d)
list1 = list(supp=0.01, conf=0.5,target="rules")
rules1 <- apriori(playlist, parameter=list1)
rules_sorted = sort(rules1, by = "lift")
inspect(rules_sorted)
# I would suggest radiohead to a customer who listened to the beattles and the smashing punmpkins.

# e)
rules_sorted_new = sort(subset(rules1, lift > 5), by = "confidence")
inspect(rules_sorted_new)
# I would suggest iron maiden to a customer who listened to judas priest.