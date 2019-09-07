library(rtweet)

token <- create_token(
  consumer_key = "RYYCjCuXxQaVILbGJ1kGrPtUU",
  consumer_secret = "rw7BkjhOrw8bl6qxKf6IUIMIeQ8Rq9MFvdt2HuWudaj2R3bewX",
  access_token = "50967691-Z8rSTs6cfr5J6PCV2XXDicA2KNpAFbJQbUNgIOxZl",
  access_secret = "KLEu0D1J0MnpcPpoUJeyVjP8GZjHV8wjc5mUnBHtBfbqz")

# Step 3: Crawling Data Twitter 

# Define your twitter username 
my_username='ferdeh'

# Setelah proses otentikasi berhasil, kita siap untuk “menambang” data (crawling) dari Twitter. Untuk kepeluan ini, rtweet mengemas berbagai fungsi yang cukup lengkap, di antaranya:
#   
#   search_tweets() : mencari tweet dengan kata kunci tertentu
# lookup_users() : menampilkan data detail dari satu atau lebih user(s)
# get_timelines() : menampilkan status/tweet yang pernah diposting oleh user tertentu aka timeline
# get_followers() : menampilkan list followers dari user tertentu
# get_friends() : menampilkan list fiends/followings atau yang di-follow user tentu
# dan masih banyak yang lain seperti untuk menampilkan retweet, siapa yang me-retweet, mendapatkan list favorite, menampilkan trending topics, cleansing tweet, dan juga ekspor data ke file csv.

# find 1000 tweets with keywords: "kota jakarta"

tweet
trends <- get_trends(woeid=1047378)
trends
trends$trend

fechas <- seq.Date(from = as.Date("2018-09-5"), to = as.Date("2018-09-07"), by =  1)
fechas
df_tweets <- data.frame()




for (i in seq_along(fechas)) {
  df_temp <-  search_tweets("lang:es",
                            geocode = mexico_coord,
                            until= fechas[i],
                            n = 100)
  df_tweets <- rbind(df_tweets, df_temp)
}

summary(df_tweets)

woeid<-trends_available(token = NULL, parse = TRUE)
names(woeid)
woeid_indo<-woeid[woeid$name == 'Indonesia',"woeid"]
woeid_indo


trends <- get_trends(woeid=woeid_indo[[1]])
trends$trend

ferdeh<-get_my_timeline(n = 10, max_id = NULL, parse = TRUE, check = TRUE,token = NULL)
ferdeh$text
tanggal <- as.Date('2019-09-05')
tanggal
trends <- get_trends(woeid=woeid_indo[[1]], until= tanggal )

names(trends)
trend_now<-trends[,c('trend','place','created_at')]
unique(trend_now$created_at)
###

woeid<-trends_available(token = NULL, parse = TRUE)
woeid_indo<-woeid[woeid$name == 'Indonesia',"woeid"]
trends <- get_trends(woeid=woeid_indo[[1]])
names(trends)
nrow(trends)
trends[c('trend','place','created_at')]
trends_top <-trends$trend[45:50]
trends_top
tweet_search<-trends_top[3]
tweet_all <- search_tweets(q =tweet_search,n=10000, include_rts=TRUE)

tweet_ori <- tweet_all[tweet_all$is_retweet==FALSE,]

nrow(tweet_all)
nrow(tweet_ori)
names(tweet_ori)
# Insert freq plot here, include retweets in it
freqplot <- subset(tweet_ori, select = c("created_at", "status_id"))
freqplot
timest <- as.POSIXct(freqplot$created_at)
attributes(timest)$tzone <- "Asia/Jakarta"
timest
brks <- trunc(range(timest), "mins")
hist(timest, freq = TRUE, breaks=seq(brks[1], brks[2]+3600, by="5 min"), main = paste("Pattern of tweets on ", tweet_search), xlab = "Time")

# Extract essential columns: text, created, id, screenName
twi_clean <- subset(twi_ori_df, select = c("text", "created", "id", "screenName"))

# Clean-up the tweet text
twi_clean$text <- gsub("[^[:alnum:][:space:]]*","", twi_clean$text)
twi_clean$text <- gsub("http\\w*","", twi_clean$text)
twi_clean$text <- gsub("\\n"," ", twi_clean$text)
twi_clean$text <- gsub("\\s+", " ", str_trim(twi_clean$text))
twi_clean$text <- tolower(twi_clean$text)

# Create a sorted table of unique tweets w/ count
twfreq <- as.data.frame(table(twi_clean$text)) # create a freq table of duplicates
twfreq <- twfreq[!(twfreq$Var1==""),] # remove blanks
twfreq <- twfreq[order(-twfreq$Freq),] # sort by frequency of duplicates
# print(head(twfreq))

# Calculate tweet uniqueness score
# count unique tweets / count total tweets
# uniqueness score of natural trends is closer to 1
# uniqueness score of fake / forced trends is closer to 0
uniqueness = nrow(twfreq[2])/sum(twfreq[2])

# For verifying manually
# write.csv(twi3, file = "twi3.csv")
# write.csv(twfreq, file = "twfreq.csv")

#print(uniqueness)
print(paste("The uniqueness score is ",uniqueness))






       