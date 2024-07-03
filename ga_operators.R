library(GA)

source("fitness_utils.R")
source("hyperparameters.R")


myMutation <- function(object, parent) {
  
  mutate <- parent <- as.vector(object@population[parent,])
  mutate_matrix <- matrix(mutate, nrow = n_variables, byrow = TRUE)
  
  diag(mutate_matrix) <- 0  # Set the diagonal elements to zero
  
  mutate_matrix[upper.tri(mutate_matrix)] <- 0
  
  # Ensure the first row is all zeros
  mutate_matrix[1, ] <- 0
  
  mutate_vector <- as.vector(t(mutate_matrix))
  
  # Create indices of lower triangular part (excluding diagonal) starting from row 2
  indices <- which(lower.tri(matrix(1, nrow = n_variables, ncol = n_variables)) & !diag(n_variables), arr.ind = TRUE)
  indices <- indices[indices[, 1] > 1, ]  # Exclude first row
  
  # Convert row and column indices to vector indices
  if (length(indices) > 0) {
    subdiag_indices <- (indices[, 1] - 1) * n_variables + indices[, 2]
    
    # Select a random index from the sub-diagonal indices to flip
    if (length(subdiag_indices) > 0 && runif(1) <= 0.3) {
      j <- sample(subdiag_indices, size = 1)
      mutate_vector[j] <- abs(mutate_vector[j] - 1)
    }
  }
  
  return(mutate_vector)
}

myMutationTreeRowZero <- function(object, parent) {
  
  mutate <- parent <- as.vector(object@population[parent,])
  mutate_matrix <- matrix(mutate, nrow = n_variables, byrow = TRUE)
  
  # print("before")
  # print(mutate_matrix)
  diag(mutate_matrix) <- 0  # Set the diagonal elements to zero
  
  mutate_matrix[upper.tri(mutate_matrix)] <- 0
  
  # Ensure the first three rows are all zeros
  mutate_matrix[1, ] <- 0
  mutate_matrix[2, ] <- 0
  mutate_matrix[3, ] <- 0 
  
  mutate_vector <- as.vector(t(mutate_matrix))
  
  # Create indices of lower triangular part (excluding diagonal) starting from row 4
  indices <- which(lower.tri(matrix(1, nrow = n_variables, ncol = n_variables)) & !diag(n_variables), arr.ind = TRUE)
  indices <- indices[indices[, 1] > 3, ]  # Exclude first three rows
  
  # Convert row and column indices to vector indices
  if (length(indices) > 0) {
    subdiag_indices <- (indices[, 1] - 1) * n_variables + indices[, 2]
    
    # Select a random index from the sub-diagonal indices to flip
    if (length(subdiag_indices) > 0 && runif(1) <= 0.3) {
      j <- sample(subdiag_indices, size = 1)
      mutate_vector[j] <- abs(mutate_vector[j] - 1)
    }
  }
  # print("after")
  # print(matrix(mutate_vector, nrow = n_variables, byrow = TRUE))
  return(mutate_vector)
}


# myMutation_satisfaction <- function(object, parent) {
#   mutate <- parent <- as.vector(object@population[parent,])
#   mutate_matrix <- matrix(mutate, nrow = 6, byrow = TRUE)
#   diag(mutate_matrix) <- 0 # Set the diagonal elements of the matrix to zero
#   mutate_matrix[1, ] <- 0 # Set all elements in the first row to zero
#   # Check each column to ensure at least one non-zero entry
#   row_sums <- rowSums(mutate_matrix)
#   col_sums <- colSums(mutate_matrix)
#   if (any(row_sums == 0 & col_sums == 0)) {
#     mutate_matrix <-repair_individual_unused(mutate_matrix)
#   }
#   mutate_vector <- as.vector(t(mutate_matrix))
#   n <- length(mutate_vector)
#   j <- sample(1:n, size = 1)
#   if (runif(1) <= 0.6) {  # There is a 20% chance to execute the mutation
#     mutate_vector[j] <- abs(mutate_vector[j] - 1)
#   }
#   return(mutate_vector)
# }
