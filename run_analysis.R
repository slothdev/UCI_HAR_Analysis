# run_analysis.R
# Edwin Seah 20150219121340 
# https://github.com/slothdev/UCI_HAR_Analysis
#
# Script for the analysis of HCI accerlerometer data from Samsung smartphones
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

run_analysis <- function() {
    # Loads libraries to be used
    library(data.table)
    library(dplyr)
    
    # Grab and unzip the source file if not already in working directory
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zipfile <- "UCI\ HAR\ Dataset.zip"
    if (!file.exists(zipfile)) {
        download.file(url, paste0(getwd(), "/", zipfile), method="curl")
    }
    unzip(zipfile)
    
    # Specify relevant directory and filenames to read from
    # Assumes data zipfile is in current working directory
    rawdir <- sprintf("%s/%s/", getwd(), "UCI HAR Dataset")
    rawfile_train <- paste0(rawdir, "train/X_train.txt")
    rawfile_test <- paste0(rawdir, "test/X_test.txt")
    rawlabel_activity <- paste0(rawdir, "activity_labels.txt")
    rawlabel_atrain <- paste0(rawdir, "train/y_train.txt")
    rawlabel_atest <- paste0(rawdir, "test/y_test.txt")
    rawlabel_strain <- paste0(rawdir, "train/subject_train.txt")
    rawlabel_stest <- paste0(rawdir, "test/subject_test.txt")
    rawlabel_feat <- paste0(rawdir, "features.txt")
    
    # Read in raw data and subject/activity labels
    labels_activity <- read.table(rawlabel_activity, header=FALSE, sep=" ",
                                  col.names=c("AID", "ACTIVITY"))
    labels_atrain <- read.table(rawlabel_atrain, header=FALSE, col.names=c("AID"))
    labels_atest <- read.table(rawlabel_atest, header=FALSE, col.names=c("AID"))
    labels_strain <- read.table(rawlabel_strain, header=FALSE, col.names=c("SID"))
    labels_stest <- read.table(rawlabel_stest, header=FALSE, col.names=c("SID"))
    labels_feat <- read.table(rawlabel_feat, header=FALSE, sep=" ", 
                              colClasses="character", stringsAsFactors=FALSE,
                              col.names=c("FID", "FEATURE"))
    # Reads test and training set and labels them with both Subject and Activity
    dtest <- read.table(rawfile_test, colClasses="numeric", stringsAsFactors=FALSE) %>% 
        cbind (SUBJECT=labels_stest$SID, ACTIVITY=labels_atest$AID)
    dtrain <- read.table(rawfile_train, colClasses="numeric", stringsAsFactors=FALSE) %>%
        cbind (SUBJECT=labels_strain$SID, ACTIVITY=labels_atrain$AID)
    
    # Assign feature variable col names
    colnames(dtest) <- c(labels_feat[,2], "SUBJECT" , "ACTIVITY") # labels test set
    colnames(dtrain) <- c(labels_feat[,2], "SUBJECT", "ACTIVITY") # labels train set
    
    # Determine all feature variables that are mu or sigma measurements
    features <- filter(labels_feat, like(FEATURE, "mean|Mean|std"))
    
    # Clean up the feature variable names
    # As suggested in https://class.coursera.org/getdata-011/forum/thread?thread_id=215
    # Clean up problematic symbols to make them safe to use in R
    features$FEATURE <- gsub("\\(", "", features$FEATURE) # removes left paranthesis
    features$FEATURE <- gsub("\\)", "", features$FEATURE) # removes right paranthesis
    features$FEATURE <- gsub("\\-", ".", features$FEATURE) # replace dashes with dots
    # Clean up duplicate feature descriptions
    features$FEATURE <- gsub("BodyBody", "Body", features$FEATURE) # fixes BodyBody
    features$FEATURE <- gsub("MagMag", "Mag", features$FEATURE) # fixes MagMag
    features$FEATURE <- gsub("Mean,", ",", features$FEATURE) 
    features$FEATURE <- gsub(",gravityMean", ".Gravity.Mean", features$FEATURE) # fix ,gravityMean
    features$FEATURE <- gsub(",gravity", ".Gravity.Mean", features$FEATURE) # fix ,gravity EOL
    # Give fuller, more readable feature descriptions
    features$FEATURE <- gsub("BodyAcc", "BodyAcceleration", features$FEATURE)
    features$FEATURE <- gsub("GravityAcc", "GravityAcceleration", features$FEATURE)
    features$FEATURE <- gsub("BodyGyro", "BodyGyroscope", features$FEATURE)
    features$FEATURE <- gsub("Mag", ".Magnitude", features$FEATURE)
    features$FEATURE <- gsub("^t", "Time.", features$FEATURE) # describes t domain
    features$FEATURE <- gsub("^f", "Frequency.", features$FEATURE) # describes f domain
    features$FEATURE <- gsub("anglet", "Time.Angle.", features$FEATURE) # fix angle(t
    features$FEATURE <- gsub("^angle", "Angle.", features$FEATURE) # fix angle
    # Standarizes mean, meanFreq and std to Mean and Standard Deviation
    features$FEATURE <- gsub("mean", "Mean", features$FEATURE)
    features$FEATURE <- gsub("meanFreq", "Mean", features$FEATURE)
    features$FEATURE <- gsub("std", "StandardDeviation", features$FEATURE)
    
    # Merge training (70%) and test sets (30%) into one data set
    # Select/Subset using from the test/training sets using FID (index of feature)
    # rbind the subsets to form the merged data set
    merged <- rbind(subset(dtest,
                           select=c(SUBJECT, ACTIVITY, as.numeric(features$FID))),
                    subset(dtrain,
                           select=c(SUBJECT, ACTIVITY, as.numeric(features$FID)))
                    )
    # Assigns cleaned up feature variable names into merged set
    colnames(merged) <- c("SUBJECT" , "ACTIVITY", features[,2])
    
    # Averages of each feature variable per subject and per activity
    # First group by SUBJECT and ACTIVITY ids
    # Then summarise_each over all groups, excluding SUBECT & ACTIVITY (col 1 & 2)
    # Use descriptive activity names to replace the activity numbers in the data set
    # Finally sort/order the tidy set by SUBJECT then ACTIVITY
    final <- data.table(merged) %>%
        group_by(SUBJECT, ACTIVITY) %>%
        summarise_each(funs(mean(.))) %>%
        mutate(ACTIVITY=labels_activity[ACTIVITY,]["ACTIVITY"]) %>%
        arrange(SUBJECT, ACTIVITY)
    
    # Write out the tidy set
    write.table(final, file="tidy.txt", row.name=FALSE, sep=" ", quote=FALSE)
}