########################################################
# import library and set the current working directory #
########################################################
library(dplyr)
setwd("~/R programming/UCI HAR Dataset")

##################
# Read test data #
##################
X_test <- read.table("~/R programming/UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
y_test <- read.table("~/R programming/UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")
subject_test <- read.table("~/R programming/UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")

###################
# Read train data #
###################
X_train <- read.table("~/R programming/UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
y_train <- read.table("~/R programming/UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")
subject_train <- read.table("~/R programming/UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")

##############################################
# Merge test and train dataset using rbind() #
##############################################
merged_x_data <- rbind(X_train, X_test)
merged_y_data <- rbind(y_train, y_test)
merged_sub_total_data <- rbind(subject_train, subject_test)

####################################
# Read list of the activity labels #
####################################
activity_labels <- read.table("~/R programming/UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")

##########################
# Read the feature names #
##########################
features <- read.table("~/R programming/UCI HAR Dataset/features.txt", quote="\"", comment.char="")
selected_feature_name <- features[grep(".*mean\\b|.*std\\b", features[,2]),]

########################################################################
# Only get feature names with mean and standard deviation measurements #
########################################################################
merged_x_data <- merged_x_data[,selected_feature_name[,1]]
colnames(merged_x_data) <- features[selected_feature_name[,1],2]

#########################################################################
# Use descriptive activity names to name the activities in the data set #
#########################################################################
colnames(merged_y_data) <- "activity"
merged_y_data$activitylabel <- factor(merged_y_data$activity, labels = as.character(activity_labels[,2]))
activitylabel <- merged_y_data[,-1]

#################################################################
# Assign labels to the data set with descriptive feature names. #
#################################################################
colnames(merged_sub_total_data) <- "subject"

########################################################
# Merge all the data x, y and subject into one dataset #
########################################################
total <- cbind(activitylabel, merged_sub_total_data, merged_x_data)

##############################################################################################
# Create tidy data set with the average of each variable for each activity and each subject. #
##############################################################################################
final_tidy_data <- aggregate(total[names(total) != c('activitylabel', 'subject')], by=list(activity=total$activity, subject=total$subject),mean)
write.table(final_tidy_data, file = "~/R programming/final_tidy_dataset.txt", row.names = FALSE, col.names = TRUE)