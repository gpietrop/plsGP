# Load igraph library
library(igraph)


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

create_sem_model_string_from_matrix_small <- function(adj_matrix, variables, measurement_model, structural_coefficients, type_of_variable) {
  # Structural model section
  model_string <- ""
  
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

update_p_value_file <- function(file_name, p_name, p_val) {
  # Read the existing file
  df <- read.table(file_name, header = TRUE, stringsAsFactors = FALSE, sep = "\t", fill = TRUE)
  
  # Add a new column for the current run
  new_col_name <- paste0("Run", ncol(df))  # Example: Run1, Run2, etc.
  df[[new_col_name]] <- NA  # Initialize new column with NA
  
  # Fill in p-values for current run
  for (i in 1:length(p_name)) {
    connection <- p_name[i]
    df[df$Connection == connection, new_col_name] <- p_val[i]
  }
  
  # Write the updated data frame back to the file
  write.table(df, file = file_name, row.names = FALSE, quote = FALSE, sep = "\t")
}


has_cycle_dfs <- function(graph, adj_matrix) {
  visited <- rep(FALSE, vcount(graph))
  recStack <- rep(FALSE, vcount(graph))
  
  for (v in 1:vcount(graph)) {
    if (!visited[v]) {
      if (dfs_util(graph, v, visited, recStack, adj_matrix)) {
        return(TRUE)
      }
    }
  }
  return(FALSE)
}

dfs_util <- function(graph, v, visited, recStack, adj_matrix) {
  visited[v] <- TRUE
  recStack[v] <- TRUE
  
  neighbors <- which(adj_matrix[v, ] == 1)
  for (u in neighbors) {
    if (!visited[u] && dfs_util(graph, u, visited, recStack, adj_matrix)) {
      return(TRUE)
    } else if (recStack[u]) {
      return(TRUE)
    }
  }
  
  recStack[v] <- FALSE
  return(FALSE)
}
