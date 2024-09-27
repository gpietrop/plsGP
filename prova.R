source("hyperparameters.R")

dataset_generated <- generateData(
  .model = get("str4_high"),    
  .n     = 500,             
  .return_type = "data.frame",
  .empirical = FALSE
)

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

out_best <- csem(.data = dataset_generated, .model = model_est)

a = assess(out_best)
a$F2
# summary(a)
