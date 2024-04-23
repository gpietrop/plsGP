# List of variable names
variables <- c("eta1", "eta2", "eta3") # dir_names in the other script
n_variables <- length(variables)

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

model_string_true <- '
  # Measurement model
  eta1 =~ 0.7*y1 + 0.7*y2 + 0.7*y3
  eta2 =~ 0.8*y4 + 0.8*y5 + 0.8*y6
  eta3 =~ 0.8*y7 + 0.8*y8
  
  # Structural model
  eta2 ~ 1*eta1
  eta3 ~ 1*eta2
'

# Generate data based on the specified model
dataset_generated <- generateData(
  .model = model_string_true,    # Use the generated model string
  .n     = 100,             # Number of observations
  .return_type = "data.frame"
)
