# Load necessary libraries
library(GA)
library(optparse)

# Source the fitness function and any additional needed R scripts
source("model.R")
source("fitness_utils.R")
source("fitness.R")

# Parse options with optparse
option_list <- list(
  make_option(c("--popSize"), type="integer", default=100, help="Population size"),
  make_option(c("--maxiter"), type="integer", default=50, help="Maximum number of iterations"),
  make_option(c("--pmutation"), type="double", default=0.8, help="Mutation rate"),
  make_option(c("--pcrossover"), type="double", default=0.2, help="Crossover rate"),
  make_option(c("--seed"), type="integer", default=123, help="Seed for the GA")
)
opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

# Ensure the results directory exists
results_dir <- "res"
if (!dir.exists(results_dir)) {
  dir.create(results_dir)
}

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
    monitor = function(obj) obj@fitness
  )
  
  # Ensure a list is always returned, even if best_individual is NULL
  list(ga_best_fitness = ga_control@fitnessValue, tracked_best_individual = if (is.null(best_individual)) matrix(numeric(0), nrow = 6) else best_individual)
  
  # Save tracked best individual
  if (!is.null(best_individual) && length(best_individual) != 0) {
    write.csv(as.data.frame(t(best_individual)), file.path(results_dir, paste0("tracked_best_individual_", seed, ".csv")), row.names = FALSE)
  }
  
  # Save GA's best fitness
  write.csv(data.frame(Fitness = ga_control@fitnessValue), file.path(results_dir, paste0("ga_best_fitness_", seed, ".csv")), row.names = FALSE)
}

# Loop over a range of seeds
seed_start <- 100
seed_end <- 104
all_results <- lapply(seed_start:seed_end, run_ga)
