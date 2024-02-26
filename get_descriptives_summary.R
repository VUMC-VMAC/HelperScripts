##Libraries
require(reshape2)
require(Hmisc)
require(nlme)
require(gridExtra)

get_descriptives <- function(input, variables, type){
  
  data <- input
  
  
  #Initialize Variables
  Variable <- ""
  Mean <- data.frame(matrix(0,nrow = 1, ncol = 1))
  names(Mean) <- paste("Mean",sep="")
  sd <- data.frame(matrix(0,nrow = 1, ncol = 1))
  names(sd) <- paste("Standard_Deviation",sep="")
  N <- data.frame(matrix(0,nrow = 1, ncol = 1))
  names(N) <- paste("N",sep="")
  
  
  for (j in 1:length(variables)){
    column <- which(names(data) == variables[j])
    Variable[j] <- names(data)[column]
    Mean[j,1] <- round(mean(as.numeric(data[,column]),na.rm=TRUE),2)
    sd[j,1] <- round(sd(as.numeric(data[,column]),na.rm=TRUE),2)
    N[j,1] <- nrow(data[!is.na(data[,column]),])
    
  }
  
  Final <- data.frame(Variable)
  names(Final) <- "Variable"
  if(type=="cont"){
     Final <- cbind(Final,Summary=paste(Mean$Mean, "+/-", sd$Standard_Deviation, sep=" "),N)
  } else if(type=="cat"){
    Final <- cbind(Final,Summary=paste(Mean$Mean*100,"%",sep=""),N)
  } else print("Must supply data type (cont or cat)")
  
  return(Final)
}


