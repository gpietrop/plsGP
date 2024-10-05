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


# Function to check if a specific matrix is contained in a candidate matrix
is_matrix_contained <- function(specific_matrix, candidate_matrix) {
  # Check if all elements of specific_matrix that are 1 are also 1 in candidate_matrix
  all(specific_matrix == candidate_matrix | specific_matrix == 0)
}

# Function to check if a specific matrix is equal to a candidate matrix
is_matrix_equal <- function(specific_matrix, candidate_matrix) {
  # Check if all elements of specific_matrix are equal to those in candidate_matrix
  all(specific_matrix == candidate_matrix)
}

# Function to read all _best.csv files and check for the specific matrix
check_matrices <- function(folder_path, specific_matrix, print_examples = FALSE, num_examples = 1) {
  # List all _best.csv files
  if (!file.exists(folder_path)) {
    stop("Invalid folder path.")
  }
  
  best_files <- list.files(path = folder_path, pattern = "*_best.csv", full.names = TRUE)
  total <- length(best_files)
  count_cont <- 0
  count_cont_strict <- 0
  count_equal <- 0
  count_rc <- 0
  cont_strict_examples <- list()
  rc_examples <- list()
  
  # Iterate over each best file
  for (file in best_files) {
    candidate_matrix <- as.matrix(read.csv(file, row.names = 1))
    
    if (is_matrix_contained(specific_matrix, candidate_matrix)) {
      count_cont <- count_cont + 1
      if (!is_matrix_equal(specific_matrix, candidate_matrix)) {
        count_cont_strict <- count_cont_strict + 1
        if (print_examples && length(cont_strict_examples) < num_examples) {
          cont_strict_examples[[length(cont_strict_examples) + 1]] <- candidate_matrix
        }
      }
    }
    if (is_matrix_equal(specific_matrix, candidate_matrix)) count_equal <- count_equal + 1
    if (is_matrix_contained(candidate_matrix, specific_matrix) && !is_matrix_equal(specific_matrix, candidate_matrix)) {
      count_rc <- count_rc + 1
      if (print_examples && length(rc_examples) < num_examples) {
        rc_examples[[length(rc_examples) + 1]] <- candidate_matrix
      }
    }
  }
  
  cat("\n================== Matrix Containment Summary ==================\n")
  cat("Total matrices analyzed:", total, "\n\n")
  
  cat("1. Original matrix contained in generated matrices:\n")
  cat("   - Total occurrences:", count_cont, "\n")
  cat("   - Proportion:", round(count_cont / total, 4), "\n\n")
  
  cat("2. Original matrix strictly contained in generated matrices (not equal):\n")
  cat("   - Total occurrences:", count_cont_strict, "\n")
  cat("   - Proportion:", round(count_cont_strict / total, 4), "\n\n")
  
  cat("3. Original matrix equal to generated matrices:\n")
  cat("   - Total occurrences:", count_equal, "\n")
  cat("   - Proportion:", round(count_equal / total, 4), "\n\n")
  
  cat("4. Generated matrices strictly contained in original matrix:\n")
  cat("   - Total occurrences:", count_rc, "\n")
  cat("   - Proportion:", round(count_rc / total, 4), "\n")
  
  if (print_examples) {
    if (length(cont_strict_examples) > 0) {
      cat("\nExamples of matrices strictly contained in generated matrices:\n")
      for (i in seq_along(cont_strict_examples)) {
        cat("\nExample", i, "(Strictly Contained in Generated):\n")
        print(cont_strict_examples[[i]])
      }
    }
    if (length(rc_examples) > 0) {
      cat("\nExamples of generated matrices strictly contained in the original matrix:\n")
      for (i in seq_along(rc_examples)) {
        cat("\nExample", i, "(Strictly Contained in Original):\n")
        print(rc_examples[[i]])
      }
    }
  }
  cat("\n===============================================================\n")
}


# Function to calculate the mean of all matrices in _best.csv files
calculate_mean_matrix <- function(folder_path) {
  # List all _best.csv files
  best_files <- list.files(path = folder_path, pattern = "*_best.csv", full.names = TRUE)
  
  total_matrices <- length(best_files)
  
  if (total_matrices == 0) {
    cat("No matrices found.\n")
    return(matrix(0, nrow = 6, ncol = 6))
  }
  
  sum_matrix <- matrix(0, nrow = 6, ncol = 6)
  
  # Iterate over each best file and sum the matrices
  for (file in best_files) {
    candidate_matrix <- as.matrix(read.csv(file, row.names = 1))
    sum_matrix <- sum_matrix + candidate_matrix
  }
  
  cat("Mean of all the matrices generated: \n")
  mean_matrix <- sum_matrix / total_matrices
  print(round(mean_matrix, 2))
  
  return
}


process_p_values_directory <- function(input_dir) {
  
  # Create output directory 'p_values_for_tkz' at the same level as the input directory
  output_dir <- file.path(dirname(input_dir), "p_values_for_tkz")
  if (!dir.exists(output_dir)) {
    dir.create(output_dir)
  }
  
  # List all files in the input directory
  files <- list.files(input_dir, full.names = TRUE)
  
  # Process each file
  for (file_path in files) {
    # Extract file name without extension for naming purposes
    file_name <- tools::file_path_sans_ext(basename(file_path))
    
    # Create a subdirectory for the current file in the 'p_values_for_tkz' folder
    subdirectory <- file.path(output_dir, paste0("bp_", file_name))
    if (!dir.exists(subdirectory)) {
      dir.create(subdirectory)
    }
    
    # Read the current file
    data <- read_delim(file_path, delim = "\t", , show_col_types = FALSE)
    
    # Remove the first row (assuming it contains run names)
    data <- data[-1, ]
    
    # Process each row to create individual files
    for (i in 1:nrow(data)) {
      # Extract connection name and sanitize it for file-system safety
      connection <- gsub(" ~ ", "_", data$Connection[i])
      
      # Get non-NA values, excluding the 'Connection' column
      non_na_values <- as.numeric(data[i, -1])
      non_na_values <- non_na_values[!is.na(non_na_values)]
      
      # Create the file inside the subdirectory
      file_name <- paste0(subdirectory, "/bp_", connection, ".txt")
      
      # Write "res" as the first line
      write.table("res", file = file_name, row.names = FALSE, col.names = FALSE, quote = FALSE)
      
      # Append the non-NA values
      write.table(non_na_values, file = file_name, row.names = FALSE, col.names = FALSE, quote = FALSE, append = TRUE)
    }
  }
}

