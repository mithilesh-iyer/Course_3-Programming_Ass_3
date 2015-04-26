## The R script run_analysis.R -
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## run_analysis.R first initializes the dplyr and data.table libraries. It then downloads the zip file under the data_4.3 folder in the wd and then unzips the file under UCI_HAR_data folder.

## variables initialized: y_train, y_test, features, activity_labels, subject_train, subject_test, X_train, X_test

## Train and test data is then loaded in to data frames. First, training data is merged and then rows with mean & std are extracted. Similarly, test data is then merged after which analysis is performed by calculating mean over subject and activity data.

## Important variables: run_analysis, train, test

## Relevant labels are then given to make them more descriptive.

## Here, fixed = "TRUE" is added to the gsub function to escape any characters that might interfere incorrectly with the list of names. Eg (parenthesis)

## Independent tidy data set with the average of each variable for each activity and each subject is calculated.

## Finally, this set is written to a file called Tidy.Data.Set