# 環境需求
R 3.2.x以上版本 <br>
RStudio <br>
Mysql  <br> <br>
MongoDb <br> <br>
在Console 輸入以下指令進行安裝 <br>
install.packages("googlesheets") <br>
install.packages("rjson") <br>
install.packages("RCurl") <br>
install.packages("rmongodb") <br>
在安裝RMysql之前 <br>
需安裝[R tools](https://cran.r-project.org/bin/windows/Rtools/) <br>
<br>
安裝完畢編輯 Rprofile.site<br> 在C:\Program Files\R\R-3.2.5\etc <br>
新增以下指令<br>
MYSQL_HOME=’C:/Program Files/MySQL/MysSQL Server 5.7’<br>
解壓縮 MysSQL Server 5.7.rar到以上目錄<br>
install.packages('RMySQL')<br>

# Mongo Server<br>
討論區 匯入匯出CSV<br>
匯入 <br>
C:\Program Files\MongoDB\Server\3.2\bin>mongorestore --db cs_comments_service_development  --collection contents  D:\contents.bson <br>

匯出 <br>
C:\Program Files\MongoDB\Server\3.2\bin>mongoexport --db cs_comments_service_development --collection contents -f  course_id,_type,author_id,created_at --csv --out D://contents.csv <br>


#產生使用者觀看影片時間 play_video_SpentTime.csv
INPUT_PATH 填入 LogFilter_host_user_id 路徑
執行 EvtSpentTime.R 跑完即可產生
