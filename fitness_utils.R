repair_individual_unused <- function(adj_matrix) {
  n <- nrow(adj_matrix)
  
  # Check for rows and columns with all zeros
  row_sums <- rowSums(adj_matrix)
  col_sums <- colSums(adj_matrix)
  
  empty_indices <- which(row_sums == 0 & col_sums == 0)

  if (length(empty_indices) > 0) {
    for (k in empty_indices) {
      # Decide randomly whether to modify the row or column, only if there's a choice below the diagonal
        if (runif(1) < 0.5) {
          # Modify a column: choose a row index below the diagonal element
          valid_rows <- if (k == n) 2:(n-1) else (k+1):n # start from the second row
          if (k <= n) {
            # Remove the diagonal element specifically
            valid_rows <- valid_rows[valid_rows != k]
          }
          if (length(valid_rows) > 0) {
            if (length(valid_rows) == 1) {
              adj_matrix[valid_rows, k] <- 1
            } else {
              chosen_row <- sample(valid_rows, 1)
              adj_matrix[chosen_row, k] <- 1
            }
          }
        } else {
          # Modify a row: choose a column index below the diagonal element
          valid_cols <- if (k == n) 1:(n-1) else (k+1):n # start from the second row
          if (k <= n) {
            # Remove the diagonal element specifically
            valid_cols <- valid_cols[valid_cols != k]
          }
          if (length(valid_cols) > 0) {
            if (length(valid_cols) == 1) {
              adj_matrix[k, valid_cols] <- 1
            } else {
              chosen_col <- sample(valid_cols, 1)
              adj_matrix[k, chosen_col] <- 1
            }
          }
      }
    }
  }
  return(adj_matrix)
}