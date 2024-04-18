# Load necessary packages
library(cSEM)
library(cSEM.DGP)

# Assume 'create_sem_model_string_from_matrix' is defined in this script
source("mode_generated.R")

# Adjacency matrix where rows and columns correspond to variables
# '1' indicates a direct influence from column variable to row variable
adj_matrix <- matrix(c(0, 0, 0,
                       1, 0, 0,
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

# Generate the model string using the function
model_string_generated <- create_sem_model_string_from_matrix(adj_matrix, variables, measurement_model, structural_coefficients, type_of_variable)
cat(model_string_generated)

model_string_written <- '
  # Measurement model
  eta1 =~ 0.7*y1 + 0.7*y2 + 0.7*y3
  eta2 =~ 0.8*y4 + 0.8*y5 + 0.8*y6
  eta3 =~ 0.8*y7 + 0.8*y8
  
  # Structural model
  eta2 ~ 1*eta1
  eta3 ~ 1*eta2
'
# cat(model_string_written)

# Generate data based on the specified model
generated_data <- generateData(
  .model = model_string_written,    # Use the generated model string
  .n     = 100,             # Number of observations
  .return_type = "data.frame"
)

model_string <- '
  # Composite model
  eta1 <~ y1 + y2 + y3
  eta2 <~ y4 + y5 + y6
  
  # Reflective measurement model
  eta3 =~ y7 + y8
 
# Structural model
  eta2 ~ eta1
  eta3 ~ eta2
'

# Perform cSEM analysis
out <- csem(.data = generated_data, .model = model_string_generated)

# Optionally, inspect the output
verify(out)
summarize(out)

assess(out)
