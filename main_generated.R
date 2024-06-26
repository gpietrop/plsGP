library(GA)
library(optparse)

source("fitness_generated.R")
source("ga_operators.R")
source("hyperparameters.R")
source("run_model.R")

# Parse options with optparse
option_list <- list(
  make_option(c("--popSize"), type="integer", default=10, help="Population size"),
  make_option(c("--maxiter"), type="integer", default=100, help="Maximum number of iterations"),
  make_option(c("--pmutation"), type="double", default=1.0, help="Mutation rate"),
  make_option(c("--pcrossover"), type="double", default=0.8, help="Crossover rate"),
  make_option(c("--seed_start"), type="integer", default=0, help="First seed for the GA"),
  make_option(c("--seed_end"), type="integer", default=10, help="Last seed for the GA")
)
opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

# get the AIC of the true model 
aic_true = run_sem_model(dataset_generated)
cat("The true model has BIC: ", aic_true, "\n")

# Save the results and hyperparameters
hyperparams <- data.frame(
  "Population Size" = opt$popSize,
  "Max Iterations" = opt$maxiter,
  "Mutation Rate" = opt$pmutation,
  "Crossover Rate" = opt$pcrossover,
  "True AIC" = aic_true 
)

# Define a results directory based on the current timestamp
results_dir <- "res_generated"
timestamp <- format(Sys.time(), "%Y-%m-%d_%H")
subdir <- file.path(results_dir, paste0("run_", timestamp))

# Ensure the directory exists
if (!dir.exists(subdir)) {
  dir.create(subdir, recursive = TRUE)
}

# Save hyperparameters to a CSV file (once, not in the loop)
write.csv(hyperparams, file.path(subdir, "hyperparameters.csv"), row.names = FALSE, quote = FALSE)

# Function to run GA with different seeds
run_ga <- function(seed) {
  # Reset best individual and fitness at the start of each run
  best_individuals_all <<- list()
  best_individual <<- NULL
  best_fitness <<- -Inf
  
  ga_control <- ga(
    type = "binary",
    nBits = n_variables * n_variables,
    popSize = opt$popSize,
    maxiter = opt$maxiter,
    pmutation = opt$pmutation,
    pcrossover = opt$pcrossover,
    fitness = function(x) combined_fitness_fixed(x, variables, measurement_model, structural_coefficients, type_of_variable, dataset_generated),
    elitism = TRUE,
    parallel = FALSE,
    seed = seed,
    mutation = myMutationTriang
    )
  
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




