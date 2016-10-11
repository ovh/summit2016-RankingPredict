library(dplyr)
library(RCurl)
library(rjson)
library(urltools)
library(stringr)


datasetVisiblis <-  read.csv2("./visiblis/visiblis.csv")
datasetVisiblis <- select(datasetVisiblis,url,ast,asp)

datasetNatVisiblis <- merge(x = datasetNatMajestic, y = datasetVisiblis, by.x = "URL", by.y = "url", all.x = TRUE)




