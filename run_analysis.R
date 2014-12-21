run_analysis<-function (){

	library("plyr")
	library("reshape2")
	# load activity labels
	activityLabels<-load_data("UCI HAR Dataset/activity_labels.txt", c("activity_code", "activity_label"))
	print ("Loaded Activity Labels")

	# load feature names
	featureNames<-load_data("UCI HAR Dataset/features.txt", c("feature_id", "feature_name"))
	print ("Loaded Feature Names")

	# Load Training Activities
	trainingActivities<-load_data("UCI HAR Dataset/train/y_train.txt", c("activity_code"))
	print ("Loaded Training Activities")

	# Load Training Subjects
	trainingSubjects<-load_data("UCI HAR Dataset/train/subject_train.txt", c("subject_id"))
	print ("Loaded Training Subjects")

	# Load Training Data
	trainingData<-load_data("UCI HAR Dataset/train/x_train.txt", as.character(featureNames$feature_name))
	print ("Loaded Training Data")

	# Load Test Activities
	testActivities<-load_data("UCI HAR Dataset/test/y_test.txt", c("activity_code"))
	print ("Loaded Test Activities")

	# Load Test Subjects
	testSubjects<-load_data("UCI HAR Dataset/test/subject_test.txt", c("subject_id"))
	print ("Loaded Test Subjects")

	# Load Test Data
	testData<-load_data("UCI HAR Dataset/test/x_test.txt", as.character(featureNames$feature_name))
	print ("Loaded Test Data")

	# add ids to all data frames (required for merge)
	trainingSubjects<-add_ids(trainingSubjects)
	trainingActivities<-add_ids(trainingActivities)
	trainingData<-add_ids(trainingData)
	
	testSubjects<-add_ids(testSubjects)
	testActivities<-add_ids(testActivities)
	testData<-add_ids(testData)

	# merge 3 training data frames together
	mergedTrainingData<-merge_data(trainingSubjects, trainingActivities, trainingData)

	# merge 3 test data frames together
	mergedTestData<-merge_data(testSubjects, testActivities, testData)

	# append training data to test data
	mergedData<-append_datasets(mergedTrainingData, mergedTestData)

	# get restricted features from data
	restrictedMergedData<-get_restricted_features(mergedData, featureNames)

	# merge with activity labels
	restrictedMergedDataWithActivityLabels<-merge_activity_labels(restrictedMergedData)
	
	# rename columns
	finalRawData<-replace_variable_names(restrictedMergedDataWithActivityLabels)

	# summarize
	output<-summarize(finalRawData)
	output

	# export to file
	
}

load_data<-function(filename, colNames){
	# read data
	data<-read.csv(filename, sep="", header=F, col.names=colNames)
	print (nrow(data))
	data

}

add_ids<-function(data){
	data$id<-c(1:nrow(data))
	data
}

merge_data<-function(subjects, activities, data){
	dfs<-list (subjects, activities, data)
	mergedData<-join_all(dfs)
	mergedData
}

append_datasets<-function(mergedTrainingData, mergedTestData){
	mergedData<-rbind (mergedTrainingData, mergedTestData)
	# renumber ids for cleanliness
	mergedData$id<-c(1:nrow(mergedData))
	mergedData
}

get_restricted_features<-function(mergedData, featureNames){
	meanFeatures<-featureNames[grep("mean()", featureNames$feature_name, fixed=T), c("feature_name")]
	stdFeatures<-featureNames[grep("std()", featureNames$feature_name, fixed=T), c("feature_name")]
	additionalFeatures<-c("id", "subject_id", "activity_code")
	featureList<-append(additionalFeatures, as.character(meanFeatures))
	featureList<-append(featureList, as.character(stdFeatures))
	featureList<-make.names(featureList)
	mergedData[,featureList]
}

merge_activity_labels<-function(restrictedMergedData){
	merge(activityLabels, restrictedMergedData, full=T)
}

replace_variable_names<-function(data){
	names(data)<-gsub("tBodyAcc.mean...", "Mean of Time Dimension Body Acceleration - ", names(data))
	names(data)<-gsub("tGravityAcc.mean...", "Mean of Time Dimension Gravity Acceleration - ", names(data))
	names(data)<-gsub("tBodyAccJerk.mean...", "Mean of Time Dimension Body Acceleration Jerk - ", names(data))
	names(data)<-gsub("tBodyGyro.mean...", "Mean of Time Dimension Body Gyroscope - ", names(data))
	names(data)<-gsub("tBodyGyroJerk.mean...", "Mean of Time Dimension Body Gyroscope Jerk - ", names(data))
	names(data)<-gsub("tBodyAccMag.mean..", "Mean of Time Dimension Body Acceleration Magnitude", names(data))
	names(data)<-gsub("tGravityAccMag.mean..", "Mean of Time Dimension Gravity Acceleration Magnitude", names(data))
	names(data)<-gsub("tBodyAccJerkMag.mean..", "Mean of Time Dimension Body Acceleration Jerk Magnitude", names(data))
	names(data)<-gsub("tBodyGyroMag.mean..", "Mean of Time Dimension Body Gyroscope Magnitude", names(data))
	names(data)<-gsub("tBodyGyroJerkMag.mean..", "Mean of Time Dimension Body Gyroscope Jerk Magnitude", names(data))
	names(data)<-gsub("fBodyAcc.mean...", "Mean of Frequency Dimension Body Acceleration - ", names(data))
	names(data)<-gsub("fBodyAccJerk.mean...", "Mean of Frequency Dimension Body Acceleration Jerk - ", names(data))
	names(data)<-gsub("fBodyGyro.mean...", "Mean of Frequency Dimension Body Gyroscope - ", names(data))
	names(data)<-gsub("fBodyAccMag.mean..", "Mean of Frequency Dimension Body Acceleration Magnitude", names(data))
	names(data)<-gsub("fBodyAccJerkMag.mean..", "Mean of Frequency Dimension Body Acceleration Jerk Magnitude", names(data))
	names(data)<-gsub("fBodyGyroMag.mean..", "Mean of Frequency Dimension Body Gyroscope Magnitude", names(data))
	names(data)<-gsub("fBodyGyroJerkMag.mean..", "Mean of Frequency Dimension Body Gyroscope Jerk Magnitude", names(data))
	names(data)<-gsub("fBodyBodyAccJerkMag.mean..", "Mean of Frequency Dimension Body Body Acceleration Jerk Magnitude", names(data))
	names(data)<-gsub("fBodyBodyGyroMag.mean..", "Mean of Frequency Dimension Body Body Gyroscope Magnitude", names(data))
	names(data)<-gsub("fBodyBodyGyroJerkMag.mean..", "Mean of Frequency Dimension Body Body Gyroscope Jerk Magnitude", names(data))

	names(data)<-gsub("tBodyAcc.std...", "Standard Deviation of Time Dimension Body Acceleration - ", names(data))
	names(data)<-gsub("tGravityAcc.std...", "Standard Deviation of Time Dimension Gravity Acceleration - ", names(data))
	names(data)<-gsub("tBodyAccJerk.std...", "Standard Deviation of Time Dimension Body Acceleration Jerk - ", names(data))
	names(data)<-gsub("tBodyGyro.std...", "Standard Deviation of Time Dimension Body Gyroscope - ", names(data))
	names(data)<-gsub("tBodyGyroJerk.std...", "Standard Deviation of Time Dimension Body Gyroscope Jerk - ", names(data))
	names(data)<-gsub("tBodyAccMag.std..", "Standard Deviation of Time Dimension Body Acceleration Magnitude", names(data))
	names(data)<-gsub("tGravityAccMag.std..", "Standard Deviation of Time Dimension Gravity Acceleration Magnitude", names(data))
	names(data)<-gsub("tBodyAccJerkMag.std..", "Standard Deviation of Time Dimension Body Acceleration Jerk Magnitude", names(data))
	names(data)<-gsub("tBodyGyroMag.std..", "Standard Deviation of Time Dimension Body Gyroscope Magnitude", names(data))
	names(data)<-gsub("tBodyGyroJerkMag.std..", "Standard Deviation of Time Dimension Body Gyroscope Jerk Magnitude", names(data))
	names(data)<-gsub("fBodyAcc.std...", "Standard Deviation of Frequency Dimension Body Acceleration - ", names(data))
	names(data)<-gsub("fBodyAccJerk.std...", "Standard Deviation of Frequency Dimension Body Acceleration Jerk - ", names(data))
	names(data)<-gsub("fBodyGyro.std...", "Standard Deviation of Frequency Dimension Body Gyroscope - ", names(data))
	names(data)<-gsub("fBodyAccMag.std..", "Standard Deviation of Frequency Dimension Body Acceleration Magnitude", names(data))
	names(data)<-gsub("fBodyAccJerkMag.std..", "Standard Deviation of Frequency Dimension Body Acceleration Jerk Magnitude", names(data))
	names(data)<-gsub("fBodyBodyAccJerkMag.std..", "Standard Deviation of Frequency Dimension Body Body Acceleration Jerk Magnitude", names(data))
	names(data)<-gsub("fBodyBodyGyroMag.std..", "Standard Deviation of Frequency Dimension Body Body Gyroscope Magnitude", names(data))
	names(data)<-gsub("fBodyBodyGyroJerkMag.std..", "Standard Deviation of Frequency Dimension Body Body Gyroscope Jerk Magnitude", names(data))

	data
}

summarize<-function(data){
	meltedData<-melt(data, id=c("subject_id", "activity_label"), measure.vars=names(data)[5:length(names(data))])
	output<-aggregate(meltedData$value, by=list(meltedData$subject_id, meltedData$activity_label, meltedData$variable), FUN=mean)
	names(output)<-c("subject_id", "activity_label", "feature", "mean") 
	output
}