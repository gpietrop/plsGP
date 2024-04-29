library(cSEM.DGP)

# List of variable names
variables <- c("eta1", "eta2", "eta3", "eta4", "eta5", "eta6") # dir_names in the other script
n_variables <- length(variables)

# Measurement model (specify which manifest variables are associated with which latent variables)
measurement_model <- list(
  eta1 = c("y1", "y2", "y3"),
  eta2 = c("y4", "y5", "y6"),
  eta3 = c("y7", "y8", "y9"), 
  eta4 = c("y10", "y11", "y12"),
  eta5 = c("y13", "y14", "y15"),
  eta6 = c("y16", "y17", "y18")
)

# Types of variables (composite or reflective)
type_of_variable <- c(eta1 = "composite", eta2 = "composite", 
                      eta3 = "composite", eta4 = "composite",
                      eta5 = "composite", eta6 = "composite")

# Structural coefficients (optional and unused in the provided function)
structural_coefficients <- list()

model_string_true <- '

  # Measurement model
  eta1 <~ 0.6*y1 + 0.4*y2 + 0.2*y3 
  eta2 <~ 0.3*y4 + 0.5*y5 + 0.6*y6 
  eta3 <~ 0.4*y7 + 0.5*y8 + 0.5*y9 
  eta4 <~ 0.6*y10 + 0.4*y11 + 0.2*y12 
  eta5 <~ 0.3*y13 + 0.5*y14 + 0.6*y15 
  eta6 <~ 0.4*y16 + 0.5*y17 + 0.5*y18 
  y1 ~~ 0.5*y2 + 0.5*y3
  y2 ~~ 0.5*y1 + 0.5*y3
  y3 ~~ 0.5*y1 + 0.5*y2
  y4 ~~ 0.2*y5
  y5 ~~ 0.2*y4 + 0.4*y6
  y6 ~~ 0.4*y5
  y7 ~~ 0.25*y8 + 0.4*y9
  y8 ~~ 0.25*y7 + 0.16*y9
  y9 ~~ 0.4*y7 + 0.16*y8
  y10 ~~ 0.5*y11 + 0.5*y12
  y11 ~~ 0.5*y10 + 0.5*y12
  y12 ~~ 0.5*y10 + 0.5*y11
  y13 ~~ 0.2*y14
  y14 ~~ 0.2*y13 + 0.4*y15
  y15 ~~ 0.4*y14
  y16 ~~ 0.25*y17 + 0.4*y18
  y17 ~~ 0.25*y16 + 0.16*y18
  y18 ~~ 0.4*y16 + 0.16*y17
  
  
  # Structural model
  eta4 ~ 1*eta1 + 1*eta2 + 1*eta3
  eta5 ~ 1*eta4
  eta6 ~ 1*eta5
  eta1 ~~ 0.3*eta2 + 0.5*eta3   
  eta2 ~~ 0.3*eta1 + 0.4*eta3
  eta3 ~~ 0.5*eta1 + 0.4*eta2
'

# Generate data based on the specified model
dataset_generated <- generateData(
  .model = model_string_true,    # Use the generated model string
  .n     = 200,             # Number of observations
  .return_type = "data.frame"
)
