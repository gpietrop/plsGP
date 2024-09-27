source("dfs.R")


check_matrix_criteria <- function(adj_matrix) {
  # Check if the first rows is all zeros
  if (any(rowSums(adj_matrix[1, , drop = FALSE]) != 0)) {
    return(FALSE)
  }
  
  # Check if the diagonal elements are all zeros
  if (any(diag(adj_matrix) != 0)) {
    return(FALSE)
  }
  
  # Check if all elements in the upper triangular matrix are zeros
  if (any(adj_matrix[upper.tri(adj_matrix)] != 0)) {
    return(FALSE)
  }
  
  return(TRUE)
}


check_matrix_criteriaTreeRowZero <- function(adj_matrix) {
  # Check if the first three rows are all zeros
  if (any(rowSums(adj_matrix[1:3, ]) != 0)) {
    return(FALSE)
  }
  
  # Check if the diagonal elements are all zeros
  if (any(diag(adj_matrix) != 0)) {
    return(FALSE)
  }
  
  # Check if all elements in the upper triangular matrix are zeros
  # if (any(adj_matrix[upper.tri(adj_matrix)] != 0)) {
  #   return(FALSE)
  # }
  
  return(TRUE)
}


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
              condition_met <- TRUE
              while (length(valid_rows) > 0 && condition_met) {
                chosen_row <- sample(valid_rows, 1)
                # print(valid_rows)
                adj_matrix_mod <- adj_matrix
                adj_matrix_mod[chosen_row, k] <- 1
                valid_rows <- valid_rows[-which(valid_rows == chosen_row)]
                g <- graph_from_adjacency_matrix(adj_matrix_mod, mode = "directed", diag = FALSE)
                condition_met <- has_cycle_dfs(g, adj_matrix_mod)
                # condition_met <- !is.infinite(girth(g)$girth)
                  if (!condition_met) {
                    adj_matrix <- adj_matrix_mod
                    break  # Exit the loop if the condition is met
                }
              }
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
              condition_met <- TRUE
              while (length(valid_cols) > 0 && condition_met) {
                chosen_col <- sample(valid_cols, 1)
                # print(valid_cols)
                adj_matrix_mod <- adj_matrix
                adj_matrix_mod[chosen_col, k] <- 1
                valid_cols <- valid_cols[-which(valid_cols == chosen_col)]
                g <- graph_from_adjacency_matrix(adj_matrix_mod, mode = "directed", diag = FALSE)
                condition_met <- has_cycle_dfs(g, adj_matrix_mod)
                # condition_met <- !is.infinite(girth(g)$girth)
                if (!condition_met) {
                  adj_matrix <- adj_matrix_mod
                  break  # Exit the loop if the condition is met
                }
              }
            }
          }
      }
    }
  }
  return(adj_matrix)
}


check_matrix <- function(mat) {
  n <- nrow(mat)
  for (i in 1:n) {
      # Check if there is at least one 1 in the row or column
      if (all(mat[i, ] == 0) && all(mat[, i] == 0)) {
        return(FALSE)  # Return FALSE if the condition is not met
    }
  }
  return(TRUE)  # Return TRUE if the condition is met for all indices
}