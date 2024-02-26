args <- commandArgs(TRUE)
filename <- args[1] #include path with file stem

library(qqman)
library(data.table)

options(bitmapType='cairo')

#read in results
results <- fread(filename, header=TRUE, stringsAsFactors = F)
names(results)[names(results) == "p-value"] <- "P"
names(results)[names(results) == "chromosome"] <- "CHR"
names(results)[names(results) == "position"] <- "BP"
names(results)[names(results) == "rs_number"] <- "SNP"

#remove results with NA
if(sum(is.na(results$P))>0){
  print(paste(sum(is.na(results$P)), "results with NA p values. Removing..."))
  results <- results[!is.na(results$P),]
}

#calculate lambda
chisq <- qchisq(1-results$P,1)
lam <- median(chisq,na.rm=TRUE)/qchisq(0.5,1)

#qqplot
png(paste0(filename, ".qq.png"))
qq(results$P, sub=paste0("lambda=", lam))
dev.off()
