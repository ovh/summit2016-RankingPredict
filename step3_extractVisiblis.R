library(dplyr)
library(RCurl)
library(rjson)
library(urltools)
library(stringr)

# your key
# authorize your IP
visiblisKey <- "XXXXXXXXXXXXXXXXXXXXXXXXXX"
visiblisFormat <- "json"
visiblisLng <- "fr"

fileName <- "./visiblis/visiblis.csv"

#
# get semantic quality by url
#
# return json : as_titre, as_page
#
visiblisGetInfoUrl <- function(u,req,lang) {
  
  u <- url_encode(u)
  
  print(proc.time())
  
  url <- paste("http://api.visiblis.com/v2/affinite.php?key=",visiblisKey,"&req=",req,"&url=",u,"&lng=",lang,"&fmt=",visiblisFormat,sep="")
  
  
  req <-getURL(
    url,
    httpheader = c(
      "accept-encoding" = "gzip"
    ) 
     , verbose = TRUE
  );
  
  result <- fromJSON( req )
  
  return(result)
}


datasetNatUnique <- datasetNat[!duplicated(datasetNat$URL), ]

if(file.exists(fileName)){
  print("file exist")
  dataDf <- read.csv2(fileName, header = TRUE, stringsAsFactors = FALSE)
  init <- dim(dataDf)[1]  
} 

if (!file.exists(fileName)){
  print("file not exist")  
  init <- 1
  dataDf <- data.frame(url="",request="",langue="",as_titre="",as_page="")
  dataDf <- data.frame(lapply(dataDf, as.character), stringsAsFactors=FALSE)
}

for(i in init:dim(datasetNatUnique)[1]){
  url <- datasetNatUnique$URL[i]
  keyword <- datasetNatUnique$Keyword[i]
  
  result = tryCatch({
    df <- as.data.frame(visiblisGetInfoUrl(url,keyword,visiblisLng))
    Sys.sleep(2)
  },
    error = {
      df <- data.frame(url="",request="",langue="",as_titre="",as_page="")
  },
    finally = {
      dataDf <- rbind(dataDf,df)
      write.csv2(dataDf,fileName,row.names = FALSE)
  })
  

}


