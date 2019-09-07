# Mengambil Trend data Twitter
# Import Library

library(rtweet)
library(compare)
#token twitter
#masukan token terlebih dahulu untuk memjalankan

token <- create_token(
  consumer_key = "XXXXXCuXxQaVILbGJ1kGrPtUU",
  consumer_secret = "XXXXXjhOrw8bl6qxKf6IUIMIeQ8Rq9MFvdt2HuWudaj2R3bewX",
  access_token = "XXXXXXXX-Z8rSTs6cfr5J6PCV2XXDicA2KNpAFbJQbUNgIOxZl",
  access_secret = "XXXXXD1J0MnpcPpoUJeyVjP8GZjHV8wjc5mUnBHtBfbqz")

#mengambil WOEID (Where on Earth ID Yahoo) dari available trend
woeid<-trends_available(token = NULL, parse = TRUE)

#Mencari WOEID Indonesia
woeid_indo<-woeid[woeid$name == 'Indonesia',"woeid"]
woeid_indo

#Menampilkan trend yang ada di indonesia
trends <- get_trends(woeid=woeid_indo[[1]])
df_trends<-trends[c('trend','created_at')]
df_trends

# Membuat penyimpan trends
#write.csv(df_trends,file = 'data_trend.csv')

#Membaca data trend sebelumnya
read_data<-read.csv(file = 'data_trend.csv',stringsAsFactors = FALSE)

#menggabungkan data baru dengan data lama
df_trend_union<- merge(df_trends,read_data[2:3],all = TRUE)
head(df_trend_union)

#menyimpan data gabungan ke file
write.csv(df_trend_union,file = 'data_trend.csv')
