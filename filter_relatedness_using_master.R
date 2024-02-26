library(data.table)
library(optparse)

# The first two should be comma separated vectors
# The ID file can be any file which has FID and IID in the first to cols and should contain
# only the samples that will be present in the analysis (so perhaps a phenotype or covariate file)
# The last should be the full stem and name of your desired output file. 
# "_relatedexclusion.txt" will be appended. 

# By default this script will keep more from smaller datasets. 
# if you supply -p or --preferred_order, it will keep based on the order you supplied rather than size

option_list = list(
  make_option(c("-f", "--files"), type="character", default=NULL, 
              help="dataset file names separated by commas", metavar="character"),
  make_option(c("-c", "--cohorts"), type="character", default=NULL, 
              help="cohort labels separated by commas", metavar="character"),
  make_option(c("-o", "--out"), type="character", default="out.txt", 
              help="output file name [default= %default]", metavar="character"), 
  make_option(c("-p", "--preferred_order"), action="store_true", default=FALSE,
              help="order based on the order in which files were supplied rather than by cohort size")
); 

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

## parse the inputs
id_files <- unlist(strsplit(opt$files, split = ",")) 
cohort_names <- unlist(strsplit(opt$cohorts, split = ",")) 

## make sure those are the same length
if(length(id_files)!=length(cohort_names)) {
  stop("Please supply the same number of cohort names and ID files!\n")
}

# read in all id files 
ids <- lapply(id_files, function(x) fread(x, select = c(1,2)))
# make into one df indicating cohort name
names(ids) <- cohort_names
ids <- rbindlist(ids, idcol = "cohort", use.names = F)
# rename cols 
names(ids)[names(ids)=="V1"] <- "FID"
names(ids)[names(ids)=="V2"] <- "IID"

if(opt$preferred_order == T){
  cat("Cohorts will be prioritized based on the order in which you supplied the files.\n")
  cohort_size <- as.data.table(cbind(cohort = cohort_names, ranking = rev(1:length(cohort_names))))
} else{
  cat("Cohorts will be prioritized based on size.\n")
  # figure out which datasets are larger for the purpose of prioritizing which cohorts to keep from
  cohort_size <- as.data.frame(table(ids$cohort))
  cohort_size <- cohort_size[order(cohort_size$Freq),] #this puts in increasing order
  cohort_size$ranking <- 1:nrow(cohort_size)
  cohort_size <- cohort_size[,c("Var1", "ranking")]
  names(cohort_size)[1] <- "cohort"
}


# read in the master file of related pairs
relatedpairs <- fread("/data/h_vmac/mahone1/master_relatedness_calc/output/all_related_pairs.txt")

# get just the pairs that are present in your data
## be sure to take into account that there might be ids that look the same between cohorts (thanks, Anna!)
ids$combined <- paste(ids$FID, ids$IID, ids$cohort, sep ="_")
relatedpairs <- relatedpairs[
  paste(relatedpairs$FID1, relatedpairs$IID1, relatedpairs$cohort1, sep = "_") %in% ids$combined &
  paste(relatedpairs$FID2, relatedpairs$IID2, relatedpairs$cohort2, sep = "_") %in% ids$combined,]

if(nrow(relatedpairs)<1){
  
  # make sure there are related pairs in the dataset before proceding. 
  cat("There are no related pairs in your analytical dataset, so no individuals need to be removed. (Note that this message could also show if the IDs you supplied are different from the ones present in the cleaned imputed files.)\n")

} else{
  
  # print out that number and the cohorts they are coming from
  cat(paste0(nrow(relatedpairs), " related pairs in your analytical data.\n"))
  print(table(relatedpairs[,c("cohort1", "cohort2")]))
  
  # merge in cohort rankings
  ## for cohort 1
  relatedpairs <- merge(relatedpairs, cohort_size, by.x = "cohort1", by.y = "cohort")
  names(relatedpairs)[names(relatedpairs) == "ranking"] <- "rank1"
  ## for cohort 2
  relatedpairs <- merge(relatedpairs, cohort_size, by.x = "cohort2", by.y = "cohort")
  names(relatedpairs)[names(relatedpairs) == "ranking"] <- "rank2"
  
  # pick which to drop (smaller cohorts are kept, larger cohorts are dropped)
  relatedpairs <- rbindlist(list(relatedpairs[relatedpairs$rank1>relatedpairs$rank2,c("FID1", "IID1", "cohort1")],
                                 relatedpairs[relatedpairs$rank1<relatedpairs$rank2,c("FID2", "IID2", "cohort2")]), 
                            use.names = FALSE)
  
  # write out file of IDs to drop from your analysis
  write.table(relatedpairs,paste0(opt$out, "_related_ids.txt"), col.names = FALSE,row.names=FALSE,quote = FALSE,sep=" ")
}
