library(MASS)

get_residuals <- function(name_dataset,lmoutput,residual_ouput_variable_name){
  
  temp <- data.frame(row = as.numeric(names(lmoutput$residuals)), output_name = as.numeric(stdres(lmoutput)))
  temp <- merge(temp, name_dataset,by="row",all.x=TRUE)
  temp <- temp[c(3,2)]
  names(temp)[2] <- residual_ouput_variable_name[1]
	
	return(temp)
}

	

