
# 1. Merge the training and the test data.
features        <- read.table("./features.txt",header=FALSE)
activity_label   <- read.table("./activity_labels.txt",header=FALSE)
subject_train    <-read.table("./train/subject_train.txt", header=FALSE)
x_train          <- read.table("./train/X_train.txt", header=FALSE)
y_train          <- read.table("./train/y_train.txt", header=FALSE)
colnames(activity_label)<-c("activityId","activityType")
colnames(subject_train) <- "subId"
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityId"
train_data <- cbind(y_train,subject_train,x_train)

subject_test    <-read.table("./test/subject_test.txt", header=FALSE)
x_test         <- read.table("./test/X_test.txt", header=FALSE)
y_test         <- read.table("./test/y_test.txt", header=FALSE)
colnames(subject_test) <- "subId"
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityId"
test_data <- cbind(y_test,subject_test,x_test)

merge_data <- rbind(train_data,test_data)
head(merge_data, 2)
colNames <- colnames(merge_data);



# 2. Extract only the measurements on the mean and standard deviation for each measurement

data_meanstd <-merge_data[,grepl("mean|std|subject|activityId",colnames(merge_data))]



# 3. Uses descriptive activity names to name the activities in the data set


library(plyr)

data_meanstd <- join(data_meanstd, activity_label, by = "activityId", match = "first")

data_meanstd <-data_meanstd[,-1]

#4. Appropriately labels the data set with descriptive variable names.

names(data_meanstd) <- gsub("\\(|\\)", "", names(data_meanstd), perl  = TRUE)
names(data_meanstd) <- make.names(names(data_meanstd))
names(data_meanstd) <- gsub("Acc", "Acceleration", names(data_meanstd))
names(data_meanstd) <- gsub("^t", "Time", names(data_meanstd))
names(data_meanstd) <- gsub("^f", "Frequency", names(data_meanstd))
names(data_meanstd) <- gsub("BodyBody", "Body", names(data_meanstd))
names(data_meanstd) <- gsub("mean", "Mean", names(data_meanstd))
names(data_meanstd) <- gsub("std", "Std", names(data_meanstd))
names(data_meanstd) <- gsub("Freq", "Frequency", names(data_meanstd))
names(data_meanstd) <- gsub("Mag", "Magnitude", names(data_meanstd))

# 5creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidydata_average_sub <- ddply(data_meanstd, .("subject","activity"), numcolwise(mean))
write.table(tidydata_average_sub,file="tidydata.txt")
tidydata_average_sub
head(tidydata_average_sub,2)
