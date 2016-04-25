source('D:/log/code/git/R/function.R') 
db_account = '' #mysql帳號
db_password = '' #mysql密碼
db_edxapp_name = 'edxapp' #edx的mysql資料庫
write_db = '' #寫進資料庫
video_r_address <- 'D:/log/code/git/R/Video.R' ##course_rogress need

#證書學生名單
pass_student_url = ''

#完課的課程
fin_course_url = ''

#作答CSV
server_problem_check_csv <- 'server_problem_check.csv' 

#學習者影片觀看時間CSV
play_video_SpentTime_csv <- 'play_video_SpentTime.csv' ### -video watch , -course_rogress need

#篩選學習者觀看影片時間
watch_time <- '60' ###video watch time -video_check60_r

#討論區CSV
contents_csv <- 'contents.csv'


###course enroll people
enroll(db_account,db_password,db_edxapp_name,write_db)


### video watch 
video_check60_r(db_account,db_password,db_edxapp_name,write_db,play_video_SpentTime_csv,watch_time)


###write_finish_course_student
#read google dirve CSV
write_pass_student_fin_course(db_account,db_password,db_edxapp_name,write_db,pass_student_url,fin_course_url)


###finish course (need write_pass_student_fin_course finish)
fin(db_account,db_password,db_edxapp_name,write_db)


###problem_do
problem(db_account,db_password,db_edxapp_name,write_db,server_problem_check_csv)


###comment
contents(db_account,db_password,db_edxapp_name,write_db,contents_csv)


###user_watch_video_code
user_watch(db_account,db_password,db_edxapp_name,write_db)


###course_rogress (need video_check60_r finish)
course_Progress(db_account,db_password,db_edxapp_name,write_db,video_r_address,play_video_SpentTime_csv)
