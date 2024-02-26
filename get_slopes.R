require(nlme)

get_slopes <- function(input,outcome,interval,id,label){
  
  data <- input
  
  #get column names
  output_column <- which(names(data)==outcome)
  interval_column <- which(names(data)==interval)
  id_column <- which(names(data)==id)
  
  #define dataset for slopes
  dataset <- data.frame(outcome = data[,output_column],interval = data[,interval_column], id = data[,id_column])
  
  #run lme
  ctrl <- lmeControl(msMaxIter = 2000, opt="optim")
  output <- lme(outcome ~ interval, random=~1+interval | id,data=dataset, na.action = na.omit, method = 'REML', control=ctrl)
  
  ##Get fixed effect
  a <- data.frame(output$coefficients[1])
  fixed <- a[2,1]
  ##Get Random Effect
  b <- data.frame(output$coefficients[2])
  random <- b[,2]+fixed
  
  ##Build output dataset with column names to match input
  Final <- data.frame(id = rownames(b),Slope = random)	
  names(Final) <- c(id, label)
  
  return(Final)
}
