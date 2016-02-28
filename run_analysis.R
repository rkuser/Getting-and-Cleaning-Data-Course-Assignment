# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 1. Merges the training and the test sets to create one data set.

tmp_train <- read.table("~/Desktop/Coursera/UCI_HAR_Dataset/train/X_train.txt")
tmp_test <- read.table("~/Desktop/Coursera/UCI_HAR_Dataset/test/X_test.txt")
tmp_X <- rbind(tmp_train, tmp_test)

tmp_train <- read.table("~/Desktop/Coursera/UCI_HAR_Dataset/train/subject_train.txt")
tmp_test <- read.table("~/Desktop/Coursera/UCI_HAR_Dataset/test/subject_test.txt")
tmp_subject <- rbind(tmp_train, tmp_test)

tmp_train <- read.table("~/Desktop/Coursera/UCI_HAR_Dataset/train/y_train.txt")
tmp_test <- read.table("~/Desktop/Coursera/UCI_HAR_Dataset/test/y_test.txt")
tmp_Y <- rbind(tmp_train, tmp_test)

# 2. Extracts only the measurements on the mean and standard 
#    deviation for each measurement.

features_txt <- read.table("features.txt")
indices_of_good_features <- grep("-mean\\(\\)|-std\\(\\)", features_txt[, 2])
tmp_X <- tmp_X[, indices_of_good_features]
names(tmp_X) <- features_txt[indices_of_good_features, 2]
names(tmp_X) <- gsub("\\(|\\)", "", names(tmp_X))
names(tmp_X) <- tolower(names(tmp_X))  

# 3. Uses descriptive activity names to name the activities in the data set

activity_names <- read.table("~/Desktop/Coursera/UCI_HAR_Dataset/activity_labels.txt")
activity_names[, 2] = gsub("_", "", tolower(as.character(activity_names[, 2])))
tmp_Y[,1] = activity_names[tmp_Y[,1], 2]
names(tmp_Y) <- "activity"

# 4. Appropriately labels the data set with descriptive activity names.

names(tmp_subject) <- "subject"
cleaned <- cbind(tmp_subject, tmp_Y, tmp_X)
write.table(cleaned, "~/Desktop/Coursera/tidy_dataset_1.txt")

# 5. Creates a 2nd, independent tidy data set with the 
#    average of each variable for each activity and each subject.
num_subjects = length(unique(tmp_subject)[,1])
unique_subjects = unique(tmp_subject)[,1]
num_activities = length(activity_names[,1])
num_cols = dim(cleaned)[2]
answer = cleaned[1:(num_subjects*num_activities), ]

row = 1
for (s in 1:num_subjects) {
  for (a in 1:num_activities) {
    answer[row, 1] = unique_subjects[s]
    answer[row, 2] = activity_names[a, 2]
    tmp_holder <- cleaned[cleaned$subject==s & cleaned$activity==activity_names[a, 2], ]
    answer[row, 3:numCols] <- colMeans(tmp_holder[, 3:numCols])
    row = row+1
  }
}
write.table(answer, "~/Desktop/Coursera/tidy_dataset_2.txt")
