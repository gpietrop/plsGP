# Load necessary packages
library(cSEM)
library(cSEM.DGP)

# Assume 'create_sem_model_string_from_matrix' is defined in this script
source("mode_generated.R")

# Example input definitions
variables <- c("eta1", "eta2")
adj_matrix <- matrix(c(0, 0, 1, 0), nrow=2, byrow=TRUE) # eta1 influences eta2
measurement_model <- list(
  eta1 = c("0.7*y1", "0.7*y2", "0.7*y3"),
  eta2 = c("0.8*y4", "0.8*y5", "0.8*y6")
)

# Generate the model string using the function
model_string <- create_sem_model_string_from_matrix(adj_matrix, variables, measurement_model)
cat(model_string)

# model_string_written <- '
#   # Measurement model
#   eta1 =~ 0.7*y1 + 0.7*y2 + 0.7*y3
#   eta2 =~ 0.8*y4 + 0.8*y5 + 0.8*y6
#   
#   # Structural model
#   eta2 ~ 1*eta1
# '
# cat(model_string_written)

# Generate data based on the specified model
generated_data <- generateData(
  .model = model_string,    # Use the generated model string
  .n     = 100,             # Number of observations
  .return_type = "data.frame"
)

# Perform cSEM analysis
out <- csem(.data = generated_data, .model = model_string)

# Optionally, inspect the output
verify(out)
