install.packages("plyr")
library("plyr")

##1 Merges the training and the test sets to create one data set.
##import X
path_tst_x <- "C:/Users/Marcel/Desktop/Coursera/Projeto_3/Projeto/UCI HAR Dataset/test/X_test.txt"
path_trn_x <- "C:/Users/Marcel/Desktop/Coursera/Projeto_3/Projeto/UCI HAR Dataset/train/X_train.txt"
data_tst_x <- read.table(path_tst_x, header = FALSE, sep = "")
head(data_tst_x, n=3)
data_trn_x <- read.table(path_trn_x, header = FALSE, sep = "")
head(data_trn_x, n=3)

##import y
path_tst_y <- "C:/Users/Marcel/Desktop/Coursera/Projeto_3/Projeto/UCI HAR Dataset/test/y_test.txt"
path_trn_y <- "C:/Users/Marcel/Desktop/Coursera/Projeto_3/Projeto/UCI HAR Dataset/train/y_train.txt"
data_tst_y <- read.table(path_tst_y, header = FALSE, sep = "")
head(data_tst_y, n=3)
data_trn_y <- read.table(path_trn_y, header = FALSE, sep = "")
head(data_trn_y, n=3)

##import subject
path_tst_sbj <- "C:/Users/Marcel/Desktop/Coursera/Projeto_3/Projeto/UCI HAR Dataset/test/subject_test.txt"
path_trn_sbj <- "C:/Users/Marcel/Desktop/Coursera/Projeto_3/Projeto/UCI HAR Dataset/train/subject_train.txt"
data_tst_sbj <- read.table(path_tst_sbj, header = FALSE, sep = "")
head(data_tst_sbj, n=3)
data_trn_sbj <- read.table(path_trn_sbj, header = FALSE, sep = "")
head(data_trn_sbj, n=3)

#merge - seting train with test data frames
##X
dtx_trn_tst <- rbind(data_tst_x, data_trn_x)

##Y
dty_trn_tst <- rbind(data_tst_y, data_trn_y)
head(dty_trn_tst, n=3)

##subject
dtsbj_trn_tst <- rbind(data_tst_sbj, data_trn_sbj)

##Reading features
path_ftr <- "C:/Users/Marcel/Desktop/Coursera/Projeto_3/Projeto/UCI HAR Dataset/features.txt"
data_ftr <- read.table(path_ftr, header = FALSE, sep = "")
head(data_ftr, n=3)

##correcting names in data table
names(dtx_trn_tst) <-  data_ftr[, 2]
head(dtx_trn_tst, n=3)

##2 Extracts only the measurements on the mean and standard deviation for each measurement. 
##extracting mean or std columns
dtx_mnstd <- dtx_trn_tst[, grep("-(mean|std)\\(\\)", colnames(dtx_trn_tst))]
head(dtx_mnstd, n=3)

##3 Uses descriptive activity names to name the activities in the data set
path_act <- "C:/Users/Marcel/Desktop/Coursera/Projeto_3/Projeto/UCI HAR Dataset/activity_labels.txt"
data_act <- read.table(path_act, header = FALSE, sep = "")
dty_trn_tst_lbl <- merge(dty_trn_tst, data_act, by.x = "V1", by.y = "V1", all = TRUE)
colnames(dty_trn_tst_lbl) <- c("number_activity","activities")

##4 Appropriately labels the data set with descriptive variable names
names(dtsbj_trn_tst) <- "subject"

##puting all data together
data_final <- cbind(dtx_mnstd ,dty_trn_tst_lbl, dtsbj_trn_tst)
head(data_final, n=3)

##5 From the data set in step 4, creates a second, independent tidy data set with the average 
##of each variable for each activity and each subject.
tidy_data <- ddply(data_final, .(subject, activities), function(x) colMeans(x[, 1:66]))
head(tidy_data)
write.table(tidy_data,file = "C:/Users/Marcel/Desktop/Coursera/Projeto_3/Projeto/tidy.txt", row.name = FALSE) 