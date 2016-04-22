

enroll <- function(db_account,db_password,db_edxapp_name,write_db)
  
  {
library(DBI)  
library(RMySQL)  
connection <- dbConnect(MySQL(), user=db_account, password=db_password, dbname=db_edxapp_name, host="localhost") ##connect mysql
connect_write <- dbConnect(MySQL(), user=db_account, password=db_password, dbname=write_db, host="localhost")
auth_userprofile<-dbGetQuery(connection,"SELECT user_id ,year_of_birth,level_of_education,country FROM `auth_userprofile`")

course<-dbGetQuery(connection,"SELECT * FROM `student_courseenrollment` ORDER BY `created` DESC")

course_p<-merge(course,auth_userprofile, by = 'user_id')
course_p$created <- as.Date(course_p$created)
course_p <- course_p[, c(1,3,7,8,9,4)] 
colnames(course_p)[4] <- 'edu'

dbWriteTable(connect_write, "enroll", course_p, overwrite=T,row.names=FALSE)  ##insert err_user
#dbWriteTable(connect_write, "edu_user", course_edu, overwrite=T,row.names=FALSE)  ##insert edu_user

dbDisconnect(connect_write)
dbDisconnect(connection)
}

################
video_check60_r <- function(db_account,db_password,db_edxapp_name,write_db,play_video_SpentTime_csv,watch_time)
  
{
  
  
  library(DBI)  
  library(RMySQL)  
  
  connection <- dbConnect(MySQL(), user=db_account, password=db_password, dbname=db_edxapp_name, host="localhost")
  connect_write <- dbConnect(MySQL(), user=db_account, password=db_password, dbname=write_db, host="localhost")
  auth_userprofile <-dbGetQuery(connection,"SELECT user_id ,year_of_birth,level_of_education,country FROM `auth_userprofile`")
  
  videodata <-read.csv(play_video_SpentTime_csv,encoding = "UTF-8", sep=",")
  
  videodata <- videodata[videodata$watch_time.sec. > watch_time,]
  videodata$time <- as.Date(videodata$time)
  #videodata <-subset(videodata, time >as.Date("2016-2-16") )##時間處理
  
  user_video <-merge(videodata,auth_userprofile, by = 'user_id')
  
  
  video_Freq <- user_video[, c(1,2,4,5,9)] 
  
  
  dbWriteTable(connect_write, "video_Freq", video_Freq, overwrite=T,row.names=FALSE)  ##insert video_Freq
  #dbWriteTable(connect_write, "video_people", video_people, overwrite=T,row.names=FALSE)  ##insert video_people
  
  
  
  
  dbDisconnect(connect_write)
  dbDisconnect(connection) 
}
################


















course_Progress <- function(db_account,db_password,db_edxapp_name,write_db,video_r_address,play_video_SpentTime_csv)
  
{

  source(video_r_address)
  
  
  library(DBI)  
  library(RMySQL)  
  connection <- dbConnect(MySQL(), user=db_account, password=db_password, dbname=db_edxapp_name, host="localhost") ##connect mysql
  connect_write <- dbConnect(MySQL(), user=db_account, password=db_password, dbname=write_db, host="localhost") ##write mysql
  
  course <- dbGetQuery(connect_write, "SELECT course_id FROM `video_freq` ORDER BY `course_id` ASC") 
  course[, c(1)]->course 
  course_id <- unique(course)
  
  playVideo <- read.csv(play_video_SpentTime_csv, stringsAsFactors = F)  
  playVideo <- playVideo[playVideo$watch_time.sec. > 60,]
  playVideo$time <- as.Date(playVideo$time)
  #playVideo <-subset(playVideo, time >as.Date("2016-2-16") )##時間處理
  colnames(playVideo)[4] <- 'code'
  playVideo <- playVideo[, c(1,2,4)]
  
  playVideo$user_id <- as.character(playVideo$user_id)
  
  up <- auth_userprofile <-dbGetQuery(connection,"SELECT user_id ,year_of_birth,level_of_education,country FROM `auth_userprofile`")
  
  
  
  #up <- read.csv('D:/log/csv/userprofile.csv', stringsAsFactors = F)
  #up<-up[up$country != "" ,] 
  #up<-up[up$level_of_education != "" ,] 
  
  up[, c(1,4)] -> up
  
  up$user_id <- as.character(up$user_id)
  
  x<-length(course_id)
  for (i in 1: x)
  {
    print(course_id[i])
    CourseData <- CourseView(course_id[i], playVideo)
    
    
    watchOver50 <- UserViewsOverNum(CourseData, 0.5, 24, up)
    watchOver75 <- UserViewsOverNum(CourseData, 0.75, 24, up)
    
    
    mysqlwatch50 <- cbind(course_id[i],watchOver50)
    colnames(mysqlwatch50)[1] <- 'course_id'
    
    
    
    mysqlwatch75 <- cbind(course_id[i],watchOver75)
    colnames(mysqlwatch75)[1] <- 'course_id'
    
    
    
    dbWriteTable(connect_write, "course_watch50", mysqlwatch50 ,row.names=FALSE,append=TRUE) 
    dbWriteTable(connect_write, "course_watch75",  mysqlwatch75 ,row.names=FALSE,append=TRUE)
    
    
    
    
  }
  dbDisconnect(connect_write)
  dbDisconnect(connection)
}



##fincourse
fin <- function(db_account,db_password,db_edxapp_name,write_db)
  
{


library(DBI)
library(RMySQL)  

connection <- dbConnect(MySQL(), user=db_account, password=db_password, dbname=db_edxapp_name, host="localhost") ##connect mysql
connect_write <- dbConnect(MySQL(), user=db_account, password=db_password, dbname=write_db, host="localhost") ##write mysql

auth_userprofile <- dbGetQuery(connection,"SELECT user_id ,year_of_birth,level_of_education,country FROM `auth_userprofile`")
auth_user <- dbGetQuery(connection,"SELECT id,email FROM `auth_user`")
colnames(auth_user)[1] <- 'user_id'

user_userprofile <-  merge(auth_user ,auth_userprofile, by = 'user_id')


pass_student <- dbGetQuery(connect_write,"SELECT cid,email FROM `pass_student`")
fin_course <- dbGetQuery(connect_write,"SELECT cid,course_id FROM `fin_course`")

student_course <- merge(fin_course ,pass_student, by = 'cid')
dbWriteTable(connect_write, "student_course", student_course, overwrite=T,row.names=FALSE) 


course_id<- student_course$course_id


course_id<-unique(course_id)
x<-length(course_id)
for (i in 1: x)
{
  
 
  sql <- 'SELECT e.id,e.email,d.course_id FROM edxapp.auth_user e right join '
 
  mn <-' .student_course d ON e.email = d.email WHERE d.course_id ='
  
   course_sql<-course_id[i]
  post<-paste(sql,write_db,mn,"'",course_sql,"'",sep='')
  users = dbGetQuery(connect_write,post)
  colnames(users)[1] <- 'user_id'
  pass_list<-merge(auth_userprofile,users, by = 'user_id')
  pass_list <- pass_list[, c(6,1,4)] 
  dbWriteTable(connect_write, "fin_pass_country", pass_list,row.names=FALSE,append=TRUE) 
  
}

}

#problem
problem <- function(db_account,db_password,db_edxapp_name,write_db,server_problem_check_csv)
  
{

library(DBI)  
library(RMySQL)  
connection <- dbConnect(MySQL(), user=db_account, password=db_password, dbname=db_edxapp_name, host="localhost")
connect_write <- dbConnect(MySQL(), user=db_account, password=db_password, dbname=write_db, host="localhost")

auth_userprofile <-dbGetQuery(connection,"SELECT user_id ,year_of_birth,level_of_education,country FROM `auth_userprofile`")


data<-read.table(server_problem_check_csv, header=TRUE, sep=",") #server_problem_check.csv
colnames(data)[1] <- 'username'
colnames(data)[2] <- 'host'
colnames(data)[3] <- 'type'
colnames(data)[4] <- 'user_id'
colnames(data)[5] <- 'course_id'
colnames(data)[6] <- 'time'
data <- data[data$host == "courses.openedu.tw" ,] #host=openedu
data2 <- data[, c(5,4,6)] 
data2$time <- as.Date(data2$time)
data2 <-subset(data2, time < as.Date("2016-2-17") )

data3<-read.table("D:/log/code/sum/online/csv/server_problem_check.csv", header=TRUE, sep=",")
colnames(data3)[1] <- 'username'
colnames(data3)[2] <- 'host'
colnames(data3)[3] <- 'type'
colnames(data3)[4] <- 'user_id'
colnames(data3)[5] <- 'course_id'
colnames(data3)[6] <- 'time'
data3 <- data3[data3$host == "courses.openedu.tw" ,] #host=openedu
data3 <- data3[, c(5,4,6)] 
data3$time <- as.Date(data3$time)

a<-rbind(data2,data3)
a <-merge(a,auth_userprofile, by = 'user_id')
a <- a[, c(2,1,6,3)] 


dbWriteTable(connect_write, "problem", a, overwrite=T,row.names=FALSE) #insert time_sum

dbDisconnect(connect_write)
dbDisconnect(connection) 

}


contents <- function(db_account,db_password,db_edxapp_name,write_db,contents_csv)

{

library(DBI)  
library(RMySQL)  
connection <- dbConnect(MySQL(), user=db_account, password=db_password, dbname=db_edxapp_name, host="localhost") ##connect mysql
connect_write <- dbConnect(MySQL(), user=db_account, password=db_password, dbname=write_db, host="localhost") ##write mysql

auth_userprofile<-dbGetQuery(connection,"SELECT user_id ,year_of_birth,level_of_education,country FROM `auth_userprofile`")

data<-read.table(contents_csv, header=TRUE, sep=",")
colnames(data)[3] <- 'user_id'


comment<-merge(data,auth_userprofile, by = 'user_id')
comment <- comment[, c(2,1,3,7,4)] 

colnames(comment)[1] <- 'course_id'
colnames(comment)[3] <- 'type'
colnames(comment)[5] <- 'created'
comment$created <- as.Date(comment$created)


dbWriteTable(connect_write, "comment", comment, overwrite=T,row.names=FALSE)  ##insert err_user

dbDisconnect(connect_write)
dbDisconnect(connection)

}

user_watch <- function(db_account,db_password,db_edxapp_name,write_db)
{
  
  library(DBI)  
  library(RMySQL)
  
  
  connection <- dbConnect(MySQL(), user=db_account, password=db_password, dbname=db_edxapp_name, host="localhost") ##connect mysql
  connect_write <- dbConnect(MySQL(), user=db_account, password=db_password, dbname=write_db, host="localhost")
  
  auth_userprofile <- dbGetQuery(connection,"SELECT id,email FROM `auth_user`")
  colnames(auth_userprofile)[1] <- 'user_id'
  
  video_freq <- dbGetQuery(connect_write,"SELECT * FROM `video_freq`")
  video_freq  <- video_freq[, c(1,2,3)] 
  course <- video_freq[, c(2)]
  course <-unique(course )
  x<-length(course)
  for (i in 1: x)
  {
    print(course[i])
    mysql_course <- video_freq[video_freq$course_id == course[i] ,] 
    
    
    mysql_course <- as.data.frame(table(mysql_course))
    mysql_course <- mysql_course[mysql_course$Freq > 0,]
    
    
    mysql_course<-merge(auth_userprofile,mysql_course, by = 'user_id')
    
    
    dbWriteTable(connect_write, "user_watch",  mysql_course ,row.names=FALSE,append=TRUE)
  }
  
  
  
  
  dbDisconnect(connect_write)
  dbDisconnect(connection) 
  
}

