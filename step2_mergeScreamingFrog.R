library(dplyr)
library(readxl)

# import xlsx screaming frog
# you need to crawl each urls using "Mode List"
pathxlsx <- './screamingfrog/internal_html_dataset.xlsx'

datasetSF <-  read_excel(pathxlsx, 
                    sheet = 1, 
                    col_names = TRUE,   
                    na = "",                     
                    skip=1)

# merge screamingfrog data with previous dataset
datasetNatSF <- merge(x = datasetNat, y = datasetSF, by.x = "URL", by.y = "Address", all.x = TRUE) %>% 
                  arrange(Keyword,Absolute.Position)