source("analysis_utils.R")


folder_path <- "/Users/gpietrop/Desktop/pls_gp_R/res_generated/"
run <- "run_2024-05-03_16"
path <- paste0(folder_path, run)
best_individual <- get_best_individual(path)
print(best_individual)

run_number <- 1  # Replace with the desired run number
result <- get_run_info(path, run_number)
print(result$best_individual)

visualize_fitness_distribution(path)

