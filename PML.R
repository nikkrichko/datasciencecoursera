library(ggplot2)
library(lattice)
library(caret)
library(corrplot)
library(kernlab)
library(randomForest)


# create and change working directory

if(!endsWith(getwd(), "project_PML")){
    if (!file.exists("project_PML")) {dir.create("project_PML")}
    setwd("./project_PML")
}



# download files in working directory
trainingFileName <- "pml-Training.csv"
trainingFileUrl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
if(!file.exists(trainingFileName)){
    download.file(trainingFileUrl, destfile = trainingFileName)
}
testingFileName <- "pml-Testing.csv"
testingFileUrl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
if(!file.exists(testingFileName)){
    download.file(testingFileUrl, destfile = testingFileName)    
}   
    


# read the csv file for training 
trainingData <- read.csv(trainingFileName, na.strings= c("NA",""," "))
testingData <- read.csv(testingFileName, na.strings= c("NA",""," "))


# Create function for creaning data

cleanData <- function(dataFrame){
dataFrame <- dataFrame[, colSums(is.na(dataFrame)) == 0]
classe <- dataFrame$classe    
forRemove <- grepl("^X|timestamp|window", names(dataFrame))
temp <- dataFrame[, !forRemove]
cleaned <-  temp[, sapply(temp, is.numeric)]
cleaned$classe <- classe
cleaned
}

#Clean data
trainingData <- cleanData(trainingData)
testingData <- cleanData(testingData)
dim(trainingData)
dim(testingData)


# split testing data to training and cross validation sets
inTrain <- createDataPartition(y = trainingData$classe, p = 0.7, list = FALSE)
trainingSet <- trainingData[inTrain, ]
crossValidationSet <- trainingData[-inTrain, ]

# plot a correlation matrix
correlMatrix <- cor(trainingSet[, -length(trainingSet)])
corrplot(correlMatrix, order = "FPC", method = "circle", type = "lower", tl.cex = 0.8,  tl.col = rgb(0, 0, 0))

# fit a model to predict the classe using everything else as a predictor


start.time <- Sys.time()
RFpack_model <- randomForest(classe ~ ., data = trainingSet)
end.time <- Sys.time()
RFpack_time_taken <- end.time - start.time



start.time <- Sys.time()
controlModel <- trainControl(method = "cv", 10)
CARETpack_model <- train(classe ~ ., data = trainingSet, method= "rf", ntree = 100, trControl = controlModel)
end.time <- Sys.time()
CARETpack_time_taken <- end.time - start.time


RFpack_time_taken
CARETpack_time_taken


# crossvalidate the model using the remaining 30% of data

RFpack_predictCrossVal <- predict(RFpack_model, crossValidationSet)
RFpack_resultOfPrediction<- confusionMatrix(crossValidationSet$classe, RFpack_predictCrossVal)
RFpack_resultOfPrediction

CARETpack_predictCrossVal <- predict(CARETpack_model, crossValidationSet)
CARETpack_resultOfPrediction<- confusionMatrix(crossValidationSet$classe, CARETpack_predictCrossVal)
CARETpack_resultOfPrediction

#find acrruracy

RFpack_accuracy <- postResample(RFpack_predictCrossVal, crossValidationSet$classe)
RFpack_accuracy

CARETpack_accuracy <- postResample(CARETpack_predictCrossVal, crossValidationSet$classe)
CARETpack_accuracy

#predict for test data set

RFpack_result1 <- predict(RFpack_model, testingData)
RFpack_result1

CARETpack_result2 <- predict(CARETpack_model, testingData)
CARETpack_result2







