recodeBlom <- function(df,varlist_orig,varlist_tr){
  if (is.data.frame(df)) {
    tr <- df
  } else {
    tr <- eval(parse(text=df))
  }
  for (j in 1:length(varlist_orig)){
    varlab <- varlist_tr[j]
    tr[,varlab] <- ifelse(is.na(tr[,varlist_orig[j]]),NA,qnorm((rank(tr[,varlist_orig[j]], ties="average")-0.375)/(sum(!is.na(tr[,varlist_orig[j]])) - 2*0.375 + 1))) 
  }
  return(tr)
}