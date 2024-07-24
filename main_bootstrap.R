library(GA)
library(optparse)

source("fitness_generated.R")
source("ga_operators.R")
source("hyperparameters.R")
source("run_model.R")

# Parse options with optparse
option_list <- list(
  make_option(c("--model"), default="str1_high", help="Model to use"),
  # make_option(c("--modeDim"), type="integer", default=100, help="Sample size"),
  make_option(c("--popSize"), type="integer", default=20, help="Population size"),
  make_option(c("--maxiter"), type="integer", default=100, help="Maximum iterations"),
  make_option(c("--pmutation"), type="double", default=1.0, help="Mutation rate"),
  make_option(c("--pcrossover"), type="double", default=0.8, help="Crossover rate"),
  make_option(c("--seed_start"), type="integer", default=0, help="First seed for the GA"),
  make_option(c("--seed_end"), type="integer", default=99, help="Last seed for the GA"),
  make_option(c("--treeRows"), type="logical", default=TRUE, help="Use treeRow-specific mutation and fitness"),
  make_option(c("--dataset_path"), 
              default="/Users/gpietrop/Desktop/pls_gp_R/results_paper/200_100_TRUE/str1/str1_med_100/0_dataset_generated.csv", 
              help="Path to the saved dataset CSV file")
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
} else {
  stop("Model string does not start with 'str1' or 'str2'")
}

# Extract dataset directory and seed from dataset_path
dataset_dir <- dirname(opt$dataset_path)
dataset_subdir <- basename(dataset_dir)
dataset_filename <- basename(opt$dataset_path)
dataset_seed <- sub("_dataset_generated.csv", "", dataset_filename)

# Define a results directory based on the current timestamp
hyperparam_subdir = paste(opt$maxiter, opt$popSize, opt$treeRows, sep = "_")
results_dir <- file.path("results_bootstrap", hyperparam_subdir)
subdir <- file.path(results_dir, dataset_subdir, dataset_seed)
# subdir <- paste(opt$model, opt$modeDim, sep="_")
# subdir <- file.path(results_subdir, model_subdir)
if (!dir.exists(subdir)) {
  dir.create(subdir, recursive = TRUE)
}

# Load or generate the dataset
if (!is.null(opt$dataset_path) && file.exists(opt$dataset_path)) {
  dataset_generated <- read.csv(opt$dataset_path)
  cat("Loaded dataset from", opt$dataset_path, "\n")
} else {
  dataset_generated <- NULL # generateData(
    # .model = get(opt$model),    # Use the generated model string
    # .n     = opt$modeDim,       # Number of observations
    # .return_type = "data.frame",
    # .empirical = FALSE
  # )
}

# Function to run GA with different seeds
run_ga <- function(seed) {
  # Reset best individual and fitness at the start of each run
  best_individuals_all <<- list()
  best_individual <<- NULL
  best_fitness <<- -Inf
  
  # Perform bootstrap sampling
  dataset_sampled <- dataset_generated[sample(nrow(dataset_generated), replace = TRUE), ]
  
  # Save the dataset to a CSV file
  write.csv(dataset_sampled, file.path(subdir, paste0(seed, "_dataset_generated.csv")), row.names = FALSE)
  
  # get the AIC of the true model 
  aic_true = run_specific_model(dataset_sampled)
  cat("The true model has BIC: ", aic_true, "\n")
  
  # Save the results and hyperparameters
  hyperparams <- data.frame(
    "Population Size" = opt$popSize,
    "Max Iterations" = opt$maxiter,
    "Mutation Rate" = opt$pmutation,
    "Crossover Rate" = opt$pcrossover,
    "True AIC" = aic_true, 
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
      fitness = function(x) fitness_function(x, variables, measurement_model, structural_coefficients, type_of_variable, dataset_sampled),
      elitism = TRUE,
      parallel = FALSE,
      seed = seed,
      mutation = mutation_function
    )
  })
  
  # Save the computation time to a file
  write.csv(data.frame(ComputationTime = ga_time['elapsed']), file.path(subdir, paste0(seed, "_time.csv")), row.names = FALSE)
  
  # Save tracked best individual
  if (!is.null(best_individual) && length(best_individual) != 0) {
    best_ind_df <- as.data.frame(best_individual)
    colnames(best_ind_df) <- variables
    rownames(best_ind_df) <- variables
    write.csv(best_ind_df, file.path(subdir, paste0(seed, "_best", ".csv")), row.names = TRUE)
  }
  
  # Save GA's best fitness
  write.csv(data.frame(Fitness = - ga_control@fitnessValue), file.path(subdir, paste0(seed, "_fitness", ".csv")), row.names = FALSE)
  
  # Create a directory for elites if it does not exist
  elite_dir <- file.path(subdir, paste0(seed, "_elites"))
  if (!dir.exists(elite_dir)) {
    dir.create(elite_dir)
  }
  
  # Save the elites
  if (exists("best_individuals_all") && length(best_individuals_all) > 0) {
    for (i in seq_along(best_individuals_all)) {
      elite_df <- as.data.frame(best_individuals_all[[i]])
      colnames(elite_df) <- variables  # Assuming you want to use 'variables' as column names
      write.csv(elite_df, file.path(elite_dir, paste0(seed, "_elite_", i, ".csv")), row.names = FALSE)
    }
  }
}

# Loop over a range of seeds
seed_start <- opt$seed_start
seed_end <- opt$seed_end
all_results <- lapply(seed_start:seed_end, run_ga)

