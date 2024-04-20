library(GA)
library(parallel)
library(doParallel)

source("fitness_generated.R")

# Define fitness input 
# List of variable names
variables <- c("eta1", "eta2", "eta3")

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


# Set GA parameters
ga_control <- ga(
  type = "binary",                   
  nBits = 3 * 3,                     
  popSize = 1000,                     
  maxiter = 100,                     
  pcrossover = 0.8,
  pmutation = 0.5, 
  fitness = function(x) combined_fitness_fixed(x, variables, measurement_model, structural_coefficients, type_of_variable, dataset_generated),
  elitism = TRUE,                    
  parallel = FALSE,                  
  seed = 124                        
)

# Run the genetic algorithm
ga_result <- ga_control
plot(ga_result)

# Print results
cat("Best solution found:\n")
print(best_individual)


cat("Fitness of the best solution:", ga_result@fitnessValue, "\n")

# Stop and unregister the parallel cluster
stopCluster(cl)
