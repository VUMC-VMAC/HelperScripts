# CNT Helper Scripts

This repository contains aassorted convenience scripts for commonly run tasks. Any edits should be as generalizable as possible. Scripts (in general) should not be specific to any one cohort, but should have shared functionality among all the cohorts. If need be, use arguments to specify the aspects of the script which are particular to each cohort.

## Usage examples

### Build or update R variables

#### find_remove_outliers.R

Script contains a function to remove outliers from continuous data. Data can be one column or multiple. Default is to remove any observations >4 standard deviations from the mean. Usage: rm_outliers(data[,cols_to_filter], cutoff = 4)

#### build_apoe_counts.R

Function to build the variables containing APOE count and positivity for e4, e2, and e3. Usage: build_apoe_counts(df,apoe_var_name,e22,e23,e24,e33,e34,e44)

#### build_race_variable.R

Function to build a variable containing race categories of Other, NHW, and NHB, given a dataframe, the variable with current race categories followed by the values indicating white and black in that variable, the variable with current ethnicity categories followed by the value for non-Hispanic in that variable. Usage: build_race_variable(df,race_var_name,white,black,ethnicity_var_name,non_hispanic)

#### build_sex_variable.R

Function to build a standardized sex variable with 0=unknown, 1=male, and 2=female. Supply a dataframe, the name of the current sex variable, and the current values indicating male and female. Usage: build_sex_variable(df,sex_var_name,males,females)

#### diffusion_longitudinal_descriptives.R

Generates slopes and calculates interval from baseline for MEM and EXF. Note that this script requires the get_slopes() function to have been sourced as well. Also, this assumes many variable names. Usage: longitudinal_descriptives(cohort,minimum_number_of_visits)

#### longitudinal_descriptives.R

Generates slopes and calculates interval from baseline for MEM, EXF, and LAN. Note that this script requires the get_slopes() function to have been sourced as well. Usage: Also, this assumes many variable names. longitudinal_descriptives(cohort,minimum_number_of_visits)

#### get_slopes.R

Function to calculate slopes from longitudinal data. Returns a dataframe with sample IDs and slopes with the supplied label. Usage: get_slopes(input,outcome,interval,id,label)

#### get_slopes_advanced.R

Same as the get_slopes() function by with a few lines to ensure that the desired columns are chosen by exact name - helpful if you have other columns which contain the name of the columns needed. Usage: get_slopes_advanced(input,outcome,time,id,label)

#### recodeBlom.R

Function to perform Blom transformation on however many variables are supplied. Give the function a dataframe, a variable list and a corresponding list of new variable names for the transformed variables. Usage: recodeBlom(df,varlist_orig,varlist_tr)

### Descriptives functions

There are several R functions to obtain basic descriptives information. 

#### get_descriptives_summary.R

Returns mean and standard deviation or percentage as well as sample size for each column input. Type must be either "cont" for continuous or "cat" for categorical. Usage: get_descriptives(input, variables, type)

#### get_descriptives_group.R

Returns mean, standard deviation, minimum, maximum, and sample size for each column input in each group specified in the grouping variable as well as F-stat, p-value, and degrees of freedom for the differences between groups. Usage: get_descriptives(input, variables, group)

#### get_descriptives_group_Ttest.R

Gives the same output as get_descriptives_group.R except that it runs a t-test rather than an anova. Usage: get_descriptives(input, variables, group)

#### get_descriptives_group_summary.R

Gives the same usage as get_descriptives_group.R except that it adds a column with mean +/- standard deviation across all the data. Usage: get_descriptives(input, variables, group, type)

### filter_relatedness_using_master.R

Script to identify related pairs between cohorts with genetic data, given files with sample IDs and cohort names. It checks against all_related_pairs.txt and outputs a file (ending in "_relatedexclusion.txt") containing a list of IDs to drop to obtain an unrelated set. Usage: Rscript filter_relatedness_using_master.R -f file1,file2 -c cohort1,cohort2 -o output 

### Plotting scripts

#### get_spaghetti_plot.R

Script to generate a fitted spaghetti plot with a variety of optional customizations. Usage: get_spaghetti_plot(input,id_var,xaxis_var,yaxis_var,group_var,col1,col2,col3,col4=NULL,xlabel,ylabel, plottitle=NULL, group_label = NULL, print_legend = FALSE, legend_loc = NULL)

#### get_spaghetti_plot_fitted_MS_exp.R

Script to generate a fitted spaghetti plot based on the square of the supplied x-axis variable. Usage: get_spaghetti_plot_fitted(input,id_var,xaxis_var,yaxis_var,group_var,plottitle)

#### get spaghetti_plot_fitted_MS.R

Script to generate a fitted spaghetti plot. Usage: get_spaghetti_plot_fitted(input,id_var,xaxis_var,yaxis_var,group_var,plottitle)

#### get_spaghetti_plot_nofitted.R

Script to generate an unfitted spaghetti plot. Usage: get_spaghetti_plot_nofitted(input,id_var,xaxis_var,yaxis_var,group_var,plottitle)

#### man_qq_plots_noNA.R

Script to generate manhattan and QQ plots for GWAS results, excluding variants with NA results. QQ plot will also indicate the lambda, an inflation statistic. Usage: Rscript man_qq_plots_noNA.R gwas_results_file bim_file_if_meta_results

#### qq_plot.R

Script to generate QQ plot only for GWAS results, excluding variants with NA results. QQ plot will also indicate the lambda, an inflation statistic. Usage: Rscript qq_plot.R gwas_results_file

#### model_results_tables.R

Convenience script to generate results tables for individual linear regression results for use in RMarkdowns. The model results will be printed with the variable name and captions supplied and will assume that it is should be on the 4th subheading (ie under a heading like this: #### pretty_var_name) but this can be updated with the optional subheading_n input. Usage: model_results_table(output_summary, pretty_var_name, table_caption, subheading_n=4)

### load_all_libraries.R

Script to load 22 frequently used variables. To use, just source this script.

### read_in_AllRaces_PCs.R

A wrapper for reading in PCs calculated using smartpca that have been generated with all ancestral groups. Note that this only changes the column labels. Usage: read_in_AllRaces_PCs(AllRaces_PC_file_name)

### read_in_NHW_PCs.R

A wrapper for reading in PCs calculated	using smartpca that have been generated	with all ancestral groups. Note	that this only changes the column labels. Usage: read_in_NHW_PCs(NHW_PC_file_name)

### plink2GWAMA_modified.pl

Perl script to transform plink GWAS results files into files ready for meta-analysis in GWAMA. Modified from https://www.geenivaramu.ee/tools/PLINK2GWAMA.pl Usage: plink2GWAMA_modified.pl plink_results plink_frq_file output_file_name

### run_magma.sh

Script to run magma gene and pathway tests. Note that default annotations are for build 37. Usage: sh run_magma.sh -b genotype_data_stem -r directory_for_results --gwas_res gwas_results_file -t meta_or_plink -g opt_gene_annotation_file