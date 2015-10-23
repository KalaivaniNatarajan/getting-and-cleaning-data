This is a description of what my code does.
My script run_analysis.R produces 3 dataframes

1)whole_data:   this dataframe contains all of the training and test data merged
                together.
2)mean_sd_data: this dataframe contains the measurements on the mean and 
                standard deviation for each measured variable in the dataset
				(ie merged whole_data)
3)final_df:     this dataframe is second, independent tidy data set created 
                from whole_data which the average of each variable for each activity 
				and each subject.
				
The variables in these dataframe are separately described in codebook.md
step1:
 a)First I read each of the individual training and testing data files into 
  separate dataframes.
 b)Then i merged all of the related test data(ie activity done, subject who performed 
 and the variables/features measured into one test dataframe) using cbind.
 similarly i created a train dataframe
 c)appropriately naming the subject and activity columns in both the test and
 train dataframe
 
step2:
 Merging together the train and test dataframe using rbind function
 
step3:
  a)extracting columns that measure mean&standard deviation. 
  for this ,first all of the features/variables measured is read into a 
  separate dataframe.
  b)Next using grep to find the occurence of mean&standard deviation in 
  the features list dataframe.
  c)using the result of grep as index I extract the required columns into 
    a new dataframe mean_sd_data.
	
step4:
 appropriately naming the activity labels using factor function.
 
step5:
 approppriately labelling variables in whole_data with descriptive variable 
 names
 a)created a file myname.txt (more details in codebook.md)
 b)using this file for appropriate naming
  --using "_" for separating words
  --complete lowercase letters for all variable names
  --expanded "t" as "time" and "f" as frequency
  
step6:
 finding the average of each variable for each activity and each subject
 a)first split the whole_data based on subject(ie into 30 factor levels)
 b)take the result from above and split again based on activity
 c)compute mean for each variable found in the split data obtained from (b)
 d)repeat step (b)&(c) until all of the 30 factor levels are dealt with.
 e)creating a new dataframe final_df which has the average of each variable for each activity 
 and each subject
 d)writing into a text file as required.