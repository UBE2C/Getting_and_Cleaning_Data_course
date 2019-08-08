##First of all "Hello!" :). I hope you will find this script to be properly written and understandable.
##I will try my best to make it to be.


##To properly run the analysis script, you will need to have "tidyverse" installed and loaded
##as some of the steps require both the"dplyr" and "stringr" packages (both are part of "tidyverse")
library(tidyverse)


##This section will read in the two datasets (X_test.txt and X_train.txt) using the standard read.table
##function. Next the tbl_df function will convert the resulting dataframes to tibbles, as I prefer to work
##over standard dataframes
x_test <- read.table("UCI_HAR_Dataset/test/X_test.txt", sep = "", stringsAsFactors = FALSE)
x_test <- tbl_df(x_test)
x_train <- read.table("UCI_HAR_Dataset/train/X_train.txt", sep = "", stringsAsFactors = FALSE)
x_train <- tbl_df(x_train)


##This line will combine the two datasets by simply attaching the x_train df to the x_test df, 
##creating a new x_joined df.
##To preserve the clarity about which observation belongs to which dataset I attached an id variable
##marking the x_test df as "1" and the x_train df as "2".
x_joined <- bind_rows(x_test, x_train, .id = c("Dataframe_id"))


##This piece will read in the features.txt in order to gain excess to the variable names.
##In order to subset the data on the mean and std variables I used grep to identify the position of
##all the variables containing mean or std in their names, then used these to subset x_joined 
##creating the new x_subset df.
col_names <- readLines("UCI_HAR_Dataset/features.txt")
mean_cols <- grep("[Mm]ean", col_names)
std_cols <- grep("std", col_names)
mean_std_cols <- c(mean_cols, std_cols)
fitted_col_names <- mean_std_cols + 1 ##Note: here I increased the position numbers by 1, as my 1st position is occupied by the new Dataframe_id variable.
x_subset <- x_joined[, c(1, fitted_col_names)]


##In this section I modified the original colnames a bit (although I find them reasonably descriptive) by expanding
##the time and frequency markings a bit, and by removing the numbers as I find them unnecessary.
##Finally, I attached the new colnames to x_subset to get clear variable names over the previous V1, 2, 3.... names.
col_names_subset <- c("Dataframe_id", col_names[mean_std_cols])
col_names_subset <- str_replace_all(col_names_subset, c("tB" = "timeB", "tG" = "timeG",
                                                        "fB" = "freqB", "fG" = "freqG",
                                                        "^[0-9]+" = "", "^[0-9]++" = ""))
colnames(x_subset) <- col_names_subset


##These lines are intended to remove some of the variables which are calculated separately using the mean values and the freqMean() variables as they are
##separate from the mean() variables
angles <- grep("angle", names(x_subset))
x_subset <- x_subset[, -c(angles)]
meanfreq <- grep("meanFreq()", names(x_subset))
x_subset <- x_subset[, -c(meanfreq)]


##First, this piece of code attempts to read in the code for the activities (both for the test and train data) then replacing
##the numbers with the appropriate activity names (for the sake of clarity) and it combines the activities from the
##test and train datasets (like in the cas of the dataframes).
##Second, it reads in the test subject codes for both test and train datasets and merges them just like before. This way both
##activity and patient codes can be aded to the main data as new variables.
activity_code_test <- readLines("UCI_HAR_Dataset/test/Y_test.txt")
activity_code_train <- readLines("UCI_HAR_Dataset/train/Y_train.txt")
activity_test <- str_replace_all(activity_code_test, c("1" = "walking", "2" = "walking_upst.", "3" = "walking_downst.",
                                                       "4" = "sitting", "5" = "standing", "6" = "laying"))
activity_train <- str_replace_all(activity_code_train, c("1" = "walking", "2" = "walking_upst.", "3" = "walking_downst.",
                                                         "4" = "sitting", "5" = "standing", "6" = "laying"))
activity_joined <- c(activity_test, activity_train)
subject_code_test <- readLines("UCI_HAR_Dataset/test/subject_test.txt")
subject_code_train <- readLines("UCI_HAR_Dataset/train/subject_train.txt")
subject_code_joined <- c(subject_code_test, subject_code_train)


##This code creates two new variables (Subject_id and Activity) using the subject and activity data from the previous step
##and places them after the Dataframe_id column in the x_subset df so one can associate the activity and the
#subject who performed it, with the measurments.  
x_subset <- x_subset %>%
  add_column(Subject_id = subject_code_joined, .after = 1) %>%
  add_column(Activity = activity_joined, .after = 2)


##In order for the Dataframe_id and Subject_id to be orderd properly during the next step, this code changes the classes of these
##variables from "character" to "numeric".
x_subset$Dataframe_id <- as.numeric(x_subset$Dataframe_id)
x_subset$Subject_id <- as.numeric(x_subset$Subject_id)


##This piece of the code groups the Dataframe_id, Subject_id and activity variables together and calculates the mean
##of all the other variables, while re-ordering the resulting dataframe
tidy_x <- x_subset %>% 
  group_by(Dataframe_id, Subject_id, Activity) %>%
  summarise_all(mean)


##The code below attempts to "pretyfy" the resulting dataframe a bit by changing the format of the measurements to a scientific format
##which is shorter then the standard numerical format
for(e in 4:ncol(tidy_x)) {
  tidy_x[, e] <- formatC(tidy_x[[e]], format = "e")
}
View(tidy_x)

##The final line of code saves the tidy_x datafram as a tab delimited txt. 
##Note: A really important thing here is that when you read this txt in, you have to use the sep = "\t".
write.table(tidy_x, file = "tidy_x.txt", sep = "\t", row.names = FALSE)









