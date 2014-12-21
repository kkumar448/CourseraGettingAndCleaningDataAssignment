CodeBook for data submitted in assignment

The input data had 561 features. Separate files contained the subject ids, and activity codes. Following activities were done on this file using a script (run_analysis.R):

1. Test and Training Data were loaded.
2. The 3 test datasets were combine dinto one, after adding an ID field
3. The 3 training datasets were combine dinto one, after adding an ID field
4. The combined test dataset was appended to the combined training dataset
5. A column for activity label was added to supplement the activity code
6. A smaller dataset, comprising only columns involving means and standard deviations of features was created. This dataset contained 70 columns (id, subject_id, activity_code, activity_label, 33 features for mean, and 33 features for standard deviation)
7. The dataset was melted and averages of the variables calculated grouped by subject_id, activity_label and feature
8. The final output dataset had the following columns:
subject_id: Identifier for the subject in the study
activity_label: label identifying activity (WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS, SLEEPING, STANDING, LAYING)
feature: name of the feature
mean: mean value of the feature for the combination of subject_id and activity_label