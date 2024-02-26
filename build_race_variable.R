build_race_variable<-function(df,race_var_name,white,black,ethnicity_var_name,non_hispanic){
  
  #Initialize race/ethnicity to be "Other"
  df$race<-"Other"
  
  #Build race
  df$race[df[,race_var_name] == white & df[,ethnicity_var_name] == non_hispanic] <- "NHW"
  df$race[df[,race_var_name] == black & df[,ethnicity_var_name] == non_hispanic] <- "NHB"
  
  return(df)
}