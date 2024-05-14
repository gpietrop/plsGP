library(cSEM.DGP)
library(cSEM)
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

str1_small <- '

  # Measurement model
  eta1 <~ 0.6*y1 + 0.4*y2 + 0.2*y3 
  eta2 <~ 0.3*y4 + 0.5*y5 + 0.6*y6 
  eta3 <~ 0.4*y7 + 0.5*y8 + 0.5*y9 
  eta4 <~ 0.6*y10 + 0.4*y11 + 0.2*y12 
  eta5 <~ 0.3*y13 + 0.5*y14 + 0.6*y15 
  eta6 <~ 0.4*y16 + 0.5*y17 + 0.5*y18 
  y1 ~~ 0.5*y2 + 0.5*y3
  y2 ~~ 0.5*y3
  y4 ~~ 0.2*y5
  y5 ~~ 0.4*y6
  y7 ~~ 0.25*y8 + 0.4*y9
  y8 ~~ 0.16*y9
  y10 ~~ 0.5*y11 + 0.5*y12
  y11 ~~ 0.5*y12
  y13 ~~ 0.2*y14
  y14 ~~ 0.4*y15
  y16 ~~ 0.25*y17 + 0.4*y18
  y17 ~~ 0.16*y18
  
  # Structural model
  eta4 ~ 0.3*eta1 + 0.2*eta2 + 0.25*eta3
  eta5 ~ 0.35*eta4
  eta6 ~ 0.25*eta5
  eta1 ~~ 0.3*eta2 + 0.5*eta3   
  eta2 ~~ 0.4*eta3
'

str1_med <- '

  # Measurement model
  eta1 <~ 0.6*y1 + 0.4*y2 + 0.2*y3 
  eta2 <~ 0.3*y4 + 0.5*y5 + 0.6*y6 
  eta3 <~ 0.4*y7 + 0.5*y8 + 0.5*y9 
  eta4 <~ 0.6*y10 + 0.4*y11 + 0.2*y12 
  eta5 <~ 0.3*y13 + 0.5*y14 + 0.6*y15 
  eta6 <~ 0.4*y16 + 0.5*y17 + 0.5*y18 
  y1 ~~ 0.5*y2 + 0.5*y3
  y2 ~~ 0.5*y3
  y4 ~~ 0.2*y5
  y5 ~~ 0.4*y6
  y7 ~~ 0.25*y8 + 0.4*y9
  y8 ~~ 0.16*y9
  y10 ~~ 0.5*y11 + 0.5*y12
  y11 ~~ 0.5*y12
  y13 ~~ 0.2*y14
  y14 ~~ 0.4*y15
  y16 ~~ 0.25*y17 + 0.4*y18
  y17 ~~ 0.16*y18
  
  # Structural model
  eta4 ~ 0.38*eta1 + 0.35*eta2 + 0.3*eta3
  eta5 ~ 0.45*eta4
  eta6 ~ 0.4*eta5
  eta1 ~~ 0.3*eta2 + 0.5*eta3   
  eta2 ~~ 0.4*eta3
'
# cor(dataset_generated)

# model_est <- '
#   # Measurement model
#   eta1 <~ y1 + y2 + y3 
#   eta2 <~ y4 + y5 + y6 
#   eta3 <~ y7 + y8 + y9 
#   eta4 <~ y10 + y11 + y12 
#   eta5 <~ y13 + y14 + y15 
#   eta6 <~ y16 + y17 + y18 
#   
#   # Structural model
#   eta2 ~ eta4 + eta6
#   eta3 ~ eta2 + eta4 + eta6
#   eta4 ~ eta1 + eta6 
#   eta5 ~ eta2 + eta3 + eta4 + eta6
# '
# 
# out = csem(.data = dataset_generated, .model = model_est)
# # verify(out)
# # summarize(out)
# 
# model_criteria <- calculateModelSelectionCriteria(out, 
#                                                   .by_equation = FALSE,
#                                                   .only_structural = FALSE)
# # Extract the AIC values
# aic_values <- model_criteria$AIC
# print(aic_values)
# 
