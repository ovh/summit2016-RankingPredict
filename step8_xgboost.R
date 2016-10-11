library(dplyr)
library(xgboost)
library(readr)
library(stringr)
library(caret)
library(car)
library(clusterSim)
library(Ckmeans.1d.dp)
library(pROC)
library(SDMTools)

set.seed(123)

datasetXg <- read.csv2("./dataset/dataset-cleaned.csv",stringsAsFactors=FALSE,header = TRUE)

#cleansing
datasetXg <- filter(datasetXg, Visiblis_Page>0 & Visiblis_Title>0 )

datasetXg$Https <- 0
datasetXg$Https[which(grepl("https",datasetXg$URL))] <- 1

#create training dataset
datasetMat <- dplyr::select(datasetXg
                            #,Text.Ratio
                            ,Word.Count
                            ,Response.Time
                            ,TrustFlow
                            ,CitationFlow
                            ,Visiblis_Page
                            ,Visiblis_Title
                            #,Inlinks
                            #,Outlinks
                            #,Title.1.Length
                            #,H1.1.length
                            ,RefDomains
                            ,ExtBackLinks
                            ,Https
)

datasetMat$Visiblis_Page <- as.numeric(datasetMat$Visiblis_Page)
datasetMat$Visiblis_Title <- as.numeric(datasetMat$Visiblis_Title)

datasetMat[is.na(datasetMat)] <- 0

#normalization
datasetMat <- data.Normalization(datasetMat, type="n1", normalization="column")

## 75% of the sample size
smp_size <- floor(0.75 * nrow(datasetMat))
train_ind <- sample(seq_len(nrow(datasetMat)), size = smp_size)

X <- datasetMat[train_ind, ]
X_test <- datasetMat[-train_ind, ]
y<- datasetXg[train_ind, "label"]
y_test<-datasetXg[-train_ind, "label"]

model <- xgboost(data = data.matrix(X[,-1]), 
                 label = y, 
                 eta = 0.1,
                 max_depth = 10,
                 verbose=1,
                 nround = 1000,
                 objective = "binary:logistic",
                 nthread = 8
)

y_pred <- predict(model, data.matrix(X_test[,-1]))
#y_pred <- matrix(y_pred, nrow=length(y_test), ncol=2, byrow=T)

#sum(y_test)
#sum(abs(y_pred - y_test))
#sum(abs(  y_pred-0.5>0   -y_test))

p1 <- plot(roc(y_test, y_pred))

importance_matrix <- xgb.importance(names(X), model = model)
p2 <- xgb.plot.importance(importance_matrix)

conf <- confusionMatrix(y_test, as.integer(y_pred>0.9))
print(conf)
