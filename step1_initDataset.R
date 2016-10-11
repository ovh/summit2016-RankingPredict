library(dplyr)

dataset <- read.csv2("./ranxplorer/spider_2016-08.csv", header = TRUE, stringsAsFactors = FALSE, sep="\t")

# select only organic results
datasetNat <-  filter(dataset, Universal.Search=="Nat" )

# add metric isTopTen
datasetNat$isTopTen <- FALSE
datasetNat$isTopTen[which(datasetNat$Absolute.Position<=10)] <- TRUE

# select specific column
datasetNat <- select(datasetNat, Keyword, URL, Absolute.Position, Result.Number, Search.Volume, isTopTen, Subdomain)

# write urls in CSV files for next analysis
write.csv(datasetNat$URL,"./dataset/dataset-URLCrawl.csv", row.names = FALSE)

# write subdomains in CSV files for next analysis
datasetNatSubdomain <- unique(datasetNat$Subdomain)
write.csv(datasetNatSubdomain,"./dataset/dataset-URLCF-TF.csv", row.names = FALSE)

