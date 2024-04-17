create_sem_model_string_from_matrix <- function(adj_matrix, variables, measurement_model, structural_coefficients) {
  # Measurement model section
  model_string <- "
  # Measurement model\n"
  
  # Include the measurement model specified in the input
  for (var in names(measurement_model)) {
    model_string <- paste(model_string, sprintf("  %s =~ %s\n", var, paste(measurement_model[[var]], collapse = " + ")), sep = "")
  }
  
  # Structural model section
  model_string <- paste(model_string, "\n# Structural model\n")
  
  # Iterate over each variable to define its dependencies based on the matrix
  for (i in seq_along(variables)) {
    dependent <- variables[i]
    predictors <- variables[adj_matrix[i, ] == 1]
    
    if (length(predictors) > 0) {
      model_string <- paste(model_string, sprintf("  %s ~ 1*%s\n  ", dependent, paste(predictors, collapse = " + ")), sep = "")
    }
  }
  
  # Ensure there are no leading '+' in the structural model lines and trim trailing spaces/new lines
  model_string <- gsub("\\n  $", "", model_string)  # Remove trailing new line and spaces
  model_string <- trimws(model_string)  # Remove any leading or trailing whitespace
  # model_string <- paste0(model_string, "\"")
  
  # Return the complete model string
  return(model_string)
}

# Example input definitions
variables <- c("eta1", "eta2")
adj_matrix <- matrix(c(0, 1, 0, 0), nrow=2, byrow=TRUE) # eta1 influences eta2
measurement_model <- list(
  eta1 = c("0.7*y1", "0.7*y2", "0.7*y3"),
  eta2 = c("0.8*y4", "0.8*y5", "0.8*y6")
)

# Generate the model string using the function
model_string <- create_sem_model_string_from_matrix(adj_matrix, variables, measurement_model)

# Print the model string
cat(model_string)
