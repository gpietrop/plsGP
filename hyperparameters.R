library(cSEM.DGP)

# List of variable names
variables <- c("eta1", "eta2", "eta3", "eta4", "eta5", "eta6") # dir_names in the other script
n_variables <- length(variables)

# Measurement model (specify which manifest variables are associated with which latent variables)
measurement_model <- list(
  eta1 = c("y1", "y2", "y3", "y4"),
  eta2 = c("y5", "y6", "y7", "y8"),
  eta3 = c("y9", "y10", "y11", "y12"), 
  eta4 = c("y13", "y14", "y15", "y16"),
  eta5 = c("y17", "y18", "y19", "y20"),
  eta6 = c("y21", "y22", "y23", "y24")
)

# Types of variables (composite or reflective)
type_of_variable <- c(eta1 = "composite", eta2 = "composite", 
                      eta3 = "composite", eta4 = "composite",
                      eta5 = "composite", eta6 = "composite")

# Structural coefficients (optional and unused in the provided function)
structural_coefficients <- list()

model_string_true <- '
  # Measurement model
  eta1 =~ 0.3*y1 + 0.5*y2 + 0.6*y3 + 0.5*y4
  eta2 =~ 0.4*y5 + 0.6*y6 + 0.6*y7 + 0.5*y8
  eta3 =~ 0.4*y9 + 0.6*y10 + 0.4*y11 + 0.5*y12
  eta4 =~ 0.7*y13 + 0.5*y14 + 0.4*y15 + 0.5*y16
  eta5 =~ 0.6*y17 + 0.7*y18 + 0.3*y19 + 0.5*y20
  eta6 =~ 0.6*y21 + 0.7*y22 + 0.4*y23 + 0.6*y24
  
  # Structural model
  eta4 ~ 1*eta1 + 1*eta2 + 1*eta3
  eta5 ~ 1*eta4
  eta6 ~ 1*eta5
'

# Generate data based on the specified model
dataset_generated <- generateData(
  .model = model_string_true,    # Use the generated model string
  .n     = 200,             # Number of observations
  .return_type = "data.frame"
)
