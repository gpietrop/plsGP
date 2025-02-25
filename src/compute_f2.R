source("hyperparameters.R")


model_est1 <- '
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

model_est2 <- '
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

model_est3 <- '
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

model_est4 <- '
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


dataset_generated <- generateData(
  .model = get("str4_high"),    
  .n     = 500,             
  .return_type = "data.frame",
  .empirical = T
)

out_best <- csem(.data = dataset_generated, .model = model_est4)

summarize(out_best)
out_best$Estimates$R2

calculatef2(out_best)
# a = assess(out_best)
# a$F2
# summary(a)
