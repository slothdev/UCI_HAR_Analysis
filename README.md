---
title: "README: R Analysis of UCI Human Activity Recognition Smartphone Signal Data"
author: "Edwin Seah"
date: "22 February 2015"
output: html_document
---

***

> Introduction


This readme documents the files and processes used in the analysis of the UCI Human Activity Recognition data collected from Samsung smartphones in the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

There is only one script **run_analysis.R** used, which calls one main function `run_analysis()` with no arguments. To run, save the script in any directory, source it and call `run_analysis()`.

***

> Getting the required files  

1.  ```run_analysis()``` firsts retrieves the data from the [Original Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) if it is not already in the script working directory, and unzips it when it is.

2.  The required files are then read in from the dataset by `run_analysis()`. Since means are to be calculated for all Mean and Standard Deviation mesaurements for every subject and actvity, eight raw files are required for this analysis as follows:  

    Filename             | Description
    -------------------- | -----------
    features.txt         | Listing of all 561 feature variables.
    activity_labels.txt  | Links integer class labels to their activity name. Total of 6 activities.
    X_train.txt          | Training set containing 7352 observations of 561 feature variables.
    y_train.txt          | Identifies activity performed for each of 7352 observations in training set.
    X_test.txt           | Test set containing 2947 observations of 561 feature variables.
    y_test.txt           | Identifies activity performed for each of 2947 observations in test set.
    subject_train.txt    | Identifies subject for each of 7352 observations in train set. 
    subject_test.txt     | Identifies subject for each of 2947 observations in test set.

***

> Merging the test and training sets to create one data set. 

3.  All files are read in using `read.table()` since none of the required files have headers and are simply space-delimited. For the feature variable file we need to store it with an index number so that we can use it to select for the needed feature variables later. This is done by assigning each row number to a column called "FID", like so:
    ```
    # Reading in features.txt (labelled "rawlabel_feat") into labels_feat data frame
    labels_feat <- read.table(rawlabel_feat, header=FALSE, sep=" ", 
                              colClasses="character", stringsAsFactors=FALSE, 
                              col.names=c("FID", "FEATURE"))
    ```
    + After reading in the test and training sets, we then `cbind()` Subject and Activity onto their respective sets. We can do this for both sets as the number of measurements and subject/activity  are identical.
    ```
    # Example for the test set, same for the training set
    # where rawfile_test = "X_test.txt"", labels_stest = "subject_test.txt", labels_atest = "y_test.txt"
    dtest <- read.table(rawfile_test, colClasses="numeric", stringsAsFactors=FALSE) %>% 
    cbind (SUBJECT=labels_stest$SID, ACTIVITY=labels_atest$AID)
    ```
    + We will assign the appropriate column names for both to maintain consistency before merging.
    ```
    # Assigning feature variable col names to test set
    colnames(dtest) <- c(labels_feat[,2], "SUBJECT" , "ACTIVITY") # labels test set
    colnames(dtrain) <- c(labels_feat[,2], "SUBJECT", "ACTIVITY") # labels train set
    ```
    + For memory efficiency we only want to merge the test and train sets on the required measurements, therefore we first filter out the ones that we need using ```filter()``` from ```dplyr```.
    ```
    # Determine all feature variables that are mu or sigma measurements
    features <- filter(labels_feat, like(FEATURE, "mean|Mean|std"))
    ```

    4.  Since the feature variables are not clean and hard to read, we also need to scrub them for duplicates and illegal symbols such as parantheses or dashes using ```gsub()```. Some guidelines for this scrubbing were followed as per this [Coursera discussion forum thread](https://class.coursera.org/getdata-011/forum/thread?thread_id=215), including expanding the frequency and time domain descriptors and removing inaccurate duplicates such as "BodyBody". A series of ```gsub()``` calls are made:

    ```
    # Clean up problematic symbols to make them safe to use in R
    features$FEATURE <- gsub("\\(", "", features$FEATURE) # removes left paranthesis
    ...
    # Clean up duplicate feature descriptions
    features$FEATURE <- gsub("MagMag", "Mag", features$FEATURE) # fixes MagMag
    ...
    # Give fuller, more readable feature descriptions
    features$FEATURE <- gsub("BodyAcc", "BodyAcceleration", features$FEATURE)
    ...
    # Standarizes mean, meanFreq and std to Mean and Standard Deviation
    features$FEATURE <- gsub("mean", "Mean", features$FEATURE)
    ...
    ```

    5.  We can finally merge the test and train sets into one using ```rbind()``` to join the subsetted features (which is a 10299 x 86 frame) instead of first joining the sets then selecting for the required feature variables which would involve using a 10299 x 561 frame. We also relabel the column names after joining to end up with a 10299 x 88 frame (including the 2 columns for Subject and Activity) with the proper order of columns Subject, Activity, Var1, Var2... VarX.

```
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
```


***


> Summarising the data to obtain the tidy data set


6.  To get the averages for each of the required feature variable measurements per subject and activity, the merged data set is first grouped by Subject and Activity. Then `summarise_each()` from ```dplyr``` is used to conveniently obtain the mean of each grouping of Subject-Activity-Variable (but excluding the Subject and Activity columns 1 and 2). We apply a ```mutate()``` to replace activity labels with descriptive activity names from "activity_labels.txt". ```dplyr``` allows us to do this handily using pipelines:

```
final <- data.table(merged) %>% 
    group_by(SUBJECT, ACTIVITY) %>% 
    summarise_each(funs(mean(.))) %>%
    mutate(ACTIVITY=labels_activity[ACTIVITY,]["ACTIVITY"]) %>%
    arrange(SUBJECT, ACTIVITY)
```


7. At this point the resultant final data set is of the **wide-form** tidy data set of with dimensions 180 x 88, sorted by Subject then Activity. While there have been many discussions over which is the "better" tidy form in these threads [Tidy Data and the Assignment](https://class.coursera.org/getdata-011/forum/thread?thread_id=248),  
[Tidy data vs. third normal form: Why invent what already exists?](https://class.coursera.org/getdata-011/forum/thread?thread_id=82), [3D Data Frame?](https://class.coursera.org/getdata-011/forum/thread?thread_id=161), ultimately since the feature variables are signal measurements for every Subject-Activity the wide-form comprising one observation of (a mean of measurements) for EVERY Subject-Activity will satisfy the tidy data set requirement. 


***


> References and Links


A list of the Github repo containing the script and other files for this analysis, and links to the original UCI study and Coursera discussion threads on codebooks, tidy data as follows:

* [Github repo containing this script run_analysis.R, codebook and README.md](https://github.com/slothdev/UCI_HAR_Analysis)
* [Human Activity Recognition Using Smartphones Study website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
* [UCI HAR Original Study Paper](https://www.elen.ucl.ac.be/Proceedings/esann/esannpdf/es2013-84.pdf)
* [UCI HAR Dataset used for this analysis](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
* [David's Course Project FAQ](https://class.coursera.org/getdata-011/forum/thread?thread_id=69)
* [Discussion on Tidy Data and the Assignment](https://class.coursera.org/getdata-011/forum/thread?thread_id=248)
* [Discussion on Codebook](https://class.coursera.org/getdata-011/forum/thread?thread_id=249)
* [Discussion on Any standard format for codebook?](https://class.coursera.org/getdata-011/forum/thread?thread_id=204)


***