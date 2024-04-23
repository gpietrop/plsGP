library(GA)
library(parallel)
library(doParallel)

source("fitness_generated.R")

# Parse options with optparse
option_list <- list(
  make_option(c("--popSize"), type="integer", default=10, help="Population size"),
  make_option(c("--maxiter"), type="integer", default=10, help="Maximum number of iterations"),
  make_option(c("--pmutation"), type="double", default=0.8, help="Mutation rate"),
  make_option(c("--pcrossover"), type="double", default=0.2, help="Crossover rate"),
  make_option(c("--seed_start"), type="integer", default=15, help="First seed for the GA"),
  make_option(c("--seed_end"), type="integer", default=30, help="Last seed for the GA")
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
results_dir <- "res_generated"
timestamp <- format(Sys.time(), "%Y-%m-%d_%H")
subdir <- file.path(results_dir, paste0("run_", timestamp))

# Ensure the directory exists
if (!dir.exists(subdir)) {
  dir.create(subdir, recursive = TRUE)
}

# Save hyperparameters to a CSV file (once, not in the loop)
write.csv(hyperparams, file.path(subdir, "hyperparameters.csv"), row.names = FALSE, quote = FALSE)

# List of variable names
variables <- c("eta1", "eta2", "eta3") # dir_names in the other script

# Measurement model (specify which manifest variables are associated with which latent variables)
measurement_model <- list(
  eta1 = c("y1", "y2", "y3"),
  eta2 = c("y4", "y5", "y6"),
  eta3 = c("y7", "y8")
)

# Types of variables (composite or reflective)
type_of_variable <- c(eta1 = "composite", eta2 = "composite", eta3 = "reflective")

# Structural coefficients (optional and unused in the provided function)
structural_coefficients <- list()

model_string_true <- '
  # Measurement model
  eta1 =~ 0.7*y1 + 0.7*y2 + 0.7*y3
  eta2 =~ 0.8*y4 + 0.8*y5 + 0.8*y6
  eta3 =~ 0.8*y7 + 0.8*y8
  
  # Structural model
  eta2 ~ 1*eta1
  eta3 ~ 1*eta2
'

# Generate data based on the specified model
dataset_generated <- generateData(
  .model = model_string_true,    # Use the generated model string
  .n     = 100,             # Number of observations
  .return_type = "data.frame"
)


# Function to run GA with different seeds
run_ga <- function(seed) {
  # Reset best individual and fitness at the start of each run
  best_individual <<- NULL
  best_fitness <<- -Inf
  
  ga_control <- ga(
    type = "binary",
    nBits = 3 * 3,
    popSize = opt$popSize,
    maxiter = opt$maxiter,
    pmutation = opt$pmutation,
    pcrossover = opt$pcrossover,
    fitness = function(x) combined_fitness_fixed(x, variables, measurement_model, structural_coefficients, type_of_variable, dataset_generated),
    elitism = TRUE,
    parallel = FALSE,
    seed = seed
    )
  
  # Save tracked best individual
  if (!is.null(best_individual) && length(best_individual) != 0) {
    # Create a data frame from the matrix and add names
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

