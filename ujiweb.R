# Title     : IMDB Web Scraping
# Objective : To scrap IMDb website for the 100 most popular feature films released in 2016. 

# Source: https://www.analyticsvidhya.com/blog/2017/03/beginners-guide-on-web-scraping-in-r-using-rvest-with-hands-on-knowledge/ 

# Loading the rvest package
# install.packages('rvest')
library(rvest)

#Specifying the url for desired website to be scraped
url <- 'http://www.imdb.com/search/title?count=100&release_date=2016,2016&title_type=feature'

#Reading the HTML code from the website
webpage <- read_html(url)

# Here the list of columns are

# Rank: The rank of the film from 1 to 100 on the list of 100 most popular feature films released in 2016.
# Title: The title of the feature film.
# Description: The description of the feature film.
# Runtime: The duration of the feature film.
# Genre: The genre of the feature film,
# Rating: The IMDb rating of the feature film.
# Votes: Votes cast in favor of the feature film.
# Gross_Earning_in_Mil: The gross earnings of the feature film in millions.
# Director: The main director of the feature film. Note, in case of multiple directors, I’ll take only the first.
# Actor: The main actor of the feature film. Note, in case of multiple actors, I’ll take only the first.

# Step 1: Now, we will start with scraping the Rank field. For that, we’ll use the selector gadget to get the specific CSS selectors that encloses the rankings. You can click on the extenstion in your browser and select the rankings field with cursor.

# Step 2: Once you are sure that you have made the right selections, you need to copy the corresponding CSS selector that you can view in the bottom center.

# Step 3: Once you know the CSS selector that contains the rankings, you can use this simple R code to get all the rankings:

#Using CSS selectors to scrap the rankings section
rank_data_html <- html_nodes(webpage,'.text-primary')

#Converting the ranking data to text
rank_data <- html_text(rank_data_html)

#Let's have a look at the rankings
head(rank_data)

length(rank_data)

# Step 4: Once you have the data, make sure that it looks in the desired format. I am preprocessing my data to convert it to numerical format.

#Data-Preprocessing: Converting rankings to numerical
rank_data<-as.numeric(rank_data)

#Let's have another look at the rankings
head(rank_data)


# Step 5: Now you can clear the selector section and select all the titles. You can visually inspect that all the titles are selected. Make any required additions and deletions with the help of your curser. I have done the same here.

# Step 6: Again, I have the corresponding CSS selector for the titles – .lister-item-header a. I will use this selector to scrap all the titles using the following code.

#Using CSS selectors to scrap the title section
title_data_html <- html_nodes(webpage,'.lister-item-header a')

#Converting the title data to text
title_data <- html_text(title_data_html)

#Let's have a look at the title
head(title_data)


#Step 7: In the following code, I have done the same thing for scraping – Description, Runtime, Genre, Rating, Metascore, Votes, Gross_Earning_in_Mil , Director and Actor data.

#Using CSS selectors to scrap the description section
description_data_html <- html_nodes(webpage,'.ratings-bar+ .text-muted')

#Converting the description data to text
description_data <- html_text(description_data_html)

#Let's have a look at the description data
head(description_data)

#Data-Preprocessing: removing '\n'
description_data<-gsub("\n","",description_data)

#Let's have another look at the description data 
head(description_data)

#Using CSS selectors to scrap the Movie runtime section
runtime_data_html <- html_nodes(webpage,'.text-muted .runtime')

#Converting the runtime data to text
runtime_data <- html_text(runtime_data_html)

#Let's have a look at the runtime
head(runtime_data)

#Data-Preprocessing: removing mins and converting it to numerical

runtime_data<-gsub(" min","",runtime_data)
runtime_data<-as.numeric(runtime_data)

#Let's have another look at the runtime data
head(runtime_data)


#Using CSS selectors to scrap the Movie genre section
genre_data_html <- html_nodes(webpage,'.genre')

#Converting the genre data to text
genre_data <- html_text(genre_data_html)

#Let's have a look at the runtime
head(genre_data)

#Data-Preprocessing: removing \n
genre_data<-gsub("\n","",genre_data)

#Data-Preprocessing: removing excess spaces
genre_data<-gsub(" ","",genre_data)

#taking only the first genre of each movie
#regex mengambil data pertama didepan koma
genre_data<-gsub(",.*","",genre_data)

#Convering each genre from text to factor
genre_data<-as.factor(genre_data)

#Let's have another look at the genre data
head(genre_data)

#Using CSS selectors to scrap the IMDB rating section
rating_data_html <- html_nodes(webpage,'.ratings-imdb-rating strong')

#Converting the ratings data to text
rating_data <- html_text(rating_data_html)

#Let's have a look at the ratings
head(rating_data)

#Data-Preprocessing: converting ratings to numerical
rating_data<-as.numeric(rating_data)

#Let's have another look at the ratings data
head(rating_data)

#Using CSS selectors to scrap the votes section
votes_data_html <- html_nodes(webpage,'.sort-num_votes-visible span:nth-child(2)')

#Converting the votes data to text
votes_data <- html_text(votes_data_html)

#Let's have a look at the votes data
head(votes_data)

#Data-Preprocessing: removing commas
votes_data<-gsub(",","",votes_data)

#Data-Preprocessing: converting votes to numerical
votes_data<-as.numeric(votes_data)

#Let's have another look at the votes data
head(votes_data)

#Using CSS selectors to scrap the directors section
directors_data_html <- html_nodes(webpage,'.text-muted+ p a:nth-child(1)')

#Converting the directors data to text
directors_data <- html_text(directors_data_html)

#Let's have a look at the directors data
head(directors_data)

#Data-Preprocessing: converting directors data into factors
directors_data<-as.factor(directors_data)

#Using CSS selectors to scrap the actors section
actors_data_html <- html_nodes(webpage,'.lister-item-content .ghost+ a')

#Converting the gross actors data to text
actors_data <- html_text(actors_data_html)

#Let's have a look at the actors data
head(actors_data)

#Data-Preprocessing: converting actors data into factors
actors_data<-as.factor(actors_data)

# #Using CSS selectors to scrap the metascore section
# metascore_data_html <- html_nodes(webpage,'.metascore')
# 
# #Converting the runtime data to text
# metascore_data <- html_text(metascore_data_html)
# 
# #Let's have a look at the metascore 
# head(metascore_data)
# 
# #Data-Preprocessing: removing extra space in metascore
# metascore_data<-gsub(" ","",metascore_data)
# 
# #Lets check the length of metascore data
# length(metascore_data)

#Step 8: The length of meta score data is 96 while we are scraping the data for 100 movies. The reason this happened is because there are 4 movies which don’t have the corresponding Metascore fields.

#Step 9: It is a practical situation which can arise while scraping any website. Unfortunately, if we simply add NA’s to last 4 entries, it will map NA as Metascore for movies 96 to 100 while in reality, the data is missing for some other movies. After a visual inspection, I found that the Metascore is missing for movies 39, 73, 80 and 89. I have written the following function to get around this problem.

# for (i in c(39,73,80,89)){
#   
#   a<-metascore_data[1:(i-1)]
#   
#   b<-metascore_data[i:length(metascore_data)]
#   
#   metascore_data<-append(a,list("NA"))
#   
#   metascore_data<-append(metascore_data,b)
#   
# }
# 
# #Data-Preprocessing: converting metascore to numerical
# metascore_data<-as.numeric(metascore_data)
# 
# #Let's have another look at length of the metascore data
# 
# length(metascore_data)
# 
# #Let's look at summary statistics
# summary(metascore_data)
# 
# #Using CSS selectors to scrap the gross revenue section
 gross_data_html <- html_node(webpage,'.ghost~ .text-muted+ span')
# 
# #Converting the gross revenue data to text
 gross_data <- html_text(gross_data_html)
 gross_data
# 
# #Let's have a look at the votes data
# head(gross_data)
# 
# #Data-Preprocessing: removing '$' and 'M' signs
# gross_data<-gsub("M","",gross_data)
# 
# gross_data<-substring(gross_data,2,6)
# 
# #Let's check the length of gross data
# length(gross_data)
# 
# #Filling missing entries with NA
# for (i in c(52,64,66,73,76,77,80,87,88,89)){
#   
#   a<-gross_data[1:(i-1)]
#   
#   b<-gross_data[i:length(gross_data)]
#   
#   gross_data<-append(a,list("NA"))
#   
#   gross_data<-append(gross_data,b)
#   
# }
# 
# #Data-Preprocessing: converting gross to numerical
# gross_data<-as.numeric(gross_data)
# 
# #Let's have another look at the length of gross data
# length(gross_data)
# 
# summary(gross_data)

# Step 11: Now we have successfully scraped all the 9 features for the 100 most popular feature films released in 2016. Let’s combine them to create a dataframe and inspect its structure.

#Combining all the lists to form a data frame
movies_df<-data.frame(Rank = rank_data, Title = title_data,
                      Description = description_data, Runtime = runtime_data,
                      Genre = genre_data, Rating = rating_data,
                      
                      Director = directors_data, Actor = actors_data)

write.csv(movies_df,'top1000movies.csv')
#Structure of the data frame
getwd()
str(movies_df)
#You have now successfully scraped the IMDb website for the 100 most popular feature films released in 2016.
