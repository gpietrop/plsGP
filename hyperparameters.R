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

str1_high <- '

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
  eta4 ~ 0.3*eta1 + 0.5*eta2 + 0.4*eta3
  eta5 ~ 0.8*eta4
  eta6 ~ 0.5*eta5
  eta1 ~~ 0.3*eta2 + 0.5*eta3   
  eta2 ~~ 0.4*eta3
'

str2_small <- '

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
  eta5 ~ 0.35*eta4 + 0.28*eta3
  eta6 ~ 0.25*eta5 + 0.3*eta1
  eta1 ~~ 0.3*eta2 + 0.5*eta3   
  eta2 ~~ 0.4*eta3
'

str2_med <- '

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
  eta4 ~ 0.35*eta1 + 0.3*eta2 + 0.32*eta3
  eta5 ~ 0.4*eta4 + 0.36*eta3
  eta6 ~ 0.34*eta5 + 0.38*eta1
  eta1 ~~ 0.3*eta2 + 0.5*eta3   
  eta2 ~~ 0.4*eta3
'


str2_high <- '

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
  eta4 ~ 0.36*eta1 + 0.38*eta2 + 0.37*eta3
  eta5 ~ 0.44*eta4 + 0.48*eta3
  eta6 ~ 0.45*eta5 + 0.5*eta1
  eta1 ~~ 0.3*eta2 + 0.5*eta3   
  eta2 ~~ 0.4*eta3
'


str3_small <- '

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
  eta6 ~ 0.25*eta5 + 0.2*eta1 + 0.15*eta3
  eta1 ~~ 0.3*eta2 + 0.5*eta3   
  eta2 ~~ 0.4*eta3
'

str3_med <- '

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
  eta6 ~ 0.4*eta5 + 0.35*eta1 + 0.5*eta3
  eta1 ~~ 0.3*eta2 + 0.5*eta3   
  eta2 ~~ 0.4*eta3
'


str3_high <- '

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
  eta4 ~ 0.3*eta1 + 0.5*eta2 + 0.4*eta3
  eta5 ~ 0.8*eta4
  eta6 ~ 0.5*eta5 + 0.4*eta1 + 0.28*eta3
  eta1 ~~ 0.3*eta2 + 0.5*eta3   
  eta2 ~~ 0.4*eta3
'

str4_small <- '

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
  eta5 ~ 0.35*eta4 + 0.15*eta1 + 0.18*eta2 + 0.2*eta3
  eta6 ~ 0.25*eta5 + 0.2*eta1 + 0.15*eta3 + 0.2*eta4 + 0.2*eta2
  eta1 ~~ 0.3*eta2 + 0.5*eta3   
  eta2 ~~ 0.4*eta3
'

str4_med <- '

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
  eta5 ~ 0.35*eta4 + 0.25*eta1 + 0.28*eta2 + 0.25*eta3
  eta6 ~ 0.28*eta5 + 0.22*eta1 + 0.2*eta3 + 0.25*eta4 + 0.2*eta2
  eta1 ~~ 0.3*eta2 + 0.5*eta3   
  eta2 ~~ 0.4*eta3
'

str4_high <- '

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
  eta4 ~ 0.3*eta1 + 0.4*eta2 + 0.4*eta3
  eta5 ~ 0.3*eta4 + 0.28*eta1 + 0.35*eta2 + 0.28*eta3
  eta6 ~ 0.3*eta5 + 0.22*eta1 + 0.2*eta3 + 0.25*eta4 + 0.2*eta2
  eta1 ~~ 0.3*eta2 + 0.5*eta3   
  eta2 ~~ 0.4*eta3
'

