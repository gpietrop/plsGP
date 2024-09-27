# Load necessary libraries
library(readr)
library(dplyr)

# Set the working directory
setwd("/Users/gpietrop/Desktop/pls_gp_R/test")

# Read the data
data <- read_delim("p_values_n100_M.txt", delim = "\t")

# Remove the first row (which contains the run names)
data <- data[-1, ]

# Create the 'bp' directory if it doesn't exist
if (!dir.exists("bp")) {
  dir.create("bp")
}

# Loop over each row of the data to create individual files
for (i in 1:nrow(data)) {
  # Extract connection name and replace '~' and spaces to make it file-system friendly
  connection <- gsub(" ~ ", "_", data$Connection[i])
  
  # Get the non-NA values from the row, excluding the 'Connection' column
  non_na_values <- as.numeric(data[i, -1])
  non_na_values <- non_na_values[!is.na(non_na_values)]
  
  # Create the filename (use 'connection' in the filename)
  file_name <- paste0("bp/bp_", connection, ".txt")
  
  # Write the non-NA values to the file in the full path
  write.table(non_na_values, file = file_name, row.names = FALSE, col.names = FALSE, quote = FALSE)
}

