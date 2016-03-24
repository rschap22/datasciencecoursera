library(plyr)

##load data sets
x_train <- read.table("train/X_train.txt")
labels_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
labels_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

##combine x data sets
x_data <- rbind(x_train, x_test)

##combine label data sets
labels_data <- rbind(labels_train, labels_test)

##combine subject data sets
subject_data <- rbind(subject_train, subject_test)


##extract means and SD
features <- read.table("features.txt")
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
x_data <- x_data[, mean_and_std_features]

##correct column names
names(x_data) <- features[mean_and_std_features, 2]


##use descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")
labels_data[, 1] <- activities[labels_data[, 1], 2]

##correct column name
names(labels_data) <- "activity"


##label the data set with descriptive variable names
names(subject_data) <- "subject"

##combine all data
full_data <- cbind(x_data, labels_data, subject_data)

##Create a data set with the average of each variable for each activity and each subject
averages_data <- ddply(full_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)