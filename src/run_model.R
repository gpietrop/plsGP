# First, make sure to install the cSEM package if not already installed
library(cSEM)

# Define the function
run_sem_model_str1 <- function(dataset_generated) {
  # Define the model
  model_est <- '
    # Measurement model
    eta1 <~ y1 + y2 + y3
    eta2 <~ y4 + y5 + y6
    eta3 <~ y7 + y8 + y9
    eta4 <~ y10 + y11 + y12
    eta5 <~ y13 + y14 + y15
    eta6 <~ y16 + y17 + y18
    
    # Structural model
    eta4 ~ eta1 + eta2 + eta3
    eta5 ~ eta4
    eta6 ~ eta5
  '
  
  # Estimate the model using cSEM
  results <- csem(.data = dataset_generated, .model = model_est)
  
  # Calculate model selection criteria
  model_criteria <- calculateModelSelectionCriteria(results, 
                                                    .by_equation = FALSE, 
                                                    .only_structural = FALSE 
                                                    )
  
  # Extract the AIC values
  bic_values <- model_criteria$BIC
  
  return(bic_values)
}


run_sem_model_str2 <- function(dataset_generated) {
  # Define the model
  model_est <- '
    # Measurement model
    eta1 <~ y1 + y2 + y3
    eta2 <~ y4 + y5 + y6
    eta3 <~ y7 + y8 + y9
    eta4 <~ y10 + y11 + y12
    eta5 <~ y13 + y14 + y15
    eta6 <~ y16 + y17 + y18
    
    # Structural model
    eta4 ~ eta1 + eta2 + eta3
    eta5 ~ eta4 + eta3
    eta6 ~ eta5 + eta1
  '
  
  # Estimate the model using cSEM
  results <- csem(.data = dataset_generated, .model = model_est)
  
  # Calculate model selection criteria
  model_criteria <- calculateModelSelectionCriteria(results, 
                                                    .by_equation = FALSE, 
                                                    .only_structural = FALSE 
  )
  
  # Extract the AIC values
  bic_values <- model_criteria$BIC
  
  return(bic_values)
}

run_sem_model_str3 <- function(dataset_generated) {
  # Define the model
  model_est <- '
    # Measurement model
    eta1 <~ y1 + y2 + y3
    eta2 <~ y4 + y5 + y6
    eta3 <~ y7 + y8 + y9
    eta4 <~ y10 + y11 + y12
    eta5 <~ y13 + y14 + y15
    eta6 <~ y16 + y17 + y18
    
    # Structural model
    eta4 ~ eta1 + eta2 + eta3
    eta5 ~ eta4
    eta6 ~ eta5 + eta1 + eta3
  '
  
  # Estimate the model using cSEM
  results <- csem(.data = dataset_generated, .model = model_est)
  
  # Calculate model selection criteria
  model_criteria <- calculateModelSelectionCriteria(results, 
                                                    .by_equation = FALSE, 
                                                    .only_structural = FALSE 
  )
  
  # Extract the AIC values
  bic_values <- model_criteria$BIC
  
  return(bic_values)
}


run_sem_model_str4 <- function(dataset_generated) {
  # Define the model
  model_est <- '
    # Measurement model
    eta1 <~ y1 + y2 + y3
    eta2 <~ y4 + y5 + y6
    eta3 <~ y7 + y8 + y9
    eta4 <~ y10 + y11 + y12
    eta5 <~ y13 + y14 + y15
    eta6 <~ y16 + y17 + y18
    
    # Structural model
    eta4 ~ eta1 + eta2 + eta3
    eta5 ~ eta4 + eta1 + eta2 + eta3
    eta6 ~ eta5 + eta1 + eta3 + eta4 + eta2
  '
  
  # Estimate the model using cSEM
  results <- csem(.data = dataset_generated, .model = model_est)
  
  # Calculate model selection criteria
  model_criteria <- calculateModelSelectionCriteria(results, 
                                                    .by_equation = FALSE, 
                                                    .only_structural = FALSE 
  )
  
  # Extract the AIC values
  bic_values <- model_criteria$BIC
  
  return(bic_values)
}