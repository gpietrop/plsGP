# Ensure the cSEM library and your model creation function are loaded
library(cSEM)
library(igraph)

# import model.R expecially: create_sem_model_string_from_matrix
source("model_generated.R")
source("fitness_utils.R")

best_individuals_all <<- list()
best_individual <<- NULL
best_fitness <<- -Inf

# Combined fitness function
combined_fitness_fixed <- function(matrix_vector, variables, measurement_model, structural_coefficients, type_of_variable, dataset_generated) {
  n_variables <- length(variables)
  adj_matrix <- matrix(matrix_vector, nrow = n_variables, byrow = TRUE)
  
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
  # has_cycle <- !is.infinite(girth(g)$girth)
  has_cycle <- has_cycle_dfs(g, adj_matrix)
  if (has_cycle) {
    return(-100000)  # The matrix has cyclic dependencies
  } 
  
  # Check if the solution is admissible 
  model_string <- create_sem_model_string_from_matrix(adj_matrix, variables, measurement_model, structural_coefficients, type_of_variable)
  out <- csem(.data = dataset_generated,.model = model_string)
  ver = verify(out)
  if (!sum(ver) == 0) {
    return(-100000)  # Penalize configurations where any construct is unused
  }
  
  # SEM fitness calculation (using the negative of AIC to make higher values more fit)
  sem_fitness <- -fitness(adj_matrix, variables, measurement_model, structural_coefficients, type_of_variable, dataset_generated)
  # print(sem_fitness)
  if (is.na(sem_fitness)) {
    return(-100000)
  }
  
  # Store the modified individual
  # admiss_individuals_all <<- append(admiss_individuals_all, list(adj_matrix))
  if (sem_fitness > best_fitness) {
    best_individual <<- adj_matrix
    best_fitness <<- sem_fitness
    best_individuals_all <<- append(best_individuals_all, list(adj_matrix))
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
                                                    .by_equation = FALSE,
                                                    .only_structural = FALSE)
  # Extract the AIC values
  aic_values <- model_criteria$BIC
  # Return the AIC values as a vector
  # return(as.vector(aic_values))
  return(aic_values)
}


# source("hyperparameters.R")
# adj_matrix <- matrix(c(0, 0, 0,
#                        1, 0, 0,
#                        0, 1, 0),
#                      nrow = 3, byrow = TRUE)
# # Call the modified function
# model_string <- create_sem_model_string_from_matrix(adj_matrix, variables, measurement_model, structural_coefficients, type_of_variable)
# out <- csem(.data = dataset_generated, .model = model_string)
# verify(out)
# 
# # Print the resulting SEM model string
# fitness(adj_matrix, variables, measurement_model, structural_coefficients, type_of_variable, dataset_generated)
