# Melakukan Web Scaping dengan menggunakan R pada web site IMDB
## import library
library('rvest')
library('stringr')

## membuat variable url yang mau di scrap
url <- 'http://www.imdb.com/search/title?count=100&release_date=2016,2016&title_type=feature'

## membuat variable yang menyimpan item yang mau di scrap
head <- c('Rank', 'Title','Description','Runtime','Rating','Votes','Gross','Director','Actor','Metascore', 'Genre')

## membuat variable yang menyimpan alamat DOM (Document Object model) dari item yang mau di scrap
item_css <- c('.text-primary','.lister-item-header a','.ratings-bar+ .text-muted','.runtime','.ratings-imdb-rating', '.sort-num_votes-visible span:nth-child(2)','.ghost~ .text-muted+ span','.text-muted+ p a:nth-child(1)','.lister-item-content .ghost+ a','.metascore','.genre' )

## membuat variable yang menyimpan alamat DOM (Document Object model) Parent dari DOM item yang mau di scrap
list_css <- c('.lister-item-header','.lister-item-header','.ratings-bar+ .text-muted','.lister-item-header+ .text-muted','.ratings-bar','.sort-num_votes-visible','.sort-num_votes-visible','.text-muted+ p','.text-muted+ p','.ratings-bar','.lister-item-header+ .text-muted')

## membuat data frame dari variable head, item css dan list css
parameter_df <- data.frame(head =head,item_css = item_css, list_css = list_css, stringsAsFactors=FALSE)

## membuat data frame penyimpangan hasil scrap
hasil_df <- data.frame(matrix(ncol = nrow(parameter_df), nrow = 100))

## memberikan nama colom data frame penyimpanan hasil
colnames(hasil_df) <- parameter_df$head
parameter_df

## Looping untuk memulai scraping
for ( i in 1: nrow(parameter_df) ){
  print(parameter_df$head[i])
  webpage <- read_html(url)
  data_html <- html_text(html_nodes(webpage,parameter_df$item_css[i])) 
  list_html <-  html_text(html_nodes(webpage,parameter_df$list_css[i]))
  # menghitung jumlah item yang di scrap
  length_data <-length(data_html)
  # menghitung jumlah list tempat item berada yang di scrap
  length_list<-length(list_html)
  # menguji apakah jumlah item sama dengan jumlah list'
  # bila jumlah item < dari jumlah list maka terdapat item yang hilang
  # mengisi NA pada item yang hilang
  
  if (length_data<length_list ){
    #mengecek item pada DOM list
    sub_extrak <- str_extract(list_html,parameter_df$head[i])
    # menyimpan Index dari item yang hilang
    index_na<-which(is.na(sub_extrak))
    # mengisi item yang hilang dengans NA
    for (j in  index_na){
      a<-data_html[1:(j-1)]
      b<-data_html[j:length(data_html)]
       data_html<-append(a,NA)
       data_html<-append(data_html,b)
    }
  }
  # Menyimpan hasil scrap ke dalam data frame
  hasil_df[parameter_df$head[i]]<-as.character(data_html)
}

# data frame hasil scrap sebelum reformat
head(hasil_df)

###  Reformat Rank
hasil_df$Rank<-as.integer(hasil_df$Rank)
head(hasil_df)

### Reformat Description
hasil_df$Description<-gsub("\n","",hasil_df$Description)
head(hasil_df)

### Reformat runtime
hasil_df$Runtime<-as.integer(gsub(" min","",hasil_df$Runtime))
head(hasil_df)

### Reformat Rating
hasil_df$Rating<-as.numeric(hasil_df$Rating)
head(hasil_df)

### Reformat vote
hasil_df$Votes<-as.numeric(sub(",", "", hasil_df$Votes, fixed = TRUE))
head(hasil_df)

### Reformat gross
gross_data<-hasil_df$Gross
gross_data<-gsub("M","",gross_data)
gross_data<-substring(gross_data,2,6)
hasil_df$Gross<-as.numeric(gross_data)
head(hasil_df)

## Reformat metascore
hasil_df$Metascore<-as.numeric(hasil_df$Metascore)
head(hasil_df)

### Reformat genre
genre<-hasil_df$Genre
genre <-str_extract_all(genre,'\\w+')
length(genre)
for (i in 1:length(genre) ){
  genre1[i]<-genre[[i]][1]
  genre2[i]<-genre[[i]][2]
  genre3[i]<-genre[[i]][3]
  
}
hasil_df$Genre<-genre1
hasil_df$Genre2<-genre2
hasil_df$Genre3<-genre3

### dataframe hasil reformat
head(hasil_df)

write.csv(hasil_df,file="top1000movies.csv")
