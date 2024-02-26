#Function to identify and remove outliers from a dataframe, even if it's only 1 column#
rm_outliers <- function(data, cutoff = 4) {

  if(length(data)>1){
    #method for most dataframes which will have multiple columns

    # Calculate the sd and mean
    sds <- apply(data, 2, sd, na.rm = TRUE)
    mean <- apply(data, 2, mean, na.rm = TRUE)
    
    # Identify the cells with value greater than cutoff * sd (column wise)
    outliers <- mapply(function(d, s, m) {
      which(d > m +cutoff * s, d < m - cutoff * s )
    }, data, sds, mean, SIMPLIFY = FALSE)
    
    result <- mapply(function(d, o) {
      res <- d
      res[o] <- NA
      return(res)
    }, data, outliers)
    return(as.data.frame(result))
    
  } else {
    
    #method for dataframes/data.tables with only 1 column
    #using syntax friendly to data.tables as well as data.frames
    data[(data[[1]]>mean(data[[1]])+4*sd(data[[1]]))|(data[[1]]<mean(data[[1]])-4*sd(data[[1]])),1] <- NA
    return(as.data.frame(data))
  }
  
}
