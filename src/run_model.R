library(cSEM)

# Function to estimate SEM model and return BIC values
estimate_sem_model <- function(dataset_generated, model_est) {
  results <- csem(.data = dataset_generated, .model = model_est)
  model_criteria <- calculateModelSelectionCriteria(results, 
                                                    .by_equation = FALSE, 
                                                    .only_structural = FALSE)
  return(model_criteria$BIC)
}

run_sem_model_str1 <- function(dataset_generated) {
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
    eta6 ~ eta5'
  
  return(estimate_sem_model(dataset_generated, model_est))
}

run_sem_model_str2 <- function(dataset_generated) {
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
    eta6 ~ eta5 + eta1'
  
  return(estimate_sem_model(dataset_generated, model_est))
}

run_sem_model_str3 <- function(dataset_generated) {
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
    eta6 ~ eta5 + eta1 + eta3'
  
  return(estimate_sem_model(dataset_generated, model_est))
}

run_sem_model_str4 <- function(dataset_generated) {
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
    eta6 ~ eta5 + eta1 + eta3 + eta4 + eta2'
  
  return(estimate_sem_model(dataset_generated, model_est))
}
