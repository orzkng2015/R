# 環境需求
R 3.2.x以上版本 <br>
RStudio <br>
Mysql  <br> 
MongoDb <br> 
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

啟動MongoDB C:\Program Files\MongoDB\Server\3.2\bin>mongod.exe <br>

討論區 匯入匯出CSV<br>
匯入 <br>
C:\Program Files\MongoDB\Server\3.2\bin>mongorestore --db cs_comments_service_development  --collection contents  D:\contents.bson <br>

匯出 <br>
C:\Program Files\MongoDB\Server\3.2\bin>mongoexport --db cs_comments_service_development --collection contents -f  course_id,_type,author_id,created_at --csv --out D://contents.csv <br>

作答log 匯入mongo
C:\Program Files\MongoDB\Server\3.2\bin>mongoimport --db log --collection server
_problem_check --file D:\server_problem_check.log


作答次數匯出csv
C:\Program Files\MongoDB\Server\3.2\bin>mongoexport --db log --collection server
_problem_check  -f username,host,event_source,context.user_id,context.course_id,
time --csv --out D://server_problem_check.csv

#產生使用者觀看影片時間 play_video_SpentTime.csv
INPUT_PATH 填入 LogFilter_host_user_id 路徑
執行 EvtSpentTime.R 跑完即可產生play_video_SpentTime.csv

#運行及設定
新增資料庫
設定run.R
內的相關參數設鄧
![](https://github.com/orzkng2015/R/blob/master/%E6%9C%AA%E5%91%BD%E5%90%8D.png)
#php
執行run.R 跑完之後<br>
安裝[WAMPSERVER](http://www.wampserver.com/en/)<br>
安裝完畢<br>
解壓time_sum.rar<br>
設定/config/config.php 連結資料庫

