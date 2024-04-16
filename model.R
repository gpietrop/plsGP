create_sem_model_string_from_matrix <- function(adj_matrix) {
  # Define variable names corresponding to the rows and columns of the matrix
  variables <- c("IMAG", "EXPE", "QUAL", "VAL", "SAT", "LOY")
  
  # Start with the composite and measurement models (static part)
  model_string <- "
  # Composite model
  IMAG <~ imag1 + imag2 + imag3
  EXPE <~ expe1 + expe2 + expe3
  QUAL <~ qual1 + qual2 + qual3 + qual4 + qual5
  VAL  <~ val1  + val2  + val3
  
  # Reflective measurement model
  SAT  =~ sat1  + sat2  + sat3  + sat4
  LOY  =~ loy1  + loy2  + loy3  + loy4
  
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
  
  # Ensure there are no leading '+' in the structural model lines and trim trailing spaces/new lines
  model_string <- gsub("\\n  $", "", model_string)  # Remove trailing new line and spaces
  model_string <- trimws(model_string)  # Remove any leading or trailing whitespace
  # model_string <- paste0(model_string, "\"")
  
  return(model_string)
}

# Example usage:
# adj_matrix <- matrix(c(
#   0, 1, 0, 0, 0, 0,  # IMAG dependencies
#   0, 0, 1, 1, 1, 0,  # EXPE dependencies
#   0, 0, 0, 1, 1, 0,  # QUAL dependencies
#   0, 0, 0, 0, 1, 0,  # VAL dependencies
#   1, 1, 1, 1, 0, 1,  # SAT dependencies
#   1, 0, 0, 0, 1, 0   # LOY dependencies
# ), nrow = 6, byrow = TRUE)
# 
# model_string <- create_sem_model_string_from_matrix(adj_matrix)
# cat(model_string)
