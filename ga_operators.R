library(GA)

source("fitness_utils.R")
source("hyperparameters.R")


myMutation <- function(object, parent) {
  mutate <- parent <- as.vector(object@population[parent,])
  mutate_matrix <- matrix(mutate, nrow = n_variables, byrow = TRUE)
  diag(mutate_matrix) <- 0 # Set the diagonal elements of the matrix to zero
  mutate_matrix[1, ] <- 0 # Set all elements in the first row to zero
  # Check each column to ensure at least one non-zero entry
  row_sums <- rowSums(mutate_matrix)
  col_sums <- colSums(mutate_matrix)
  if (any(row_sums == 0 & col_sums == 0)) {
    mutate_matrix <-repair_individual_unused(mutate_matrix)
  }
  mutate_vector <- as.vector(t(mutate_matrix))
  n <- length(mutate_vector)
  j <- sample(1:n, size = 1)
  if (runif(1) <= 0.2) {  # There is a 20% chance to execute the mutation
    mutate_vector[j] <- abs(mutate_vector[j] - 1)
  }
  return(mutate_vector)
}


myMutation_satisfaction <- function(object, parent) {
  mutate <- parent <- as.vector(object@population[parent,])
  mutate_matrix <- matrix(mutate, nrow = 6, byrow = TRUE)
  diag(mutate_matrix) <- 0 # Set the diagonal elements of the matrix to zero
  mutate_matrix[1, ] <- 0 # Set all elements in the first row to zero
  # Check each column to ensure at least one non-zero entry
  row_sums <- rowSums(mutate_matrix)
  col_sums <- colSums(mutate_matrix)
  if (any(row_sums == 0 & col_sums == 0)) {
    mutate_matrix <-repair_individual_unused(mutate_matrix)
  }
  mutate_vector <- as.vector(t(mutate_matrix))
  n <- length(mutate_vector)
  j <- sample(1:n, size = 1)
  if (runif(1) <= 0.4) {  # There is a 20% chance to execute the mutation
    mutate_vector[j] <- abs(mutate_vector[j] - 1)
  }
  return(mutate_vector)
}
