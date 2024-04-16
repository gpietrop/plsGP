library(GA)
library(parallel)
library(doParallel)

# Define the fitness function
fitness_function <- function(matrix_vector) {
  adj_matrix <- matrix(matrix_vector, nrow = 6, byrow = TRUE)
  # Replace this with your actual fitness evaluation logic
  sum(adj_matrix)
}

# Setup parallel environment
numCores <- detectCores()  # Detect the number of cores
cl <- makeCluster(numCores)  # Create a cluster
registerDoParallel(cl)  # Register the parallel backend

# Set GA parameters
ga_control <- ga(
  type = "binary",                   # Type of GA (binary for 0/1 matrix elements)
  nBits = 6 * 6,                     # Total number of bits (elements in the matrix)
  popSize = 50,                      # Population size
  maxiter = 100,                     # Maximum number of iterations
  fitness = fitness_function,        # Fitness function
  elitism = TRUE,                    # Use elitism
  parallel = TRUE,                   # Enable parallel processing
  seed = 123                         # Set a seed for reproducibility
)

# Run the genetic algorithm
ga_result <- ga_control

# Print results
cat("Best solution found:\n")
print(matrix(ga_result@solution, nrow = 6, byrow = TRUE))
cat("Fitness of the best solution:", ga_result@fitnessValue, "\n")

# Stop and unregister the parallel cluster
stopCluster(cl)
