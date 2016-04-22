library(rjson)
source('D:/log/code/git/R/spenttime_CSV/GeneralFunction.R')

INPUT_PATH <- 'D:/QQDownload/database/LogFilter_host_user_id'
FILE_PATTERN <- "courses.opened[a-z]{1}.tw_[0-9]+"
EVT_PATTERN <- 'play_video'
EXP_FILENAME <- paste(EVT_PATTERN, '_SpentTime.csv', sep = '')
#ALLOW_CONTINUOUS_CLICK <- F
#ALLOW_COMPARE_VIDEO_ID <- T

isEventType <- function(evtPattern, logChr){
  # This function will check the log event_type. 
  # Input:
  #   evtPattern(chr): event type. (e.g. play_video, problem_check)
  #   logChr(chr): log data in character format.
  # Output:
  #   TRUE/FALSE: check the event_type in log fits the evtPattern or not.
  return(grepl(paste('"event_type": "', evtPattern, '"', sep = ''), logChr))
}

getDiffTime <- function(playJSON, compareJSON){
  playJSON$time <- strptime(playJSON$time, format = '%FT%T')
  compareJSON$time <- strptime(compareJSON$time, format = '%FT%T')
  difTime <- difftime(compareJSON$time, playJSON$time, units = 'secs')
  return(difTime)
}

writeResult <- function(evtPattern, playJSON, compareJSON, EXP_FILENAME){
  watchTime <- as.integer(getDiffTime(playJSON, compareJSON))
  if(evtPattern == 'play_video'){
    word <- paste(playJSON$context$user_id, playJSON$context$course_id, playJSON$event$id, playJSON$event$code, playJSON$time, watchTime, sep = ',')
    write.table(word, file = EXP_FILENAME, append = T, quote = F, col.names = F, row.names = F)
  }else if(evtPattern == 'speed_change_video'){
    
  }
}

spentTime <- function(evtPattern, userLog){
  cat('0%-')
  p <- 1
  ratio <- length(userLog)/10
  percent <- 10
  
  for(i in 1:length(userLog)){
    if(isEventType(evtPattern, userLog[i]) & i != length(userLog)){
      # If the event_type in log equals to evtPattern.
      # Transform log to json list then conduct analysis.
      playJSON <- fromJSON(userLog[i])
      compareJSON <- fromJSON(userLog[i+1])
      
      # Analysis process
      if(compareJSON$event_type == evtPattern){
        # It's a continuous click.
        if(playJSON$event$id != compareJSON$event$id){
          # Two log have the same event_type but the video id are not the same.
          writeResult(evtPattern, playJSON, compareJSON, EXP_FILENAME)
        }
      }else if(playJSON$event_type != compareJSON$event_type){
        # Two log do not have the same event_type.
        writeResult(evtPattern, playJSON, compareJSON, EXP_FILENAME)
      }
      
      
    }
    # Progress bar showing.
    if(length(userLog) == 1){cat('100%\n')}
    else if(length(userLog) > 1 && length(userLog) < 20){
      if(i == as.integer(length(userLog)/2)) {cat('50%-')}
      else if(i == length(userLog)) {cat('100%')}
    }else{
      if(i %% as.integer(ratio*p) == 0){
        cat(paste(percent*p, "%", sep = ''))
        if(percent*p != 100) cat('-')
        p <- p+1
      }
    }
  }
  cat('\n')
}
#Compute the execute time
startTime <- proc.time()

logFileList <- list.files(path = INPUT_PATH, pattern = FILE_PATTERN, full.names = T)
logFileName <- list.files(path = INPUT_PATH, pattern = FILE_PATTERN)

write.table('user_id,course_id,video_id,video_code,time,watch_time(sec)', file = EXP_FILENAME, append = T, quote = F, col.names = F, row.names = F)

cat('-------------Computation Start.-------------\n')
p <- 1
ratio <- length(logFileList)/10
percent <- 10

for(i in 1:length(logFileList)){
  userLog <- readLog(logFileList[i])
  cat(paste('Read ', logFileName[i], '\n', sep = ''))
  spentTime(EVT_PATTERN, userLog)
  cat(paste('Done ', logFileName[i], '\n\n', sep = ''))
  
  if(length(logFileList) == 1){cat('-------------1 file complete.-------------\n')}
  else if(length(logFileList) > 1 && length(logFileList) < 20){
    if(i == as.integer(length(logFileList)/2)) {cat('-------------50% file complete.-------------\n')}
    else if(i == length(logFileList)) {cat('-------------100% file complete.-------------\n')}
  }else{
    if(i %% as.integer(ratio*p) == 0){
      cat(paste('-------------', percent*p, ' file complete.-------------\n', sep = ''))
      p <- p+1
    }
  }
}
write.table('\n', file = EXP_FILENAME, append = T, quote = F, col.names = F, row.names = F)

#Compute the execute time
endTime <- proc.time()
print(endTime - startTime)
