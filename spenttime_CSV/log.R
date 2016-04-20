library(rjson)
library(dplyr)


source('D:/log/code/GeneralFunction.R')

filePath<-'D:/log/LogFilter_course_id_user_id/FCUx-2015001-201511_101.log'
fileName<-'D:/modulestore.csv'
data<-readLog(filePath)



courseIdList<-getCourseList(fileName)
