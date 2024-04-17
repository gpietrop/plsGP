library(cSEM.DGP)

# Define a basic structural equation model using lavaan syntax
model <- '
  # Measurement model
  eta1 =~ 0.7*y1 + 0.7*y2 + 0.7*y3
  eta2 =~ 0.8*y4 + 0.8*y5 + 0.8*y6
  
  # Structural model
  eta2 ~ 0.6*eta1
'

# Generate data based on the model
generated_data <- generateData(
  .model           = model,
  .n               = 100,    # Number of observations
  .return_type     = "data.frame"
)

# View the first few rows of the generated data
head(generated_data)

# Perform cSEM analysis
out <- csem(.data = generated_data, .model = model)
verify(out)
