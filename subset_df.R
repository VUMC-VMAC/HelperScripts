subset_df<-function(df,Cohort){
  
  
  #Subset to variables of interest
  vars_of_interest<-(c("FID","IID","Age","sex","education","race","dx",
                  "Age_bl_MEM","Age_bl_EXF","Age_bl_LAN",
                  "interval_MEM","interval_EXF","interval_LAN",
                  "dx_bl_MEM","dx_bl_EXF","dx_bl_LAN",
                  "num_visits_MEM","num_visits_EXF","num_visits_LAN",
                  "MEM","EXF","LAN",
                  "memslopes","exfslopes","lanslopes",
                  "apoe2count","apoe2pos","apoe3count","apoe3pos","apoe4count","apoe4pos",
                  "NHW_PC1","NHW_PC2","NHW_PC3","NHW_PC4","NHW_PC5",
                  "AllRaces_PC1","AllRaces_PC2","AllRaces_PC3","AllRaces_PC4","AllRaces_PC5","Comorbidities"))

  df<-df[vars_of_interest]
  
  df$Study<-Cohort
  
  return(df)
  
}