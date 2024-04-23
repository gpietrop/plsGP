# Load necessary libraries
library(GA)
library(optparse)

# Source the fitness function and any additional needed R scripts
source("fitness.R")
source("ga_operators.R")

# Parse options with optparse
option_list <- list(
  make_option(c("--popSize"), type="integer", default=100, help="Population size"),
  make_option(c("--maxiter"), type="integer", default=50, help="Maximum number of iterations"),
  make_option(c("--pmutation"), type="double", default=1.0, help="Mutation rate"),
  make_option(c("--pcrossover"), type="double", default=0.8, help="Crossover rate"),
  make_option(c("--seed_start"), type="integer", default=1, help="First seed for the GA"),
  make_option(c("--seed_end"), type="integer", default=10, help="Last seed for the GA")
)
opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

# Save the results and hyperparameters
hyperparams <- data.frame(
  "Population Size" = opt$popSize,
  "Max Iterations" = opt$maxiter,
  "Mutation Rate" = opt$pmutation,
  "Crossover Rate" = opt$pcrossover
)

# Define a results directory based on the current timestamp
results_dir <- "res"
timestamp <- format(Sys.time(), "%Y-%m-%d_%H")
subdir <- file.path(results_dir, paste0("run_", timestamp))

# Ensure the directory exists
if (!dir.exists(subdir)) {
  dir.create(subdir, recursive = TRUE)
}

# Save hyperparameters to a CSV file (once, not in the loop)
write.csv(hyperparams, file.path(subdir, "hyperparameters.csv"), row.names = FALSE, quote = FALSE)

# Define the names for the matrix dimensions
dim_names <- c("IMAG", "EXPE", "QUAL", "VAL", "SAT", "LOY")

# Function to run GA with different seeds
run_ga <- function(seed) {
  # Reset best individual and fitness at the start of each run
  best_individual <<- NULL
  best_fitness <<- -Inf
  
  ga_control <- ga(
    type = "binary",
    nBits = 6 * 6,
    popSize = opt$popSize,
    maxiter = opt$maxiter,
    pmutation = opt$pmutation,
    pcrossover = opt$pcrossover,
    fitness = combined_fitness_fixed,
    elitism = TRUE,
    parallel = FALSE,
    seed = seed,
    mutation = myMutation_satisfaction,  
    monitor = function(obj) obj@fitness
  )
  
  # Save tracked best individual
  if (!is.null(best_individual) && length(best_individual) != 0) {
    # Create a data frame from the matrix and add names
    best_ind_df <- as.data.frame(best_individual)
    colnames(best_ind_df) <- dim_names
    rownames(best_ind_df) <- dim_names
    write.csv(best_ind_df, file.path(subdir, paste0(seed, "_best", ".csv")), row.names = TRUE)
  }
  
  # Save GA's best fitness
  write.csv(data.frame(Fitness = - ga_control@fitnessValue), file.path(subdir, paste0(seed, "_fitness", ".csv")), row.names = FALSE)
  
  # Ensure a list is always returned, even if best_individual is NULL
  # list(ga_best_fitness = ga_control@fitnessValue, tracked_best_individual = if (is.null(best_individual)) matrix(numeric(0), nrow = 6) else best_individual)
  
}

# Loop over a range of seeds
seed_start <- opt$seed_start
seed_end <- opt$seed_end
all_results <- lapply(seed_start:seed_end, run_ga)

