library(GA)
library(optparse)

source("my_fitness.R")
source("ga_operators.R")
source("hyperparameters.R")
source("run_model.R")
source("utils.R")

# Parse options with optparse
option_list <- list(
  make_option(c("--model"), default="str3_small", help="Model to use"),
  make_option(c("--modeDim"), type="integer", default=100, help="Sample size"),
  make_option(c("--popSize"), type="integer", default=200, help="Population size"),
  make_option(c("--maxiter"), type="integer", default=100, help="Maximum iterations"),
  make_option(c("--pmutation"), type="double", default=1.0, help="Mutation rate"),
  make_option(c("--pcrossover"), type="double", default=0.8, help="Crossover rate"),
  make_option(c("--seed_start"), type="integer", default=0, help="First seed for the GA"),
  make_option(c("--seed_end"), type="integer", default=99, help="Last seed for the GA"),
  make_option(c("--treeRows"), type="logical", default=TRUE, help="Use treeRow-specific mutation and fitness")
)

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

if (startsWith(opt$model, "str1")) {
  run_specific_model <- run_sem_model_str1
  result_dir_str = "str1"
} else if (startsWith(opt$model, "str2")) {
  run_specific_model <- run_sem_model_str2
  result_dir_str = "str2"
} else if (startsWith(opt$model, "str3")) {
  run_specific_model <- run_sem_model_str3
  result_dir_str = "str3"
} else if (startsWith(opt$model, "str4")) {
  run_specific_model <- run_sem_model_str4
  result_dir_str = "str4"
} else {
  stop("Model string does not start correctly.")
}

# Define a results directory based on the current timestamp
hyperparam_subdir = paste(opt$maxiter, opt$popSize, opt$treeRows, sep = "_")
results_dir <- file.path("results", hyperparam_subdir)
results_subdir <- file.path(results_dir, result_dir_str)
model_subdir <- paste(opt$model, opt$modeDim, sep="_")
subdir <- file.path(results_subdir, model_subdir)
if (!dir.exists(subdir)) {
  dir.create(subdir, recursive = TRUE)
}

# Define all possible eta connections (36 combinations)
etas <- paste0("eta", 1:6)
all_connections <- as.vector(outer(etas, etas, function(x, y) ifelse(x != y, paste(x, "~", y), NA)))
all_connections <- all_connections[!is.na(all_connections)]  # Remove NA (same eta comparisons)

# Define the file for storing p-values
p_value_subdir <- file.path(results_dir, "p_values")
if (!dir.exists(p_value_subdir)) {
  dir.create(p_value_subdir, recursive = TRUE)
}
p_value_name_file = paste("p", opt$model, opt$modeDim, sep="_")
p_value_file = file.path(p_value_subdir, p_value_name_file)

# Initialize the file with all connections if it doesn't exist
if (!file.exists(p_value_file)) {
  # Create a new data frame with all possible connections and no p-values yet
  df <- data.frame(Connection = all_connections)
  write.table(df, file = p_value_file, row.names = FALSE, quote = FALSE, sep = "\t")
}

# Function to run GA with different seeds
run_ga <- function(seed) {
  # Reset best individual and fitness at the start of each run
  best_individuals_all <<- list()
  best_individual <<- NULL
  best_fitness <<- -Inf
  
  # generate a different dataset
  dataset_generated <- generateData(
    .model = get(opt$model),    
    .n     = opt$modeDim,             
    .return_type = "data.frame",
    .empirical = FALSE
  )
  
  # Save the dataset to a CSV file
  write.csv(dataset_generated, file.path(subdir, paste0(seed, "_dataset_generated.csv")), row.names = FALSE)
  
  # get the AIC of the true model 
  bic_true = run_specific_model(dataset_generated)
  cat("The true model has BIC: ", bic_true, "\n")
  
  # Save the results and hyperparameters
  hyperparams <- data.frame(
    "Population Size" = opt$popSize,
    "Max Iterations" = opt$maxiter,
    "Mutation Rate" = opt$pmutation,
    "Crossover Rate" = opt$pcrossover,
    "True BIC" = bic_true, 
    "TreeRows" = opt$treeRows
  )
  
  # Save hyperparameters to a CSV file 
  write.csv(hyperparams, file.path(subdir, paste0(seed, "_hyperparameters.csv")), row.names = FALSE, quote = FALSE)
  
  # Time the GA execution
  ga_time <- system.time({
    
    fitness_function <- if (opt$treeRows) myFitnessTreeRowZero else myFitness
    mutation_function <- if (opt$treeRows) myMutationTreeRowZero else myMutation
    
    ga_control <- ga(
      type = "binary",
      nBits = n_variables * n_variables,
      popSize = opt$popSize,
      maxiter = opt$maxiter,
      pmutation = opt$pmutation,
      pcrossover = opt$pcrossover,
      fitness = function(x) fitness_function(x, variables, measurement_model, structural_coefficients, type_of_variable, dataset_generated),
      elitism = TRUE,
      parallel = FALSE,
      seed = seed,
      mutation = mutation_function
    )
  })
  
  # Save the computation time to a file
  write.csv(data.frame(ComputationTime = ga_time['elapsed']), file.path(subdir, paste0(seed, "_time.csv")), row.names = FALSE)
  
  # Compute the p-values 
  model_string_best <- create_sem_model_string_from_matrix(best_individual, variables, measurement_model, structural_coefficients, type_of_variable)
  out_best <- csem(.data = dataset_generated,.model = model_string_best, .resample_method = "bootstrap")
  
  summar <- cSEM::summarize(out_best)
  p_val <- round(summar$Estimates$Path_estimates$p_value, 4)
  p_name <- summar$Estimates$Path_estimates$Name
  
  # Update p-value file
  update_p_value_file(p_value_file, p_name, p_val)
  
  # Save tracked best individual
  if (!is.null(best_individual) && length(best_individual) != 0) {
    best_ind_df <- as.data.frame(best_individual)
    colnames(best_ind_df) <- variables
    rownames(best_ind_df) <- variables
    write.csv(best_ind_df, file.path(subdir, paste0(seed, "_best", ".csv")), row.names = TRUE)
  }
  
  # Save GA's best fitness
  write.csv(data.frame(Fitness = - ga_control@fitnessValue), file.path(subdir, paste0(seed, "_fitness", ".csv")), row.names = FALSE)
}

# Loop over a range of seeds
seed_start <- opt$seed_start
seed_end <- opt$seed_end
all_results <- lapply(seed_start:seed_end, run_ga)

