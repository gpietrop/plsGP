create_sem_model_string_from_matrix <- function(adj_matrix, variables, measurement_model, structural_coefficients, type_of_variable) {
  # Initialize the model string
  model_string <- "# Composite model\n"
  
  # Include the measurement model specified in the input for composite types
  for (var in names(measurement_model)) {
    if (type_of_variable[var] == "composite") {
      items <- paste(measurement_model[[var]], collapse = " + ")
      model_string <- paste(model_string, sprintf("  %s <~ %s\n", var, items), sep = "")
    }
  }
  
  # Adding reflective measurement models
  model_string <- paste(model_string, "\n# Reflective measurement model\n")
  for (var in names(measurement_model)) {
    if (type_of_variable[var] == "reflective") {
      items <- paste(measurement_model[[var]], collapse = " + ")
      model_string <- paste(model_string, sprintf("  %s =~ %s\n", var, items), sep = "")
    }
  }
  
  # Structural model section
  model_string <- paste(model_string, "\n# Structural model\n")
  
  # Iterate over each variable to define its dependencies based on the matrix
  for (i in seq_along(variables)) {
    dependent <- variables[i]
    predictors <- variables[adj_matrix[i, ] == 1]
    
    if (length(predictors) > 0) {
      relationship_str <- paste(predictors, collapse = " + ")
      model_string <- paste(model_string, sprintf("  %s ~ %s\n", dependent, relationship_str), sep = "")
    }
  }
  
  # Cleanup the string: remove any unnecessary characters and trim trailing spaces/new lines
  model_string <- gsub("\\n\\s+$", "", model_string)  # Remove trailing new line and spaces
  model_string <- trimws(model_string)  # Remove any leading or trailing whitespace
  
  # Return the complete model string
  return(model_string)
}

# Adjacency matrix where rows and columns correspond to variables
# '1' indicates a direct influence from column variable to row variable
adj_matrix <- matrix(c(0, 0, 0,
                       1, 0, 1,
                       0, 1, 0),
                     byrow = TRUE, nrow = 3)

# List of variable names
variables <- c("eta1", "eta2", "eta3")

# Measurement model (specify which manifest variables are associated with which latent variables)
measurement_model <- list(
  eta1 = c("y1", "y2", "y3"),
  eta2 = c("y4", "y5", "y6"),
  eta3 = c("y7", "y8")
)

# Types of variables (composite or reflective)
type_of_variable <- c(eta1 = "composite", eta2 = "composite", eta3 = "reflective")

# Structural coefficients (optional and unused in the provided function)
structural_coefficients <- list()

# Call the modified function
model_string <- create_sem_model_string_from_matrix(adj_matrix, variables, measurement_model, structural_coefficients, type_of_variable)

# Print the resulting SEM model string
cat(model_string)

