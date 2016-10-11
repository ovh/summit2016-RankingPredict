library(dplyr)
library(rjson)
library(urltools)
library(stringr)
library(httr)

datasetMajestic <-  read.csv2("./majestic/dataset-majestic-historic.csv")

datasetNatMajestic <- merge(x = datasetNatSF, y = datasetMajestic, by.x = "Subdomain", by.y = "Item", all.x = TRUE)
