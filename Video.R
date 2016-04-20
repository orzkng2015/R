

####progress

CourseView <- function(courseID, playVideo){
  # Used to filter the course_id.
  index <- list()
  for(i in 1:lengths(playVideo)[1]){
    # If the playVideo$course_id equals to courseID, the index set to true.
    index[length(index)+1] <- ifelse(playVideo$course_id[i] == courseID, T, F)
  }
  # Get the course data by index.
  courseData <- playVideo[unlist(index),]
  return(courseData)
}

UserViewsOverNum <- function(CourseData, percent, totalVideosNum, up){
  # Compute the numbers of videos a user watch is greater than or equals to a percent of total videos in a course.
  # Get the numbers of videos a user watch by freqency.
  videos <- as.data.frame(table(CourseData$user_id), stringsAsFactors = F)
  colnames(videos)[1] <- 'user_id'
  # Left join the country and videos.
  videos <- dplyr::left_join(videos, up, by = 'user_id')
  index <- list()
  for(i in 1:lengths(videos)[1]){
    # If the numbers of videos a user watch is greater than or equals to a percent of total videos.
    # Index will set to true.
    index[length(index)+1] <- ifelse(videos$Freq[i] >= percent*totalVideosNum, T, F)
  }
  # Column bind videos and index.
  videos <- cbind(videos, as.data.frame(unlist(index)))
  colnames(videos)[4] <- 'WatchOver'
  # Compute the country and index.
  watchOver <- as.data.frame(table(videos$country, videos$WatchOver), stringsAsFactors = F)
  colnames(watchOver)[1] <- 'country'
  colnames(watchOver)[2] <- 'WatchOver'
  return(watchOver)
}

VideoNumbers <- function(CourseData, up){
  # Compute a number of video viewers.(e.g. 2 user watch 1 video => 2)
  users <- as.data.frame(CourseData$user_id, stringsAsFactors = F)
  colnames(users)[1] <- 'user_id'
  # Left join country and user_id.
  users <- dplyr::left_join(users, up, by = 'user_id')
  # Get the country frequency.
  users <- as.data.frame(table(users$country), stringsAsFactors = F)
  colnames(users)[1] <- 'country'
  return(users)
}

VideoViews <- function(CourseData, up){
  # Left join country and course data.
  views <- dplyr::left_join(CourseData, up, by = 'user_id')
  # Compute the country frequency. It means views in a course.
  views <- as.data.frame(table(views$country))
  colnames(views)[1] <- 'country'
  return(views)
}






