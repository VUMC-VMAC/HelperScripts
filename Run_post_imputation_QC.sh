#/bin/sh
cohort=$1
QC_version=$2

set -e

if [ -z "$QC_version" ];
    then
    printf "No QC version specified (e.g. allraces). Assuming that this is the main, common variant pipeline in Caucasians only.\n"
    cohort_version="$cohort"
    imputation_results_folder=$( printf "Caucasians_only" )
else
    printf "Running the $QC_version version of $cohort post-imputation QC."
    cohort_version=$( printf "${cohort}_${QC_version}" )
    imputation_results_folder=$QC_version
fi


#load the most recent version of plink to have vcf conversion capabilities
module load PLINK/2.00-alpha1

#work in the Imputed/Raw/ folder for the cohort where the imputation results live
cd /nfs/DATA/${cohort}/GWAS/Imputed/Raw/${imputation_results_folder}

for i in $(seq 1 22); do
    #restrict to variants with R2>=0.90
    plink2 --vcf chr${i}.dose.vcf.gz --exclude-if-info "R2<0.9" --make-bed --out chr${i}_temp

    #get list of duplicates SNPs (they have more than 1 row in the bim file) and remove
    awk '{ print $2 }' chr${i}_temp.bim | uniq -d > chr${i}_temp.dups ;
    plink2 --bfile chr${i}_temp --exclude chr${i}_temp.dups --make-bed --out chr${i}_temp_nodups
done

#switch back to old plink
module unload PLINK/2.00-alpha1
module load PLINK/1.9b_5.2

#create merge file (removing old version if present)
if [ ! -d merge_list.txt ]; then rm merge_list.txt ; fi
for i in $( seq 2 22 ); do echo "chr${i}_temp_nodups.bed  chr${i}_temp_nodups.bim  chr${i}_temp_nodups.fam" >> merge_list.txt ; done

#merge individual chromosome files to be one large file
plink --bfile chr1_temp_nodups --merge-list merge_list.txt --make-bed --out ${cohort_version}

#update SNP names and add sex back into fam file
plink --bfile ${cohort_version} --update-sex /nfs/DATA/${cohort}/GWAS/Genotyped/Cleaned/${cohort_version}_genotyped_final.fam 3 --update-name /home/clarklc/Programs/HRC_snps_nodups --make-bed --out /nfs/DATA/${cohort}/GWAS/Imputed/Cleaned/QC/${cohort_version}_names

cd /nfs/DATA/${cohort}/GWAS/Imputed/Cleaned/QC/

# SNP filters
plink --bfile ${cohort_version}_names --maf 0.01 --geno 0.05 --hwe 0.000001 --make-bed --out ${cohort_version}_maf01_geno05_hwe6
