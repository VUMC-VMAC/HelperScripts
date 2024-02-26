longitudinal_descriptives<-function(cohort,minimum_number_of_visits){
  
  data<-cohort
  
  #############################################
  #############MEM Calculation#################
  #############################################
  
  ###Calculate memslopes and interval_MEM.
  if (sum(is.na(data$MEM))!=nrow(data)){
    
    ###Subset to MEM!="NA"
    data_MEM<-data %>% dplyr::filter(MEM!="NA")
    
    ###Determine what the first time point is. 
    data_MEM <- data_MEM[order(data_MEM$Subject, data_MEM$Age),]
    data_MEM$first <- Lag(data_MEM$Subject)!= data_MEM$Subject
    data_MEM$first[1] <- TRUE
    
    ###Determine age at baseline for all participants.
    data_first_MEM <- data_MEM[data_MEM$first==T,]
    data_first_MEM <- data_first_MEM[,c("Subject", "Age","dx")]
    names(data_first_MEM)[2] <- "Age_bl_MEM"
    names(data_first_MEM)[3] <- "dx_bl_MEM"
    data_MEM <- merge(data_MEM, data_first_MEM, by = "Subject")
    rm(data_first_MEM)
    
    ###Build time interval from age. 
    data_MEM$interval_MEM <- data_MEM$Age - data_MEM$Age_bl_MEM
    
    ###Calculate the number of visits. 
    num_visits_MEM <- data.frame(table(data_MEM$Subject), stringsAsFactors = F)
    names(num_visits_MEM) <- c("Subject", "num_visits_MEM")
    data_MEM <- merge(data_MEM, num_visits_MEM, by = "Subject")
    rm(num_visits_MEM)
    
    data_mult_visits_MEM<-data_MEM %>% dplyr::filter(data_MEM$num_visits_MEM>=minimum_number_of_visits) %>% dplyr::select(c("Subject","Age","interval_MEM","Age_bl_MEM","dx_bl_MEM","MEM","EXF","LAN","num_visits_MEM"))
    
    data_mult_visits_MEM<-merge(data_MEM,
                                get_slopes(data_mult_visits_MEM,"MEM","interval_MEM","Subject","memslopes"),by="Subject",all.x=TRUE)
    
    data_mult_visits_MEM<-data_mult_visits_MEM %>% dplyr::select(c("Subject","Age","interval_MEM","dx_bl_MEM","num_visits_MEM","memslopes","Age_bl_MEM"))       
    
  }else{
    
    ###Create dataframe. 
    data_mult_visits_MEM<-data.frame(Subject=data$Subject,
                                     Age=data$Age,
                                     interval_MEM=NA,
                                     dx_bl_MEM=NA,
                                     num_visits_MEM=NA,
                                     memslopes=NA,
                                     Age_bl_MEM=NA)
    
  }  
  
  
  #############################################
  #############EXF Calculation#################
  #############################################
  
  ###Calculate exfslopes and interval_EXF.
  if (sum(is.na(data$EXF))!=nrow(data)){
    
    ###Subset to EXF!="NA"
    data_EXF<-data %>% dplyr::filter(EXF!="NA")
    
    ###Determine what the first time point is. 
    data_EXF <- data_EXF[order(data_EXF$Subject, data_EXF$Age),]
    data_EXF$first <- Lag(data_EXF$Subject)!= data_EXF$Subject
    data_EXF$first[1] <- TRUE
    
    ###Determine age at baseline for all participants.
    data_first_EXF <- data_EXF[data_EXF$first==T,]
    data_first_EXF <- data_first_EXF[,c("Subject", "Age","dx")]
    names(data_first_EXF)[2] <- "Age_bl_EXF"
    names(data_first_EXF)[3] <- "dx_bl_EXF"
    data_EXF <- merge(data_EXF, data_first_EXF, by = "Subject")
    rm(data_first_EXF)
    
    ###Build time interval from age. 
    data_EXF$interval_EXF <- data_EXF$Age - data_EXF$Age_bl_EXF
    
    ###Calculate the number of visits. 
    num_visits_EXF <- data.frame(table(data_EXF$Subject), stringsAsFactors = F)
    names(num_visits_EXF) <- c("Subject", "num_visits_EXF")
    data_EXF <- merge(data_EXF, num_visits_EXF, by = "Subject")
    rm(num_visits_EXF)
    
    data_mult_visits_EXF<-data_EXF %>% dplyr::filter(data_EXF$num_visits_EXF>=minimum_number_of_visits) %>% dplyr::select(c("Subject","Age","interval_EXF","Age_bl_EXF","dx_bl_EXF","MEM","EXF","LAN","num_visits_EXF"))
    
    data_mult_visits_EXF<-merge(data_EXF,
                                get_slopes(data_mult_visits_EXF,"EXF","interval_EXF","Subject","exfslopes"),by="Subject",all.x=TRUE)
    
    data_mult_visits_EXF<-data_mult_visits_EXF %>% dplyr::select(c("Subject","Age","interval_EXF","dx_bl_EXF","num_visits_EXF","exfslopes","Age_bl_EXF"))       
    
    }else{
      ###Create dataframe. 
      data_mult_visits_EXF<-data.frame(Subject=data$Subject,
                                       Age=data$Age,
                                       interval_EXF=NA,
                                       dx_bl_EXF=NA,
                                       num_visits_EXF=NA,
                                       exfslopes=NA,
                                       Age_bl_EXF=NA)
  
}  
 
  
  data_with_slopes<- merge(data_mult_visits_MEM,data_mult_visits_EXF,by=c("Subject","Age"),all=TRUE)
  
  data_new <- merge(data,data_with_slopes,by=c("Subject","Age"),all.x=TRUE)
  
  return(data_new)
  
}