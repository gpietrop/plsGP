# Ensure the cSEM library and your model creation function are loaded
library(cSEM)
library(igraph)

# import model.R expecially: create_sem_model_string_from_matrix
source("model_generated.R")
source("fitness_utils.R")

admiss_individuals_all <- list()
best_individual <<- NULL
best_fitness <<- -Inf

# Combined fitness function
combined_fitness_fixed <- function(matrix_vector, variables, measurement_model, structural_coefficients, type_of_variable, dataset_generated) {
  adj_matrix <- matrix(matrix_vector, nrow = 3, byrow = TRUE)
  
  diag(adj_matrix) <- 0 # Set the diagonal elements of the matrix to zero
  adj_matrix[1, ] <- 0 # Set all elements in the first row to zero
  
  # Check each column to ensure at least one non-zero entry
  if (any(colSums(adj_matrix) == 0)) {
    # cat("One or more constructs are not used in the structural model.\n")
    adj_matrix <- repair_individual_unused(adj_matrix)
  }
  
  # Convert the matrix to an igraph object
  g <- graph_from_adjacency_matrix(adj_matrix, mode = "directed", diag = FALSE)
  
  # Check for cycles using girth, which finds the shortest cycle
  has_cycle <- !is.infinite(girth(g)$girth)
  if (has_cycle) {
    return(-10000)  # The matrix has cyclic dependencies
  } 
  
  # Check if the solution is admissible 
  model_string <- create_sem_model_string_from_matrix(adj_matrix, variables, measurement_model, structural_coefficients, type_of_variable)
  out <- csem(.data = dataset_generated,.model = model_string)
  ver = verify(out)
  if (!sum(ver) == 0) {
    return(-10000)  # Penalize configurations where any construct is unused
  }
  
  # SEM fitness calculation (using the negative of AIC to make higher values more fit)
  sem_fitness <- -fitness(adj_matrix, variables, measurement_model, structural_coefficients, type_of_variable, dataset_generated)
  # print(sem_fitness)
  if (is.na(sem_fitness)) {
    return(-10000)
  }
  
  # Store the modified individual
  admiss_individuals_all <<- append(admiss_individuals_all, list(adj_matrix))
  if (sem_fitness > best_fitness) {
    best_individual <<- adj_matrix
    best_fitness <<- sem_fitness
  }
  
  return(sem_fitness)
}


# Define the fitness function
fitness <- function(adj_matrix, variables, measurement_model, structural_coefficients, type_of_variable, dataset_generated) {
  # Create the model string from the adjacency matrix
  model_string <- create_sem_model_string_from_matrix(adj_matrix, variables, measurement_model, structural_coefficients, type_of_variable)
  # Load data and perform SEM analysis
  out <- csem(.data = dataset_generated, .model = model_string)
  
  # Calculate model selection criteria
  model_criteria <- calculateModelSelectionCriteria(out, 
                                                    .by_equation = FALSE)
  # Extract the AIC values
  aic_values <- model_criteria$AIC
  # Return the AIC values as a vector
  # return(as.vector(aic_values))
  return(aic_values)
}


# # Define fitness input 
# # List of variable names
# variables <- c("eta1", "eta2", "eta3")
# 
# # Measurement model (specify which manifest variables are associated with which latent variables)
# measurement_model <- list(
#   eta1 = c("y1", "y2", "y3"),
#   eta2 = c("y4", "y5", "y6"),
#   eta3 = c("y7", "y8")
# )
# 
# # Types of variables (composite or reflective)
# type_of_variable <- c(eta1 = "composite", eta2 = "composite", eta3 = "reflective")
# 
# # Structural coefficients (optional and unused in the provided function)
# structural_coefficients <- list()
# 
# 
# model_string_true <- '
#   # Measurement model
#   eta1 =~ 0.7*y1 + 0.7*y2 + 0.7*y3
#   eta2 =~ 0.8*y4 + 0.8*y5 + 0.8*y6
#   eta3 =~ 0.8*y7 + 0.8*y8
#   
#   # Structural model
#   eta2 ~ 1*eta1
#   eta3 ~ 1*eta2
# '
# 
# # Generate data based on the specified model
# dataset_generated <- generateData(
#   .model = model_string_true,    # Use the generated model string
#   .n     = 1000,             # Number of observations
#   .return_type = "data.frame"
# )
# 
# adj_matrix <- matrix(c(0, 0, 0,
#                        1, 0, 0,
#                        1, 1, 0),
#                      nrow = 3, byrow = TRUE)
# # Call the modified function
# model_string <- create_sem_model_string_from_matrix(adj_matrix, variables, measurement_model, structural_coefficients, type_of_variable)
# out <- csem(.data = dataset_generated, .model = model_string)
# verify(out)
# 
# aic_values <- model_criteria$AIC
# # Print the resulting SEM model string
# cat(model_string)
# fitness(adj_matrix, variables, measurement_model, structural_coefficients, type_of_variable, dataset_generated)
