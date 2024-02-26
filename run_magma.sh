#!/bin/bash

set -e

#be sure that magma (/home/mahone1/Programs/magma/) is in your path

#parse the arguments, pulled this structure from : https://jonalmeida.com/posts/2013/05/26/different-ways-to-implement-flags-in-bash/
while [ ! $# -eq 0 ]
do
	case "$1" in
		--geno_file | -b )
			geno_file=$2
			;;
		--res_dir | -r )
			res_dir=$2
			;;
		--gwas_res )
			gwas_res=$2
			;;
		--type | -t )
			type=$2 #meta or plink
			;;
		--gene_annot | -g )
			if [ $2 != "run" ]; then
				#set the gene_annot variable if the option was not to run it. Will check for this variable later and run the gene annotation if it is not set.
				gene_annot=$2
			fi
			;;
		--out_prefix )
			out_prefix=$2
			;;
	esac
	shift #to the argument
	shift #to the next option
done

#annotate the SNPs if there is no supplied annotation file
if [ -z ${gene_annot+x} ]; then
	magma --annotate --snp-loc ${geno_file}.bim --gene-loc /home/mahone1/Programs/magma/NCBI37.3.gene.loc.symbols --out ${res_dir}/$out_prefix
	gene_annot=$( echo "${res_dir}/$out_prefix" )
fi

if [ $type == "meta" ]; then
	#gene test
	magma --bfile $geno_file --pval $gwas_res use=rs_number,p-value ncol=n_samples --gene-annot $gene_annot --out ${res_dir}/$out_prefix
else
	#gene test
	magma --bfile $geno_file --pval $gwas_res ncol=NMISS --gene-annot $gene_annot --out ${res_dir}/$out_prefix
fi

#pathway test
magma --gene-results ${res_dir}/${out_prefix}.genes.raw --set-annot /home/mahone1/Programs/magma/custom_pathways.txt --out ${res_dir}/$out_prefix

