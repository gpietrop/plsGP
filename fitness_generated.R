# Ensure the cSEM library and your model creation function are loaded
library(cSEM)
library(igraph)

# import model.R expecially: create_sem_model_string_from_matrix
source("mode_generated.R")
source("fitness_utils.R")

# Combined fitness function
combined_fitness_fixed <- function(matrix_vector, variables, measurement_model, dataset_generated) {
  adj_matrix <- matrix(matrix_vector, nrow = 2, byrow = TRUE)
  
  diag(adj_matrix) <- 0 # Set the diagonal elements of the matrix to zero
  adj_matrix[1, ] <- 0 # Set all elements in the first row to zero
  
  # Check each column to ensure at least one non-zero entry
  if (any(colSums(adj_matrix) == 0)) {
    # cat("One or more constructs are not used in the structural model.\n")
    # return(-10000)  # Penalize configurations where any construct is unused
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
  model_string <- create_sem_model_string_from_matrix(adj_matrix, variables, measurement_model, dataset_generated)
  # print(adj_matrix)
  # print(model_string)
  out <- csem(.data = dataset_generated,.model = model_string)
  ver = verify(out)
  if (!sum(ver) == 0) {
    return(-10000)  # Penalize configurations where any construct is unused
  }
  
  # SEM fitness calculation (using the negative of AIC to make higher values more fit)
  sem_fitness <- -fitness(adj_matrix, variables, measurement_model, dataset_generated)
  
  # Calculate combined fitness with the sparsity component weighted
  combined_score <- sem_fitness # + (0.5 * sparsity_fitness_value)
  
  return(combined_score)
}


# Define the fitness function
fitness <- function(adj_matrix, variables, measurement_model, dataset_generated) {
  # Create the model string from the adjacency matrix
  model_string <- create_sem_model_string_from_matrix(adj_matrix, variables, measurement_model)
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