require (ggplot2)
require(reshape2)
require(Hmisc)
require(nlme)
require(gridExtra)

get_spaghetti_plot <- function(input,id_var,xaxis_var,yaxis_var,group_var,col1,col2,col3,col4=NULL,xlabel,ylabel, 
                               plottitle=NULL, group_label = NULL, print_legend = FALSE, legend_loc = NULL){
  data <- input
  xaxis_column <- which(names(data) == xaxis_var)
  yaxis_column <- which(names(data) == yaxis_var)
  id_column <- which(names(data) == id_var)
  group_column <- which(names(data) == group_var)
  dataset <- data.frame(xaxis = data[,xaxis_column],yaxis = data[,yaxis_column], id = data[,id_column], group = data[,group_column])
  #dataset$yaxis<-round(dataset$yaxis,1)
  
  #make grouping column factor type
  dataset$group <- as.factor(dataset$group)
  
  if(exists("col4")){
    color <- c(col1,col2,col3,col4)
  } else {
    color <- c(col1,col2,col3)
  }
  
  
  data_temp <- dataset
  data_temp <- data_temp[order(data_temp$id,data_temp$xaxis),]
  #make buffer
  par(mai = c(1,1,1,1))
  
  ctrl <- lmeControl(msMaxIter = 2000, opt="optim")
  
  #Build empty Plot
  uid = unique(data_temp$id)
  attach(data_temp)
  par(bg='white',col.axis="black")
  plot(xaxis,yaxis, type = "n", xlab = xlabel, ylab = ylabel,font.lab=2,col.lab="black",
       axes = F,frame = F,xlim = c(min(xaxis,na.rm=TRUE),max(xaxis,na.rm=TRUE)),
       ylim = c(min(yaxis,na.rm=TRUE),max(yaxis,na.rm=TRUE)),cex.lab = 1, cex.main= 1)
  axis(1,seq(min(xaxis,na.rm=TRUE),max(xaxis,na.rm=TRUE),by=5),cex.axis = 1,font=2,lwd=3,col="black")
  axis(2,seq(min(yaxis,na.rm=TRUE),max(yaxis,na.rm=TRUE),by=(max(yaxis,na.rm=TRUE)-min(yaxis,na.rm=TRUE))/5),
       cex.axis = 1,las=1,font=2,lwd=3,col="black")
  rect(par("usr")[1],par("usr")[3],par("usr")[2],par("usr")[4],col = "white")
  
  mtext(side=3,plottitle,font=2)
  #mtext(side=2,names(data)[yaxis_column],font=2)
  
  
  detach(data_temp)
  
  beta1 <- 1:length(levels(data_temp$group))
  beta2 <- 1:length(levels(data_temp$group))
  
  for (i in 1:length(levels(data_temp$group)))
  {
    data_temp2 <- data_temp[data_temp$group == levels(data_temp$group)[i],]
    data_temp2 <- data_temp2[complete.cases(data_temp2),]
    uid = unique(data_temp2$id)
    #run mixed model
    output  <- lme(yaxis ~ xaxis, data = data_temp2, random=~1+xaxis|id, na.action = na.omit, method = 'REML',control=ctrl)
    a <- summary(output)
    data_temp2$yaxis_Fitted <- as.numeric(a$fitted[,2]) 
    
    attach(data_temp2)
    #runnung loops for each subjects
    for(j in 1:length(uid)){points(xaxis[id == uid[j]], yaxis_Fitted[id == uid[j]], type="o",cex=0.1,pch=20,lwd=1,col=color[i])}
    detach(data_temp2)
    
    beta1[i] <- a$tTable[1,1]
    beta2[i] <- a$tTable[2,1]
  }
  
  for (i in 1:length(levels(data_temp$group)))
  {
    curve(beta1[i] + beta2[i]*x,from = min(data_temp$xaxis,na.rm=TRUE), to = max(data_temp$xaxis,na.rm=TRUE), add = TRUE, col=color[i],lwd = 10,lty=1)
  }
  
  color <- color[1:length(levels(data_temp$group))]
  
  if(print_legend == TRUE){
    if(!exists("group_label")){
      group_label <- group_var
    }
    if(!exists("legend_loc")){
      legend_loc <- "bottomright"
    }
    #draw legend
    legend(legend_loc,c(levels(data_temp$group)), title = paste(group_label), fill = c(color), cex = 0.9, bg = "white")
  }
  
  
}



