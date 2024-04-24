library(GA)
library(parallel)
library(doParallel)

source("fitness.R")

# Set GA parameters

ga_control <- ga(
  type = "binary",                   # Type of GA (binary for 0/1 matrix elements)
  nBits = 6 * 6,                     # Total number of bits (elements in the matrix)
  popSize = 100,                      # Population size
  maxiter = 100,                     # Maximum number of iterations
  pmutation = 0.2,
  pcrossover = 0.8,
  fitness = combined_fitness_fixed,  # Fitness function
  elitism = TRUE,                    # Use elitism
  parallel = FALSE,                  # Enable parallel processing
  seed = 12884                         # Set a seed for reproducibility
)

print(best_individual)

# Run the genetic algorithm
ga_result <- ga_control
plot(ga_result)
