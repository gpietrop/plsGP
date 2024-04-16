# Ensure the cSEM library and your model creation function are loaded
library(cSEM)
library(igraph)

# import model.R expecially: create_sem_model_string_from_matrix
source("model.R")

# Combined fitness function
combined_fitness_fixed <- function(matrix_vector) {
  adj_matrix <- matrix(matrix_vector, nrow = 6, byrow = TRUE)
  
  # Set the diagonal elements of the matrix to zero
  diag(adj_matrix) <- 0
  
  # Set all elements in the first row to zero
  adj_matrix[1, ] <- 0
  
  # Convert the matrix to an igraph object
  g <- graph_from_adjacency_matrix(adj_matrix, mode = "directed", diag = FALSE)
  
  # Check for cycles using girth, which finds the shortest cycle
  has_cycle <- !is.infinite(girth(g)$girth)

  if (has_cycle) {
    return(-10000)  # The matrix has cyclic dependencues, return a very low fitness score
    } 
 
  # Check each column to ensure at least one non-zero entry
  if (any(colSums(adj_matrix) == 0)) {
    # cat("One or more constructs are not used in the structural model.\n")
    return(-10000)  # Penalize configurations where any construct is unused
  }
  
  # Check if the solution is admissible 
  model_string <- create_sem_model_string_from_matrix(adj_matrix)
  out <- csem(.data = satisfaction,.model = model_string)
  ver = verify(out)
  if (!sum(ver) == 0) {
    # cat("Non admissible solution.\n")
    return(-10000)  # Penalize configurations where any construct is unused
  }
  
  # SEM fitness calculation (using the negative of AIC to make higher values more fit)
  sem_fitness <- -fitness(adj_matrix)
  
  # Sparsity fitness calculation
  sparsity_fitness_value <- sparsity_fitness(adj_matrix)
  
  # Calculate combined fitness with the sparsity component weighted
  combined_score <- sem_fitness # + (0.5 * sparsity_fitness_value)
  
  return(combined_score)
}


# Define the fitness function
fitness <- function(adj_matrix) {
  # Create the model string from the adjacency matrix
  model_string <- create_sem_model_string_from_matrix(adj_matrix)
  # Load data and perform SEM analysis
  out <- csem(.data = satisfaction, .model = model_string)
  # Calculate model selection criteria
  model_criteria <- calculateModelSelectionCriteria(out, 
                                                    .by_equation = FALSE)
  # Extract the AIC values
  aic_values <- model_criteria$AIC
  # Return the AIC values as a vector
  # return(as.vector(aic_values))
  return(aic_values)
}


# Define the fitness function for matrix sparsity
sparsity_fitness <- function(matrix) {
  # Calculate the total number of elements in the matrix
  total_elements <- length(matrix)
  # Count the number of ones in the matrix
  number_of_ones <- sum(matrix)  # Since it's a binary matrix, just summing up will give us the number of ones
  # Calculate the proportion of ones (density) in the matrix
  density <- number_of_ones / total_elements
  # You could also consider using the count of ones directly as a measure of non-sparsity
  # or you could invert the density to reflect sparsity (1 - density)
  sparsity_score <- 1 - density  # This score is higher when the matrix is more sparse
  return(sparsity_score)
}

# # Example usage:
# adj_matrix <- matrix(c(
#    0, 0, 0, 0, 0, 0,  # IMAG dependencies
#    1, 0, 0, 0, 0, 0,  # EXPE dependencies
#    0, 1, 0, 0, 0, 0,  # QUAL dependencies
#    0, 1, 1, 0, 0, 0,  # VAL dependencies
#    1, 1, 1, 1, 0, 1,  # SAT dependencies
#    1, 0, 0, 0, 1, 0   # LOY dependencies
# ), nrow = 6, byrow = TRUE)
#   
# aic_vector <- fitness(adj_matrix)
# # # sparsity <- sparsity_fitness(adj_matrix)
# #  
# # # res <- fitness_function(adj_matrix)
# # 
# print(aic_vector)
