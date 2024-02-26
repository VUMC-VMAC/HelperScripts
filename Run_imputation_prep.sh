#/bin/sh
genotype_data=$1 #stem with full file path (must have created .frq file)
imputation_prep_folder=$2 #where do you want things to be saved

set -e

genotype_filename=$( echo ${genotype_data##*/} )

printf "Copying genotype files from $genotype_data to $imputation_prep_folder \n"

#move into the folder to do the imputation prep and copy the genotype files into it
cd $imputation_prep_folder
cp ${genotype_data}.* ./

#load software for vcf sort
module purge
module load GCC/5.4.0-2.26 tabix/0.2.6 VCFtools/0.1.14 PLINK/1.9b_5.2 

printf "\n\nRunning the perl script that checks genotype files and builds the plink script.\n"

#run the script that checks and builds the plink script
perl /home/clarklc/Programs/HRC-1000G-check-bim.pl -b ${genotype_filename}.bim -f ${genotype_filename}.frq -r /home/clarklc/Programs/HRC.r1-1.GRCh37.wgs.mac5.sites.tab -h

printf "\n\nRunning the plink script to edit the genotype files...\n"

#run created script with all the plink commands; breaks into files for each chr
sh Run-plink.sh

printf "\n\nNow converting genotype files to dosage format...\n"

#convert to vcf and sort
for chr in $(seq 1 22); do
plink --bfile ${genotype_filename}-updated-chr${chr} --recode vcf --out ${genotype_filename}-updated-chr${chr};
vcf-sort ${genotype_filename}-updated-chr${chr}.vcf | bgzip -c > ${genotype_filename}-updated-chr${chr}.vcf.gz;
done
