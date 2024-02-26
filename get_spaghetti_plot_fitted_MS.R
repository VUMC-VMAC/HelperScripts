require (ggplot2)
require(reshape2)
require(Hmisc)
require(nlme)
require(gridExtra)
#require(gplots)

get_spaghetti_plot_fitted <- function(input,id_var,xaxis_var,yaxis_var,group_var,plottitle){
	data <- input
	xaxis_column <- which(names(data) == xaxis_var)
	yaxis_column <- which(names(data) == yaxis_var)
	id_column <- which(names(data) == id_var)
	group_column <- which(names(data) == group_var)
	dataset <- data.frame(xaxis = data[,xaxis_column],yaxis = data[,yaxis_column], id = data[,id_column], group = data[,group_column])
  
	dataset <- dataset[!is.na(dataset$group),]
	
	color <- c("black","red","gray","blue","green","yellow","orange")
	

	data_temp <- dataset
	data_temp <- data_temp[order(data_temp$id,data_temp$xaxis),]
	#make buffer
	par(mai = c(1,1,1,1))
	
	#Build empty Plot
	uid = unique(data_temp$id)
	attach(data_temp)
	plot(xaxis,yaxis, type = "n", xlab = label(data[,xaxis_column]), ylab = label(data[,yaxis_column]),main = plottitle,
	     axes = F, frame = T,xlim = c(round(min(xaxis,na.rm=TRUE)),round(max(xaxis,na.rm=TRUE))),ylim = c(round(min(yaxis,na.rm=TRUE)),round(max(yaxis,na.rm=TRUE))),cex.lab = 2, cex.main= 2)
	axis(1,seq(round(min(xaxis,na.rm=TRUE)),round(max(xaxis,na.rm=TRUE)),by=round(max(xaxis,na.rm=TRUE) - min(xaxis,na.rm=TRUE))/6),cex.axis = 1.75)
	axis(2,seq(round(min(yaxis,na.rm=TRUE)),round(max(yaxis,na.rm=TRUE)),by=round(max(yaxis,na.rm=TRUE)-min(yaxis,na.rm=TRUE))/6),cex.axis = 1.75)
	detach(data_temp)
	
	beta1 <- 1:length(levels(data_temp$group))
	beta2 <- 1:length(levels(data_temp$group))
	
	#ctrl <- lmeControl(msMaxIter = 2000, opt="optim")
	
	for (i in 1:length(levels(data_temp$group)))
	{
	  data_temp2 <- data_temp[data_temp$group == levels(data_temp$group)[i],]
	  data_temp2 <- data_temp2[complete.cases(data_temp2),]
	  uid = unique(data_temp2$id)
	  #run mixed model
	  output  <- lme(yaxis ~ xaxis + xaxis^2, data = data_temp2, random=~1+xaxis + xaxis^2|id, na.action = na.omit, method = 'REML')
	  a <- summary(output)
	  data_temp2$yaxis_Fitted <- as.numeric(a$fitted[,2])
	  
	  attach(data_temp2)
	  #runnung loops for each subjects
	  for(j in 1:length(uid)){points(xaxis[id == uid[j]], yaxis_Fitted[id == uid[j]], type="o",cex=0.5,pch=20,col=color[i])}
	  detach(data_temp2)
	  
	  beta1[i] <- a$tTable[1,1]
	  beta2[i] <- a$tTable[2,1]
	}
	
	for (i in 1:length(levels(data_temp$group)))
	{
	  curve(beta1[i] + beta2[i]*x,from = min(data_temp$xaxis,na.rm=TRUE), to = max(data_temp$xaxis,na.rm=TRUE), add = TRUE, col=color[i],lwd = 18)
	}
	
	color <- color[1:length(levels(data_temp$group))]
	
	#draw legend
	legend("topright",c(levels(data_temp$group)), title = names(data[,group_column]), fill = c(color), cex = 1.25)
	

}

	

