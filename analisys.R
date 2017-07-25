library(plyr)
library(dplyr)


# Merges the training and the test sets to create one data set.

xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")
subjecttrain <- read.table("train/subject_train.txt")

xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")
subjecttest <- read.table("test/subject_test.txt")

xdata <- rbind(xtrain, xtest)
ydata <- rbind(ytrain, ytest)
subjectdata <- rbind(subjecttrain, subjecttest)


# Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt")
meanStdFeatures <- grep("-(mean|std)\\(\\)", features[, 2])
xdata <- xdata[, meanStdFeatures]
names(xdata) <- features[meanStdFeatures, 2]

# Uses descriptive activity names to name the activities in the data set

activities <- read.table("activity_labels.txt")
ydata[, 1] <- activities[ydata[, 1], 2]
names(ydata) <- "activity"

# Appropriately labels the data set with descriptive variable names.

names(subjectdata) <- "subject"
alldata <- cbind(xdata, ydata, subjectdata)

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy <- ddply(alldata, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(tidy, "tidy.txt", row.name=FALSE)

