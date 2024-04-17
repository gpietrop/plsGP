library(GA)
library(parallel)
library(doParallel)

source("fitness.R")

# Setup parallel environment
numCores <- detectCores()  # Detect the number of cores
cl <- makeCluster(numCores)  # Create a cluster
registerDoParallel(cl)  # Register the parallel backend

# Set GA parameters

ga_control <- ga(
  type = "binary",                   # Type of GA (binary for 0/1 matrix elements)
  nBits = 6 * 6,                     # Total number of bits (elements in the matrix)
  popSize = 1000,                      # Population size
  maxiter = 100,                     # Maximum number of iterations
  pcrossover = 0.8,
  fitness = combined_fitness_fixed,  # Fitness function
  elitism = TRUE,                    # Use elitism
  parallel = FALSE,                  # Enable parallel processing
  seed = 123                         # Set a seed for reproducibility
)

# Run the genetic algorithm
ga_result <- ga_control
plot(ga_result)

# Print results
cat("Best solution found:\n")
print(matrix(ga_result@solution, nrow = 6, byrow = TRUE))
cat("Fitness of the best solution:", ga_result@fitnessValue, "\n")

# Stop and unregister the parallel cluster
stopCluster(cl)
