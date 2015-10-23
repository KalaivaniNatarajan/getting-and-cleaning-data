library(data.table)

##reading training data
train_sub<-read.table(file="train/subject_train.txt")
train_x<-data.frame(fread(input="train/X_train.txt"))
train_y<-data.frame(fread(input="train/Y_train.txt"))

##reading test data

test_sub<-read.table(file="test/subject_test.txt")
test_x<-data.frame(fread(input="test/X_test.txt"))
test_y<-data.frame(fread(input="test/Y_test.txt"))

##creating variable names for person(subject) and activity

names(test_sub)<-c("person_id")
names(train_sub)<-c("person_id")
names(test_y)<-c("activity")
names(train_y)<-c("activity")


##merging training data into 1 dataset
train_data<-cbind(train_sub,train_y)
train_data<-cbind(train_data,train_x)

##merging test data into 1 dataset
test_data<-cbind(test_sub,test_y)
test_data<-cbind(test_data,test_x)

##merging training and test data into 1 dataset
whole_data<-rbind(train_data,test_data)


##reading features list
features_list<-read.table(file="C:/Data/Data Science/assignment/G&C data/features.txt",stringsAsFactors = FALSE)
names(features_list)<-c("number","measurements_name")

##extracting ids of mean and standard deviation
mean<-grep("mean",features_list$measurements_name)
std<-grep("std",features_list$measurements_name)
index<-c(mean,std)

##since i have added subject and activity labels as first 2 columns
## in my data, I am adding 2 to the index vector computed above to extraxt the 
## column numbers of mean and standard deviation
index<-index+c(2)
index<-sort(index)


##extracting values of mean and standard deviation on all variables
##from whole data

mean_sd_data<-whole_data[,index]
 
## naming the activities using descriptive label names
whole_data$activity<-factor(whole_data$activity,levels=1:6,labels = c("walking","walking_up","walking_down","sitting","standing","laying"))

##descriptive variable names
##I have created a myname.txt file to enable the conversion of features into 
##more descriptive one. This new file contains 2 columns.1-actual feature name
##2-the name i chose

m_name<-as.character(features_list$measurements_name)
name_file<-read.table(file="C:/Data/Data Science/assignment/G&C data/myname.txt",sep=";",header=TRUE,stringsAsFactors = FALSE)
temp<-vector(length=3,mode="character")
desc_name<-vector(length=length(m_name),mode="character")

##I am splitting the original features names based on the occurence of this string "-"
for(i in 1:length(m_name))
{
  split_list<-strsplit(m_name[i],"-")
  split_vector<-split_list[[1]]
  found_any<-any(name_file$given_name==split_vector[1])
  found<-which(name_file$given_name==split_vector[1])
  if(found_any)
    temp[1]<-name_file$my_name[found]
  if(length(split_vector)==1)
    desc_name[i]<-temp[1]
  if(length(split_vector)==2)
  {
    len<-nchar(split_vector[2])-2
    temp[2]<-tolower(substr(split_vector[2],1,len))
    desc_name[i]<-paste(temp[1],temp[2],sep="_")
  }
  if(length(split_vector)==3)
  {
    len<-nchar(split_vector[2])-2
    temp[2]<-tolower(substr(split_vector[2],1,len))
    temp[3]<-tolower(split_vector[3])
    desc_name[i]<-paste(temp[1],temp[2],temp[3],sep="_")
  }
}

##since i have already created 2 column names of person and activity ,I 
## merging them with the desc_name vector I created above
var_name<-c("person_id","activity")
colnames(whole_data)<-c(var_name,desc_name)


##### finding the avg for each variable for each subject and each activity
##first i split data based on person
##then i split the result obtained based on activity
### finally i calclualte mean for each variable and activity
x<-split(whole_data,whole_data$person_id)
k<-0
for(i in 1:length(x))
{
  temp<-data.frame(x[i])
  colnames(temp)<-colnames(whole_data)
  y<-split(temp,temp$activity)
  for(j in 1:length(y))
  { k<-k+1
  temp2<-data.frame(y[j])
  colnames(temp2)<-colnames(whole_data)
  temp3<-data.frame(temp2[,3:563])
  mean_vec<-sapply(temp3,mean)
  if(i==1 & j==1)
  {
    final_df<-data.frame()
    final_df<-rbind(mean_vec)
    
  }
  else
  {
    final_df<-rbind(final_df,mean_vec)
  }
  
  }
  
}
var_name<-rep(names(y),times=length(x))
var_id<-rep(names(x),each=length(y))
final_df<-cbind(cbind(var_id,var_name),final_df)
int<-1:180
final_df<-data.frame(final_df,row.names=int)

colnames(final_df)<-colnames(whole_data)
write.table(x=final_df,file="avg_result.txt",sep=" ",quote=FALSE,row.names=FALSE)



