library(GA)
library(parallel)
library(doParallel)

source("fitness_generated.R")

# Define fitness input 
variables <- c("eta1", "eta2")
measurement_model <- list(
  eta1 = c("1*y1", "1*y2", "1*y3"),
  eta2 = c("1*y4", "1*y5", "1*y6")
)

model_string_true <- '
  # Measurement model
  eta1 =~ 0.7*y1 + 0.7*y2 + 0.7*y3
  eta2 =~ 0.8*y4 + 0.8*y5 + 0.8*y6
  
  # Structural model
  eta2 ~ 0.7*eta1
'
# Generate data based on the specified model
dataset_generated <- generateData(
  .model = model_string_true,    # Use the generated model string
  .n     = 100,             # Number of observations
  .return_type = "data.frame"
)


# Set GA parameters
ga_control <- ga(
  type = "binary",                   
  nBits = 2 * 2,                     
  popSize = 10,                     
  maxiter = 100,                     
  pcrossover = 0.8,
  fitness = function(x) combined_fitness_fixed(x, variables, measurement_model, dataset_generated),
  elitism = TRUE,                    
  parallel = FALSE,                  
  seed = 123                        
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
