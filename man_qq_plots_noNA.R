args <- commandArgs(TRUE)
filename <- args[1] #include path with file stem
snp_info <- args[2] #bim file if these are meta-analysis results

library(qqman)
library(data.table)

options(bitmapType='cairo')

#read in results
results <- fread(filename, header=TRUE, stringsAsFactors = F)
names(results)[names(results) == "p-value"] <- "P"
names(results)[names(results) == "chromosome"] <- "CHR"
names(results)[names(results) == "position"] <- "BP"
names(results)[names(results) == "rs_number"] <- "SNP"

if(!("CHR" %in% names(results)) || !("BP" %in% names(results))){
  print("Chromosome and position not present in results dataframe. Pulling in now...")
  snps <- fread(snp_info, header = F, stringsAsFactors = F)
  snps <- snps[,c(1,2,4)]
  names(snps) <- c("CHR", "SNP", "BP")
  snps <- snps[snps$SNP %in% results$SNP,]
  results <- merge(results, snps, by = "SNP", all.x = T)
}

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

#remove results with NA
if(sum(is.na(results$CHR))>0){
  print(paste(sum(is.na(results$CHR)), "results without CHR/BP info. Removing to create the manhattan plot..."))
  results <- results[!is.na(results$CHR),]
}

#get results for manhattan plot
man_results <- results[,c("CHR","BP","P")]

#manhattan plot
png(paste0(filename, ".manhattan.png"), width = 960, height = 480)
manhattan(man_results)
dev.off()