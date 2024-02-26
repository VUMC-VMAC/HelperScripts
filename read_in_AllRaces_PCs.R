read_in_AllRaces_PCs<-function(AllRaces_PC_file_name){
  
  library(data.table)
  library(dplyr)
  
  #Reading_in_PC data and naming columns
  AllRaces_pcs<-read.table(AllRaces_PC_file_name,header=FALSE) %>% 
    dplyr::select(c(1:11))
  names(AllRaces_pcs)<-c("ID","AllRaces_PC1","AllRaces_PC2","AllRaces_PC3","AllRaces_PC4","AllRaces_PC5","AllRaces_PC6","AllRaces_PC7","AllRaces_PC8","AllRaces_PC9","AllRaces_PC10")
  
  #Reformatting ID column and creating FID and IID variable.  
  AllRaces_pcs$FID<-sapply(strsplit(as.character(AllRaces_pcs$ID),":"),"[",1)
  AllRaces_pcs$IID<-sapply(strsplit(as.character(AllRaces_pcs$ID),":"),"[",2)
  
  return(AllRaces_pcs)
}