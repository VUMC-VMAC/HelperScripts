read_in_NHW_PCs<-function(NHW_PC_file_name){
  
  library(data.table)
  library(dplyr)
  
  #Reading_in_PC data and naming columns
  NHW_pcs<-read.table(NHW_PC_file_name,header=FALSE) %>% 
    dplyr::select(c(1:11))
  names(NHW_pcs)<-c("ID","NHW_PC1","NHW_PC2","NHW_PC3","NHW_PC4","NHW_PC5","NHW_PC6","NHW_PC7","NHW_PC8","NHW_PC9","NHW_PC10")
  
  #Reformatting ID column and creating FID and IID variable.  
  NHW_pcs$FID<-sapply(strsplit(as.character(NHW_pcs$ID),":"),"[",1)
  NHW_pcs$IID<-sapply(strsplit(as.character(NHW_pcs$ID),":"),"[",2)
  
  #Drop IID and ID columns. 
  NHW_pcs<-NHW_pcs %>% 
    dplyr::select(-c("ID","IID"))
  
  return(NHW_pcs)
}