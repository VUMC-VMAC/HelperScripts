require(Hmisc)
require(nlme)

get_slopes_advanced <- function(input,outcome,time,id,label){
	data <- input
	output_column <- grep(paste("^",outcome,"$", sep=""),names(data))
	time_column <- grep(paste("^",time,"$", sep=""),names(data))
	id_column <- names(data)[names(data) == id]

		dataset <- data.frame(outcome = data[,output_column],time = data[,time_column], ID = data[,id_column])

	ctrl <- lmeControl(msMaxIter = 2000, opt="optim")	
	output <- lme(outcome ~ time, random=~1+time | ID,data=dataset, na.action = na.omit, method = 'REML', control=ctrl)
	##Get fixed effect
		a <- data.frame(output$coefficients[1])
		fixed <- a[2,1]
	##Get Random Effect
		b <- data.frame(output$coefficients[2])
		random <- b[,2]+fixed
	
	##Build output dataset
		Final <- data.frame(ID = as.character(rownames(b)),Slope = random)	
		names(Final)[1] <- id
		names(Final)[2] <- label
		
		return(Final)
}



