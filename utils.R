update_p_value_file <- function(file_name, p_name, p_val) {
  # Read the existing file
  df <- read.table(file_name, header = TRUE, stringsAsFactors = FALSE, sep = "\t", fill = TRUE)
  
  # Add a new column for the current run
  new_col_name <- paste0("Run", ncol(df))  # Example: Run1, Run2, etc.
  df[[new_col_name]] <- NA  # Initialize new column with NA
  
  # Fill in p-values for current run
  for (i in 1:length(p_name)) {
    connection <- p_name[i]
    df[df$Connection == connection, new_col_name] <- p_val[i]
  }
  
  # Write the updated data frame back to the file
  write.table(df, file = file_name, row.names = FALSE, quote = FALSE, sep = "\t")
}
