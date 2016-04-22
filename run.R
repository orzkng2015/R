source('D:/log/code/git/R/function.R') 
db_account = 'root'
db_password = 'edx1234'
db_edxapp_name = 'edxapp'
write_db = 'fun'





###course enroll people

enroll(db_account,db_password,db_edxapp_name,write_db)



### video watch 

watch_time <- '60' ###video watch time -video_check60_r

play_video_SpentTime_csv <- 'D:/log/code/sum/online/csv/play_video_SpentTime.csv' ### -video watch , -course_rogress need

video_check60_r(db_account,db_password,db_edxapp_name,write_db,play_video_SpentTime_csv,watch_time)

###write_finish_course_student
#read google dirve CSV

pass_student_url = 'https://docs.google.com/spreadsheets/d/1YmbI5Qu6_r6H6Eyt1Dn-7haQOLKYhpDN-MnnuNBHYmc/pub?gid=1471147752&single=true&output=csv'
fin_course_url = 'https://docs.google.com/spreadsheets/d/11qm__lM_yyzLja23iyJo3DUIrJdROtPz0YQcbonuyIc/pub?gid=957487814&single=true&output=csv'

write_pass_student_fin_course(db_account,db_password,db_edxapp_name,write_db,pass_student_url,fin_course_url)

###finish course (need write_pass_student_fin_course finish)

fin(db_account,db_password,db_edxapp_name,write_db)



###problem_do

server_problem_check_csv <- 'D:/log/code/sum/online/csv/server_problem_check.csv'

problem(db_account,db_password,db_edxapp_name,write_db,server_problem_check_csv)



###comment

contents_csv <- 'D:/log/code/sum/online/csv/contents.csv'
contents(db_account,db_password,db_edxapp_name,write_db,contents_csv)

###user_watch_video_code
user_watch(db_account,db_password,db_edxapp_name,write_db)

###course_rogress (need video_check60_r finish)
video_r_address <- 'D:/log/code/git/R/Video.R' ##course_rogress need
#course_Progress(db_account,db_password,db_edxapp_name,write_db,video_r_address,play_video_SpentTime_csv)
