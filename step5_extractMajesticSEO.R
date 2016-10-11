library(dplyr)
library(rjson)
library(urltools)
library(stringr)
library(httr)


apiKey <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
# change to api for prod
# change to developper to sandbox
apiUrl <-"https://api.majestic.com/api/json?app_api_key="

#historic : all period
#refresh : 90 last days
modeUrl <- "historic"
fileName <- "./majestic/dataset-majestic-historic.csv"

#autoriser la bonne IP !!!!!!!!!!!
httr::set_config( config( ssl_verifypeer = 0L ) )

#
# get majestic data
#
majesticGetInfoUrl <- function(u) {
  
  u <- url_encode(u)
  
  print(proc.time())
  
  url <- paste(apiUrl,apiKey,"&cmd=GetIndexItemInfo&items=1&item0=",u,"&datasource=",modeUrl,sep="")
  
  req <-GET(url)
  
  #result <- fromJSON( req )
  result <- content(req)$DataTables$Results$Data
  
  return(result)
}


datasetNatUniqueSubdomain <- datasetNat[!duplicated(datasetNat$Subdomain), ]

if(file.exists(fileName)){
  print("file exist")
  dataDf <- read.csv2(fileName, header = TRUE, stringsAsFactors = FALSE)
  init <- dim(dataDf)[1]  
} 

if (!file.exists(fileName)){
  print("file not exist")  
  init <- 1
  dataDf <- data.frame(ItemNum="",Item="",ResultCode="",Status="",ExtBackLinks="",RefDomains="",AnalysisResUnitsCost="",ACRank="",ItemType="",IndexedURLs="",GetTopBackLinksAnalysisResUnitsCost="",DownloadBacklinksAnalysisResUnitsCost="",DownloadRefDomainBacklinksAnalysisResUnitsCost="",RefIPs="",RefSubNets="",RefDomainsEDU="",ExtBackLinksEDU="",RefDomainsGOV="",ExtBackLinksGOV="",RefDomainsEDU_Exact="",ExtBackLinksEDU_Exact="",RefDomainsGOV_Exact="",ExtBackLinksGOV_Exact="",CrawledFlag="",LastCrawlDate="",LastCrawlResult="",RedirectFlag="",FinalRedirectResult="",OutDomainsExternal="",OutLinksExternal="",OutLinksInternal="",LastSeen="",Title="",RedirectTo="",CitationFlow="",TrustFlow="",TrustMetric="",TopicalTrustFlow_Topic_0="",TopicalTrustFlow_Value_0="",TopicalTrustFlow_Topic_1="",TopicalTrustFlow_Value_1="",TopicalTrustFlow_Topic_2="",TopicalTrustFlow_Value_2="")
  dataDf <- data.frame(lapply(dataDf, as.character), stringsAsFactors=FALSE)
}
  


for(i in init:dim(datasetNatUniqueSubdomain)[1]){
  url <- datasetNatUniqueSubdomain$Subdomain[i]

  result = tryCatch({
    df <- majesticGetInfoUrl(url)
    df <- as.data.frame(df, stringsAsFactors= FALSE)
  },
    error = {
      df <- data.frame(ItemNum="",Item="",ResultCode="",Status="",ExtBackLinks="",RefDomains="",AnalysisResUnitsCost="",ACRank="",ItemType="",IndexedURLs="",GetTopBackLinksAnalysisResUnitsCost="",DownloadBacklinksAnalysisResUnitsCost="",DownloadRefDomainBacklinksAnalysisResUnitsCost="",RefIPs="",RefSubNets="",RefDomainsEDU="",ExtBackLinksEDU="",RefDomainsGOV="",ExtBackLinksGOV="",RefDomainsEDU_Exact="",ExtBackLinksEDU_Exact="",RefDomainsGOV_Exact="",ExtBackLinksGOV_Exact="",CrawledFlag="",LastCrawlDate="",LastCrawlResult="",RedirectFlag="",FinalRedirectResult="",OutDomainsExternal="",OutLinksExternal="",OutLinksInternal="",LastSeen="",Title="",RedirectTo="",CitationFlow="",TrustFlow="",TrustMetric="",TopicalTrustFlow_Topic_0="",TopicalTrustFlow_Value_0="",TopicalTrustFlow_Topic_1="",TopicalTrustFlow_Value_1="",TopicalTrustFlow_Topic_2="",TopicalTrustFlow_Value_2="")
      
  },
    finally = {
      dataDf <- rbind(dataDf,df)
      write.csv2(dataDf,fileName,row.names = FALSE)
  })

}
