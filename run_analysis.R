library(dplyr)

## Merges the training and the test sets to create one data set.
## training set is stored train/X_train.txt
## test set is stored test/X_test.txt
Xtrain <- read.table("./train/X_train.txt")
Xtest <- read.table("./test/X_test.txt")
Ytrain <- read.table("./train/y_train.txt")
Ytest <- read.table("./test/y_test.txt")


# merge train data and test data (also label)
mergedata <- rbind(cbind(Xtrain,Ytrain), cbind(Xtest,Ytest))

# get featurename from features.txt
featurename <- read.table("./features.txt")
# names columns with feature names
names(mergedata) <- c(featurename[,2], "activity")

# load activity name table
actname <- read.table("./activity_labels.txt", col.names = c("activity", "actdscriptive"))
mergedata <- merge(mergedata, actname, by.x="activity", by.y="activity")

# select only the columns name include either "mean" or "std"
selectdata <- select(mergedata, matches(c("mean","std","actdscriptive")))

# take average by activity
gp_act <- group_by(selectdata, actdscriptive)
databyacttype <- summarise_all(gp_act, mean)
write.table(databyacttype, file="submit.txt", row.names = FALSE, )

