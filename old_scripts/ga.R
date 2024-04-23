library(GA)
library(parallel)
library(doParallel)

# Define the fitness function
fitness_function <- function(matrix_vector) {
  adj_matrix <- matrix(matrix_vector, nrow = 6, byrow = TRUE)
  sum(adj_matrix)  # Placeholder for actual fitness logic
}

# Setup parallel environment
numCores <- detectCores()  # Detect the number of cores
cl <- makeCluster(numCores)  # Create a cluster
registerDoParallel(cl)  # Register the parallel backend

# Custom mutation function
# Custom mutation function
# Custom mutation function
# Custom mutation function
# Correctly defined custom mutation function
mut <- function(object, parents) {
  nBits <- ncol(object@population)
  mutationRate <- 0.05  # Mutation rate
  
  # Access the specific parents' population
  parentsPopulation <- object@population[parents,,drop = FALSE]
  
  # Apply mutation
  for (i in 1:nrow(parentsPopulation)) {
    for (j in 1:nBits) {
      if (runif(1) < mutationRate) {
        parentsPopulation[i, j] <- 1 - parentsPopulation[i, j]  # Flip the bit
      }
    }
  }
  
  # Return only the mutated population part
  return(parentsPopulation)
}


# Set GA parameters with custom mutation
ga_control <- ga(
  type = "binary",
  nBits = 6 * 6,
  popSize = 10,
  maxiter = 100,
  fitness = fitness_function,
  pmutation = 0.2,
  pcrossover = 0.0,
  mutation = mut,  # Use custom mutation function
  elitism = TRUE,
  parallel = TRUE,
  seed = 123
)

# Run the genetic algorithm
ga_result <- ga_control

# Print results
cat("Best solution found:\n")
print(matrix(ga_result@solution, nrow = 6, byrow = TRUE))
cat("Fitness of the best solution:", ga_result@fitnessValue, "\n")

# Stop and unregister the parallel cluster
stopCluster(cl)
