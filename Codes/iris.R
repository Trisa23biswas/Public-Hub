#?iris

library('ggplot2')
library('caret')
library(skimr)
library(ellipse)

data(iris)
head(iris)
skim(iris)

# create a list of 80% of the rows in the original dataset we can use for training

validation_index <- createDataPartition(iris$Species, p=0.80, list=FALSE)
# select 20% of the data for validation
validation <- iris[-validation_index,]
# use the remaining 80% of data to training and testing the models
dataset <- iris[validation_index,]

# summarize the class distribution
percentage <- prop.table(table(dataset$Species)) * 100
cbind(freq=table(dataset$Species), percentage=percentage)


# split input and output
x <- dataset[,1:4]
y <- dataset[,5]
# scatterplot matrix
featurePlot(x=x, y=y, plot="ellipse")

# box and whisker plots for each attribute
featurePlot(x=x, y=y, plot="box")

# density plots for each attribute by class value
scales <- list(x=list(relation="free"), y=list(relation="free"))
featurePlot(x=x, y=y, plot="density", scales=scales)

#develop models
# Run algorithms using 10-fold cross validation
control <- trainControl(method="cv", number=10)
metric <- "Accuracy"
#KNN
set.seed(7)
fit.knn <- train(Species~., data=iris, method="knn", metric=metric, trControl=control)

# SVM
set.seed(7)
fit.svm <- train(Species~., data=iris, method="svmRadial", metric=metric, trControl=control)

# Random Forest
set.seed(7)
fit.rf <- train(Species~., data=iris, method="rf", metric=metric, trControl=control)

# summarize accuracy of models
results <- resamples(list(knn=fit.knn, svm=fit.svm, rf=fit.rf))
summary(results)

# compare accuracy of models
dotplot(results)

# summarize Best Model
print(fit.knn)

# estimate skill of knn on the validation dataset
predictions <- predict(fit.knn, validation)
confusionMatrix(predictions, validation$Species)

#append predicted values to original dataset
predvalue <- data.frame(iris,predictions)

#save the model
save(fit.knn, file='\\R\\Iris\\irisn.rda')

