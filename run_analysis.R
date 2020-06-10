#COURSERA\JHU "GETTING AND CLEANING DATA"
#Andrea Contigiani
#June 2020

#########################

#Step 1
#This step merges the training and the test sets to create one data set

#load package "reshape2"
library(reshape2)

#read the datasets necessary to build the final file
features <- read.table("features.txt")
subject_train <- read.table("subject_train.txt")
X_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
subject_test <- read.table("subject_test.txt")
X_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")

#create column names for each file
names(X_train) <- features$V2
names(X_test) <- features$V2
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"
names(y_train) <- "activity"
names(y_test) <- "activity"

#merge files into one file
datatrain <- cbind(subject_train, y_train, X_train)
datatest <- cbind(subject_test, y_test, X_test)
data <- rbind(datatrain, datatest)
dim(data)

#########################

#Step 2
#This step extracts columns containing mean or standard deviation

#identify columns containing mean or standard deviation via regular expression command "grepl" 
vector <- grepl("mean\\(\\)", names(data)) | grepl("std\\(\\)", names(data))

#retain subjectID and activity columns
vector[1] <- TRUE
vector[2] <- TRUE

#build new file with only relevant columns
data2 <- data[, vector]

#########################

#Steps 3\4
#This step labels the data set with descriptive variable names

#replace activity number with activity name
data2$activity <- factor(data2$activity, labels=c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

#########################

#Step 5
#This step creates a new tidy dataset with the average of each variable for each activity and each subject

#reshape the file long by stacking all subjectID\activity observations into one single column
data3 <- melt(data2, id=c("subjectID","activity"))

#calculate mean for each subjectID\activity pair and reshape the file wide
data4 <- dcast(data3, subjectID+activity ~ variable, mean)

#create output file in csv format
write.csv(data4, "output.csv", row.names=FALSE)



