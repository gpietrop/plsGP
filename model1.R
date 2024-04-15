create_model_string_from_matrix <- function(adj_matrix) {
  # Define the variable names corresponding to the rows and columns of the matrix
  variables <- c("OrgPres", "OrgIden", "AffJoy", "AffLove")
  
  # Start with the measurement models (fixed in this example)
  model_string <- "
  # Measurement models
  OrgPres <~ cei1 + cei2 + cei3 + cei4 + cei5 + cei6 + cei7 + cei8 
  OrgIden =~ ma1 + ma2 + ma3 + ma4 + ma5 + ma6
  AffJoy =~ orgcmt1 + orgcmt2 + orgcmt3 + orgcmt7
  AffLove  =~ orgcmt5 + orgcmt5 + orgcmt8  # Note: orgcmt5 is repeated, check if correct
  Gender <~ gender
  
  # Structural model
  "
  
  # Iterate over each variable to define its dependencies based on the matrix
  for (i in seq_along(variables)) {
    dependent <- variables[i]
    predictors <- variables[adj_matrix[i, ] == 1]
    
    if (length(predictors) > 0) {
      model_string <- paste(model_string, sprintf("%s ~ %s\n  ", dependent, paste(predictors, collapse = " + ")), sep = "")
    }
  }
  
  # Finalize the model string
  model_string <- sub("\n  $", "", model_string)  # Remove trailing new line and spaces
  model_string <- paste0(model_string, "\"")
  
  return(model_string)
}

# Example usage:
# Creating a 4x4 matrix where each variable can depend on each other
adj_matrix <- matrix(c(
  0, 0, 0, 1,  # OrgPres dependencies
  1, 0, 1, 1,  # OrgIden dependencies
  1, 1, 0, 1,  # AffJoy dependencies
  1, 1, 1, 0   # AffLove dependencies
), nrow = 4, byrow = TRUE)

model_Bergami <- create_model_string_from_matrix(adj_matrix)
cat(model_Bergami)
