setwd(getwd())
library(readr)
library(dplyr)

source("analysis_utils.R")

# Example usage
# process_p_values_directory("/Users/gpietrop/Desktop/pls_gp_R/results/20_10_TRUE/p_values")

# Example usage
# Define the specific matrix you want to check against
specific_matrix <- matrix(
  c(0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0,
    1, 1, 1, 0, 0, 0,
    1, 1, 1, 1, 0, 0,
    1, 1, 1, 1, 1, 0),
  nrow = 6, byrow = TRUE
)

folder_path <- "/Users/gpietrop/Desktop/pls_gp_R/results_paper/200_100_TRUE/str3/"
run <- "str3_med_100"

# folder_path <- "/Users/gpietrop/Desktop/pls_gp_R/results_paper/200_100_TRUE/str2/str2_small_100/"
# run <- "4"

path <- paste0(folder_path, run)

# Call the function with the folder path and the specific matrix
check <- check_matrices(path, specific_matrix)

mean_matrix <- calculate_mean_matrix(path)
# print(mean_matrix)
