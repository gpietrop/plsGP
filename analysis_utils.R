get_best_individual <- function(folder_path) {
  # Read the hyperparameters file to get the true fitness value
  hyper_file <- file.path(folder_path, "hyperparameters.csv")
  hyper_data <- read.csv(hyper_file)
  true_fitness <- hyper_data$True.AIC[1]
  
  # List all fitness files
  fitness_files <- list.files(path = folder_path, pattern = "*_fitness.csv", full.names = TRUE)
  
  best_fitness <- Inf
  best_run <- NULL
  
  # Iterate over each fitness file
  for (file in fitness_files) {
    fitness_data <- read.csv(file)
    
    # Check if this fitness is the best so far
    current_best_fitness <- min(fitness_data$Fitness)
    if (current_best_fitness < best_fitness) {
      best_fitness <- current_best_fitness
      best_run <- gsub("_fitness.csv", "", basename(file))
    }
  }
  
  # If we found the best run, read the best individual
  if (!is.null(best_run)) {
    best_file <- file.path(folder_path, paste0(best_run, "_best.csv"))
    best_individual <- read.csv(best_file, row.names = 1)
    
    # Print best fitness and compare it to the fitness in hyperparameters.csv
    cat("Best fitness from all runs:", best_fitness, "\n")
    cat("Fitness from hyperparameters.csv (True AIC):", true_fitness, "\n")
    
    return(best_individual)
  } else {
    cat("No best individual found.\n")
    return(NULL)
  }
}

get_run_info <- function(folder_path, run_number) {
  # Read the hyperparameters file to get the true fitness value
  hyper_file <- file.path(folder_path, "hyperparameters.csv")
  hyper_data <- read.csv(hyper_file)
  true_fitness <- hyper_data$True.AIC[1]
  
  # Construct file paths based on the run number
  fitness_file <- file.path(folder_path, paste0(run_number, "_fitness.csv"))
  best_file <- file.path(folder_path, paste0(run_number, "_best.csv"))
  
  # Check if files exist
  if (!file.exists(fitness_file) || !file.exists(best_file)) {
    cat("Files for run", run_number, "not found.\n")
    return(NULL)
  }
  
  # Read the fitness file
  fitness_data <- read.csv(fitness_file)
  run_fitness <- min(fitness_data$Fitness)
  
  # Read the best individual file
  best_individual <- read.csv(best_file, row.names = 1)
  
  # Print comparison with the True.AIC value
  cat("Run", run_number, "fitness:", run_fitness, "\n")
  cat("Fitness from hyperparameters.csv (True AIC):", true_fitness, "\n")
  cat("Comparison result:", ifelse(run_fitness < true_fitness, "Better", "Worse or Equal"), "\n")
  
  return(list(fitness = run_fitness, best_individual = best_individual))
}


visualize_fitness_distribution <- function(folder_path) {
  # Read the hyperparameters file to get the target fitness value
  hyper_file <- file.path(folder_path, "hyperparameters.csv")
  hyper_data <- read.csv(hyper_file)
  true_fitness <- hyper_data$True.AIC[1]
  
  # List all fitness files
  fitness_files <- list.files(path = folder_path, pattern = "*_fitness.csv", full.names = TRUE)
  
  all_fitness <- c()
  
  # Collect fitness values from all files
  for (file in fitness_files) {
    fitness_data <- read.csv(file)
    all_fitness <- c(all_fitness, fitness_data$Fitness)
  }
  
  # Determine the y-axis limits to include the True.AIC value
  ylim <- range(all_fitness, true_fitness)
  
  # Plot the boxplot
  boxplot(all_fitness, main = "Fitness Distribution Across All Runs", ylab = "Fitness", ylim = ylim)
  abline(h = true_fitness, col = "red", lty = 2)
  legend("topright", legend = c("True AIC"), col = "red", lty = 2)
}
