library(dplyr)
library(data.table)

datasetPrepared <- select(datasetNatVisiblis,
                          
                          Keyword,
                          URL,
                          
                          `Status Code`,
                          `Title 1`,
                          `Title 1 Length`,

                          `H1-1`,
                          `H1-1 length`,
                          
                          `H1-2`,
                          `H1-2 length`,
                          
                          `H2-2`,
                          `H2-2 length`,
                          
                          `Word Count`,
                          `Text Ratio`,
                          `Inlinks`,
                          `Outlinks`,
                          `Response Time`,
                          
                          ExtBackLinks,             
                          RefDomains,
                          
                          
                          RefIPs,                                        
                          RefSubNets,                                     
                          
                          
                          CitationFlow,                                   
                          TrustFlow,                                     
                          TrustMetric,                                    
                          TopicalTrustFlow_Topic_0,                      
                          TopicalTrustFlow_Value_0,                       
                          TopicalTrustFlow_Topic_1,                      
                          TopicalTrustFlow_Value_1,                       
                          TopicalTrustFlow_Topic_2,                      
                          TopicalTrustFlow_Value_2,  
                          
                          ast,
                          asp,
                                                    
                          
                          isTopTen)



setnames(datasetPrepared, "ast", "Visiblis_Title")
setnames(datasetPrepared, "asp", "Visiblis_Page")

# filter only rescode 200
datasetCleaned <- filter(datasetPrepared, `Status Code`==200 )

write.csv2(datasetCleaned,"./dataset/dataset.csv")



