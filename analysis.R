source("analysis_utils.R")


# Example usage
# Define the specific matrix you want to check against
specific_matrix <- matrix(
  c(0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0,
    1, 1, 1, 0, 0, 0,
    0, 0, 0, 1, 0, 0,
    0, 0, 0, 0, 1, 0),
  nrow = 6, byrow = TRUE
)

folder_path <- "/Users/gpietrop/Desktop/pls_gp_R/results_more_info/"
run <- "str1_high_500"
path <- paste0(folder_path, run)

# Call the function with the folder path and the specific matrix
check <- check_matrices(path, specific_matrix)

mean_matrix <- calculate_mean_matrix(path)
# print(mean_matrix)
