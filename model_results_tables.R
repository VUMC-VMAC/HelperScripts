library(formattable)

#function to create results tables of each model
model_results_table <- function(output_summary, pretty_var_name, table_caption, subheading_n=4){
  
  #set any p value column to just P
  colnames(output_summary)[grepl("P", colnames(output_summary)) | grepl("p", colnames(output_summary))] <- "P"
  
  cat(paste0("\n\n", paste(rep("#", subheading_n), collapse = ""), " Predictor: ", pretty_var_name, " \n"))
  tmp_results <- as.data.frame(output_summary, 
                               row.names = gsub("variables", pretty_var_name, row.names(output_summary))) %>% 
    round(., digits = 4) %>%
    formattable(., list("P"=formatter("span", style = x ~ style(color = ifelse(x < 0.05, "red", "black")))), 
                caption = table_caption)
  print(tmp_results)
  cat("\n\n")
}
