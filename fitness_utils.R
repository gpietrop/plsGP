repair_individual_unused <- function(matrix) {
  n_rows <- nrow(matrix)
  n_cols <- ncol(matrix)
  
  # Loop through each column
  for (col in 1:n_cols) {
    # print("col")
    # print(col)
    # Check if the sum of the column is 0
    if (sum(matrix[, col]) == 0) {
      # Generate a list of eligible rows: exclude the first row and the diagonal element
      eligible_rows <- 2:n_rows # start from the second row
      if (col <= n_rows) {
        # Remove the diagonal element specifically
        # print("before")
        # print(eligible_rows)
        eligible_rows <- eligible_rows[eligible_rows != col]
        # print("after")
        # print(eligible_rows)
        
      }
      
      # Check if there are any eligible rows left to modify
      if (length(eligible_rows) > 0) {
        # # Choose one random row from eligible rows
        # if (is.numeric(eligible_rows) && length(eligible_rows) == 1) {
        #   eligible_rows <- as.numeric(c(eligible_rows))
        # }
        # chosen_row <- sample(eligible_rows, 1) # HERE
        # print(class(eligible_rows))
        # # Set that element to 1
        # matrix[chosen_row, col] <- 1
        # Assuming matrix, chosen_row, col, and eligible_rows are defined
        if (length(eligible_rows) == 1) {
          matrix[eligible_rows, col] <- 1
        } else {
          chosen_row <- sample(eligible_rows, 1)
          matrix[chosen_row, col] <- 1
        }
        
      }
    }
  }
  
  # Return the modified matrix
  return(matrix)
}

# for (i in 1:50) {
#   adj_matrix <- matrix(c(0, 0, 0,
#                          0, 0, 0,
#                          0, 0, 0),
#                        byrow = TRUE, nrow = 3)
#   
#   matrix = repair_individual_unused(adj_matrix)
#   print(matrix)
# }
