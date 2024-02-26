build_sex_variable<-function(df,sex_var_name,males,females){
  
  #Initialize sex to be "0"
  df$sex <- 0 
  
  #Build sex to match plink coding.
  df$sex[df[,sex_var_name] == males] <- 1
  df$sex[df[,sex_var_name] == females] <- 2
  
  return(df)
  
}