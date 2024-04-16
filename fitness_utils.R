repair_individual_unused <- function(adj_matrix) {
  # Get the number of rows (or columns, since it's square)
  n <- nrow(adj_matrix)
  
  # Check for columns with all zeros
  col_sums <- colSums(adj_matrix)
  empty_columns <- which(col_sums == 0)
  
  # Randomly add a '1' to each empty column avoiding the diagonal
  if (length(empty_columns) > 0) {
    for (col in empty_columns) {
      # Sample from rows excluding the diagonal element for the current column
      valid_rows <- setdiff(1:n, col)  # Remove the diagonal element from possible choices
      if (length(valid_rows) > 0) {
        row_to_mutate <- sample(valid_rows, 1)  # Select one valid row at random
        adj_matrix[row_to_mutate, col] <- 1  # Set the selected position to 1
      }
    }
  }
  return(adj_matrix)
}
