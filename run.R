source('D:/log/code/git/R/function.R') 
db_account = 'root'
db_password = 'edx1234'
db_edxapp_name = 'edxapp'
write_db = 'fun'

watch_time <- '60' ###video watch time -video_check60_r

play_video_SpentTime_csv <- 'D:/log/code/sum/online/csv/play_video_SpentTime.csv' ### -video watch , -course_rogress need


video_r_address <- 'D:/log/code/git/R/Video.R' ##course_rogress need


###course enroll people

enroll(db_account,db_password,db_edxapp_name,write_db)

###


### video watch 


video_check60_r(db_account,db_password,db_edxapp_name,write_db,play_video_SpentTime_csv,watch_time)

###


###finish course 

fin(db_account,db_password,db_edxapp_name,write_db)

###

###problem_do

server_problem_check_csv <- 'D:/log/code/sum/online/csv/server_problem_check.csv'

problem(db_account,db_password,db_edxapp_name,write_db,server_problem_check_csv)

###

###comment

contents_csv <- 'D:/log/code/sum/online/csv/contents.csv'
contents(db_account,db_password,db_edxapp_name,write_db,contents_csv)

###


###course_rogress (need video_check60_r finish)

#course_Progress(db_account,db_password,db_edxapp_name,write_db,video_r_address,play_video_SpentTime_csv)

###

