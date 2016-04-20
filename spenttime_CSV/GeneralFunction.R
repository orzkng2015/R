library(rjson)
library(dplyr)




getCourseList <- function(fileName){
  # This function will return a course list from csv which exported by mongoDB.
  COURSELIST <- read.csv(fileName, stringsAsFactors = F, quote = "", na.string = "NA", fileEncoding = "UTF-8")
  courseIdList <- paste(COURSELIST$X_id.org, COURSELIST$X_id.course, COURSELIST$X_id.name, sep = "/")
  return(courseIdList)
}

readLog <- function(filePath){
  # Read log by line.
  # Input:
  #   filePath(chr): the log file path.
  # Output:
  #   data(chr): log data in character format.
  conn <- file(filePath, open = "r")
  data <- readLines(conn)
  close(conn)
  return(data)
}

getCourseData <- function(courseID, data){
  # Get the course data.
  # Input:
  #   courseID(chr): the course id
  #   data(data.frame/character): the course data and there is a field name 'course_id'.
  # Output:
  #   courseData(data.frame): the course data.
  if(class(data) == 'data.frame') courseData <- subset(data, course_id == courseID)
  else if(class(data) == 'character'){
    courseData <- log2DF(data, course_id = courseID)
  }
  return(courseData)
}

log2DF <- function(data, ...){
  # This function will transform log(json format) to data frame.
  # Input:
  #   data(chr): log data in character format.
  #   ...: field filter. (e.g. course_id, user_id.)
  # Output:
  #   courseData(data.frame): the log data frame.
  #event_log
  #Compute the execute time
  startTime <- proc.time()
  
  cat('------Start-Processing-Log------\n')
  dataLength <- length(data)
  p <- 1
  ratio <- dataLength/10
  percent <- 10
  courseData <- data.frame()
  cat('0%-')
  
  filterList <- list(...)
  
  for(i in 1:dataLength){
    fits <- T
    if(length(filterList) > 0){
      for(j in 1:length(filterList)){
        fits <- grepl(paste('"',names(filterList)[j],'": "', filterList[j], '"', sep = ''), data[i]) & fits
      }
    }
    if(fits){
      tempData <- as.data.frame(fromJSON(data[i]))
      if(length(tempData$context.course_user_tags) > 0) tempData$context.course_user_tags <- NULL
      courseData <- rbind(courseData, tempData)
    }
    # Progress bar showing.
    if(dataLength == 1){cat('100%\n')}
    else if(dataLength > 1 & dataLength < 20){
      if(i == as.integer(dataLength/2)) {cat('50%-')}
      else if(i == dataLength) {cat('100%')}
    }else{
      if(i %% as.integer(ratio*p) == 0){
        cat(paste(percent*p, "%", sep = ''))
        if(percent*p != 100) cat('-')
        p <- p+1
      }
    }
  }
  cat('\n')
  #Compute the execute time
  endTime <- proc.time()
  print(endTime - startTime)
  return(courseData)
}

createDateList <- function(firstDay, lastDay, gap = 1){
  # This function will return a date list data.frame used for data presentation.
  # Input:
  #   firstDay(chr): the first day.
  #   lastDay(chr): the last day.
  #   gap(int): the gap between days, default as 1.
  # Output:
  #   dateList(list): a date list.
  firstDay <- as.Date(firstDay)
  lastDay <- as.Date(lastDay)
  dateNum <- as.integer(lastDay-firstDay)/gap + 1
  dateList <- as.character(1:dateNum)
  for(i in 1:dateNum){
    if(i == 1) dateList[i] <- as.character(firstDay)
    else {
      dateList[i] <- as.character(firstDay + (i-1)*gap)
    }
  }
  dateList <- as.data.frame(dateList, stringsAsFactors = F)
  colnames(dateList)[1] <- 'date'
  return(dateList)
}

getDefaultSchema <- function(type){
  if(type == "Gender"){
    DF <- data.frame(f = NA, m = NA, o = NA)
  }else if(type == "Education"){
    DF <- data.frame(p = NA, m = NA, b = NA, a = NA, hs = NA, jhs = NA, el = NA, none = NA, other = NA)
  }
  return(DF)
}

rotateDataFrame <- function(nameList, dataList, defaultDF, blankData = "no_data"){
  # Unused
  # This function will use nameList as data.frame column names, dataList as the row data.
  # Check if the column name is blank.
  for(i in 1:length(nameList)){
    if(nameList[i] == "") nameList[i] <- blankData
  }
  # Create a data.frame.
  DF <- as.data.frame(as.list(dataList))
  colnames(DF) <- nameList
  if(!missing(defaultDF)){
    DF <- dplyr::left_join(DF, defaultDF)
    DF[is.na(DF)] <- 0
  }
  return(DF)
}