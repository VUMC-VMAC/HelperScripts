build_apoe_counts<-function(df,apoe_var_name,e22,e23,e24,e33,e34,e44){
  
  #Build apoe4carrier 
  df$apoe4pos[df[,apoe_var_name] == e22] <- 0
  df$apoe4pos[df[,apoe_var_name] == e23] <- 0
  df$apoe4pos[df[,apoe_var_name] == e24] <- 1
  df$apoe4pos[df[,apoe_var_name] == e33] <- 0
  df$apoe4pos[df[,apoe_var_name] == e34] <- 1
  df$apoe4pos[df[,apoe_var_name] == e44] <- 1
  
  #Build apoe4count 
  df$apoe4count[df[,apoe_var_name] == e22] <- 0
  df$apoe4count[df[,apoe_var_name] == e23] <- 0
  df$apoe4count[df[,apoe_var_name] == e24] <- 1
  df$apoe4count[df[,apoe_var_name] == e33] <- 0
  df$apoe4count[df[,apoe_var_name] == e34] <- 1
  df$apoe4count[df[,apoe_var_name] == e44] <- 2
  
  #Build apoe2count 
  df$apoe2count[df[,apoe_var_name] == e22] <- 2
  df$apoe2count[df[,apoe_var_name] == e23] <- 1
  df$apoe2count[df[,apoe_var_name] == e24] <- 1
  df$apoe2count[df[,apoe_var_name] == e33] <- 0
  df$apoe2count[df[,apoe_var_name] == e34] <- 0
  df$apoe2count[df[,apoe_var_name] == e44] <- 0
  
  #Build apoe2pos
  df$apoe2pos[df[,apoe_var_name] == e22] <- 1
  df$apoe2pos[df[,apoe_var_name] == e23] <- 1
  df$apoe2pos[df[,apoe_var_name] == e24] <- 1
  df$apoe2pos[df[,apoe_var_name] == e33] <- 0
  df$apoe2pos[df[,apoe_var_name] == e34] <- 0
  df$apoe2pos[df[,apoe_var_name] == e44] <- 0
  
  #Build apoe3count 
  df$apoe3count[df[,apoe_var_name] == e22] <- 0
  df$apoe3count[df[,apoe_var_name] == e23] <- 1
  df$apoe3count[df[,apoe_var_name] == e24] <- 0
  df$apoe3count[df[,apoe_var_name] == e33] <- 2
  df$apoe3count[df[,apoe_var_name] == e34] <- 1
  df$apoe3count[df[,apoe_var_name] == e44] <- 0
  
  #Build apoe3pos
  df$apoe3pos[df[,apoe_var_name] == e22] <- 0
  df$apoe3pos[df[,apoe_var_name] == e23] <- 1
  df$apoe3pos[df[,apoe_var_name] == e24] <- 0
  df$apoe3pos[df[,apoe_var_name] == e33] <- 1
  df$apoe3pos[df[,apoe_var_name] == e34] <- 1
  df$apoe3pos[df[,apoe_var_name] == e44] <- 0
  
  return(df)
}