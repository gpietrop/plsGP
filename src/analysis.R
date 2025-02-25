# Load necessary libraries
library(readr)
library(dplyr)
library(here)

# Source custom utility functions
source("analysis_utils.R")

# Define the specific matrices for different str values
specific_matrices_list <- list(
  str1 = matrix(
    c(0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0,
      1, 1, 1, 0, 0, 0,
      0, 0, 0, 1, 0, 0,
      0, 0, 0, 0, 1, 0),
    nrow = 6, byrow = TRUE
  ),
  str2 = matrix(
    c(0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0,
      1, 1, 1, 0, 0, 0,
      0, 0, 1, 1, 0, 0,
      1, 0, 0, 0, 1, 0),
    nrow = 6, byrow = TRUE
  ),
  str3 = matrix(
    c(0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0,
      1, 1, 1, 0, 0, 0,
      0, 0, 0, 1, 0, 0,
      1, 0, 1, 0, 1, 0),
    nrow = 6, byrow = TRUE
  ),
  str4 = matrix(
    c(0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0,
      1, 1, 1, 0, 0, 0,
      1, 1, 1, 1, 0, 0,
      1, 1, 1, 1, 1, 0),
    nrow = 6, byrow = TRUE
  )
)

# Function to process matrices in a given folder path
process_folder <- function(str_id, run_suffix, print_examples = FALSE, num_examples = 3) {
  # Select the corresponding matrix based on str_id
  specific_matrix <- specific_matrices_list[[str_id]]
  # Construct the folder path using `str_id`
  folder_path <- here("results", "200_100_TRUE", str_id)
  path <- file.path(folder_path, paste0(str_id, "_", run_suffix))
  # print(path)
  # Check matrices against the specific matrix
  check <- check_matrices(path, specific_matrix, print_examples, num_examples)
  
  # Calculate the mean matrix
  mean_matrix <- calculate_mean_matrix(path)
  
  # top5 <- find_top_5_frequent_matrices(path)
  
  # Print the mean matrix (if needed)
  print(mean_matrix)
}

# Define `str_id` and `run_suffix`
str_id <- "str4"  # Change to "str2" or "str3" as needed

run_suffix <- "high_500"

# Process the folder with the defined parameters
process_folder(str_id, run_suffix, FALSE)
# calculate_mean_matrix()

