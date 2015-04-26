## The following R script -
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Initialize library
library(dplyr)

# Download and unzip the data set from the given source and extract it locally
if (!file.exists("data_3.3")) {
  dir.create("data_3.3")
}
if (!file.exists("data_3.3/UCI HAR Dataset")) {
  url < -"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  zipfile = "data_3.3/UCI_HAR_data.zip"
  download.file(url, destfile = zipfile, method = "curl")
  unzip(zipfile, exdir = "data_3.3")
}

# Load data into data frames
y_train <- read.table("data_3.3/UCI HAR Dataset/train/y_train.txt", quote = "\"")
y_test <- read.table("data_3.3/UCI HAR Dataset/test/y_test.txt", quote = "\"")
features <- read.table("data_3.3/UCI HAR Dataset/features.txt", quote = "\"")
activity_labels <- read.table("data_3.3/UCI HAR Dataset/activity_labels.txt", quote = "\"")
subject_train <- read.table("data_3.3/UCI HAR Dataset/train/subject_train.txt", quote = "\"")
subject_test <- read.table("data_3.3/UCI HAR Dataset/test/subject_test.txt", quote = "\"")
X_train <- read.table("data_3.3/UCI HAR Dataset/train/X_train.txt", quote = "\"")
X_test <- read.table("data_3.3/UCI HAR Dataset/test/X_test.txt", quote = "\"")

# Merge activity labels and y_train dat by V1 (train dat)
colnames(activity_labels) <- c("V1", "Activity")
subject <- rename(subject_train, subject = V1)
train <- cbind(y_train, subject)
train <- merge(train, activity_labels, by = ("V1"))

# Combine all for train dat
colnames(X_train) <- features[, 2]
train <- cbind(train, X_train)
train <- train[, -1]

# Extracts only the measurements on the mean and standard deviation for train dat. 
train <- select(train, contains("subject"), contains("Activity"), contains("mean"), contains("std"))

# Combine rest for test dat
colnames(activity_labels) <- c("V1", "Activity")
subject <- rename(subject_test, subject = V1)
test <- cbind(y_test, subject)
test <- merge(test, activity_labels, by = ("V1"))
colnames(X_test) <- features[, 2]
test <- cbind(test, X_test)
test <- test[, -1]

# Extracts only the measurements on the mean and standard deviation for test dat. 
test <- select(test, contains("subject"), contains("Activity"), contains("mean"), contains("std"))

# Combining test and train dat. Then summarize.
run_analysis <- rbind(train4, test)
run_analysis <- (run_analysis %>%
                   group_by(subject, Activity) %>%
                   summarise_each(funs(mean)))

# Appropriately label the data set with descriptive names. 
names(run_analysis) <- gsub("Activity", "activity", names(run_analysis), fixed = "TRUE")
names(run_analysis) <- gsub("()", "", names(run_analysis), fixed = "TRUE")
names(run_analysis) <- gsub("Acc", "Accelerometer", names(run_analysis), fixed = "TRUE")
names(run_analysis) <- gsub("Gyro", "Gyroscope", names(run_analysis), fixed = "TRUE")
names(run_analysis) <- gsub("Mag", "Magnitude", names(run_analysis), fixed = "TRUE")
names(run_analysis) <- gsub("Freq", "Frequency", names(run_analysis), fixed = "TRUE")
names(run_analysis) <- gsub("BodyBody", "Body", names(run_analysis), fixed = "TRUE")
names(run_analysis) <- gsub("std", "standardDeviation", names(run_analysis), fixed = "TRUE")

# Independent tidy data set with the average of each variable for each activity and each subject.
run_analysis$subject <- as.factor(run_analysis$subject)
run_analysis <- data.table(run_analysis)

tidy.Data.Set <- aggregate(.~subject + activity, run_analysis, mean)
write.table(tidy.Data.Set, file = "Tidy.Data.Set.txt", row.names = FALSE)