CourseraGettingAndCleaningDataAssignment
========================================

Course Assignment for Coursera Course on Getting And Cleaning Data

Assumption: the data are stored in a folder called "UCI HAR Dataset" in the working directory

The run_analysis script contains a function called run_analysis, which does the following:

1. Calls function load_data, for each of the following files - 
./UCI HAR Dataset/activity_labels.txt, 
./UCI HAR Dataset/features.txt,
./UCI HAR Dataset/test/subject_test.txt,
./UCI HAR Dataset/test/x_test.txt,
./UCI HAR Dataset/test/y_test.txt,
./UCI HAR Dataset/train/subject_train.txt,
./UCI HAR Dataset/train/x_train.txt,
./UCI HAR Dataset/train/y_train.txt

2. Calls function add_ids for each dataset - this function adds an auto-counter ID column to each of the datasets, to enable merge

3. calls function merge_data with the training datasets as inputs, to merge the 3 training datasets (activities, subjects, features) together

4. calls function merge_data with the test datasets as inputs, to merge the 3 test datasets (activities, subjects, features) together

5. calls function append_datasets to append the training and test datasets together

6. calls function get_restricted_features - this function gets a subset of data, for the columns which involve mean() or std()

7. calls function merge_activity_labels - this adds a column for activity labels corresponding to the activity codes

8. calls function summarize - this melts the data, and summarizes it, so that there is one row per combination of subject_id, activity_label and feature, and calculates the mean of the corresponding feature value

9. calls function export_to_file, which exports the data to the output text file