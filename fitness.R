# Ensure the cSEM library and your model creation function are loaded
library(cSEM)
library(igraph)

# import model.R expecially: create_sem_model_string_from_matrix
source("model.R")
source("fitness_utils.R")


admiss_individuals_all <- list()
best_individual <<- NULL
best_fitness <<- -Inf


# Combined fitness function
combined_fitness_fixed <- function(matrix_vector) {
  # print("fitness")
  adj_matrix <- matrix(matrix_vector, nrow = 6, byrow = TRUE)
  # print(adj_matrix)
  
  diag(adj_matrix) <- 0 # Set the diagonal elements of the matrix to zero
  adj_matrix[1, ] <- 0 # Set all elements in the first row to zero

  # Check each column to ensure at least one non-zero entry
  row_sums <- rowSums(adj_matrix)
  col_sums <- colSums(adj_matrix)
  if (any(row_sums == 0 & col_sums == 0)) {
  #   # cat("One or more constructs are not used in the structural model.\n")
  #   # return(-10000)  # Penalize configurations where any construct is unused
    # print("repair")
    # print(adj_matrix)
    adj_matrix <- repair_individual_unused(adj_matrix)
    # print("after")
    # print(adj_matrix)
  }
  
  # Convert the matrix to an igraph object
  g <- graph_from_adjacency_matrix(adj_matrix, mode = "directed", diag = FALSE)
  
  # Check for cycles using girth, which finds the shortest cycle
  # has_cycle <- !is.infinite(girth(g)$girth)
  has_cycle <- has_cycle_dfs(g, adj_matrix)
  if (has_cycle) {
    # cat("cicle")
    return(-10000)  # The matrix has cyclic dependencies
  } 
  # print(adj_matrix)
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
fitness <- function(adj_matrix) {
  # Create the model string from the adjacency matrix
  model_string <- create_sem_model_string_from_matrix(adj_matrix)
  # print(model_string)
  # Load data and perform SEM analysis
  out <- csem(.data = satisfaction, .model = model_string)
  # Calculate model selection criteria
  model_criteria <- calculateModelSelectionCriteria(out, 
                                                    .by_equation = FALSE,
                                                    .only_structural = FALSE)
  # Extract the AIC values
  aic_values <- model_criteria$AIC
  # Return the AIC values as a vector
  # return(as.vector(aic_values))
  return(aic_values)
}


# #Example usage:
# adj_matrix <- matrix(c(
#    0, 0, 0, 0, 0, 0,  # IMAG dependencies
#    1, 0, 0, 0, 0, 0,  # EXPE dependencies
#    0, 1, 0, 0, 0, 0,  # QUAL dependencies
#    0, 1, 1, 0, 0, 0,  # VAL dependencies
#    1, 1, 1, 1, 0, 0,  # SAT dependencies
#    1, 0, 0, 0, 1, 0   # LOY dependencies
# ), nrow = 6, byrow = TRUE)
#   
# # #  
# res <- fitness(adj_matrix)
# # # 
# print(res)
# 
# model_string <- create_sem_model_string_from_matrix(adj_matrix)
# out <- csem(.data = satisfaction, .model = model_string)
# verify(out)
# 
# cat(model_string)
# 
