#ACUWEATHER API DATA SCRAPING

#Libraries
pacman::p_load(httr, jsonlite, dplyr)

#Pulling url w/ developer key
url<- paste0("https://www.accuweather.com/en/us/seattle/98188/weather-forecast/351409?apikey=lvNg7s4vIHGnGPGAJNtWVaplURGdfACG")

#Getting url & structure
extract_url<- httr::GET(url)
str(extract_url)

#Content mining
str(extract_url$content)

content_extract <- httr::content(extract_url, as = 'text', encoding = "UTF-8")
str(content_extract)

content_json<- jsonlite::fromJSON(content_extract)
dplyr::glimpse(content_json)

#Data Mining
base_url <- "http://dataservice.accuweather.com/locations/v1/cities/search"

location_pull <- GET(base_url,
                     query = list(apikey = "lvNg7s4vIHGnGPGAJNtWVaplURGdfACG",
                                  q = "Seattle, WA"))

location_parsed <- content(extract_url, as = 'text') %>%
  fromJSON() 

#Weather.gov direct scraping
library(htmltab)
#we will use this information to save the file
todaysdate <- Sys.Date()
folderpath <- "C:/RWeather/"

#read in web page - weather.gov
url <- "https://w1.weather.gov/data/obhistory/KSEA.html"

#point to the table based on its XPath
weather.f <- htmltab(doc = url, which = "/html/body/table[4]",
                     rm_nodata_cols = F)

#first 24 rows for first 24 hours of data
weathertoday <- weather.f[1:24,]

#save file as today's date
write.csv(weathertoday, paste(folderpath,todaysdate,".csv",sep=""), row.names = FALSE)


