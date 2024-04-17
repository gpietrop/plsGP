# load packages
library(cSEM)
library(cSEM.DGP)

source("model_generated.R")

# Define the adjacency matrix for the structural model
adj_matrix <- matrix(c(0, 1,  # eta1 does not influence itself, but influences eta2
                       0, 0),  # eta2 does not influence itself or eta1
                     nrow = 2, byrow = TRUE)

# Define variables
variables <- c("eta1", "eta2")

# Composite model definitions (None in this case, using reflective models only)
composite_definitions <- list()

# Reflective model definitions
reflective_definitions = list(
  eta1 = c("0.7*y1", "0.7*y2", "0.7*y3"),
  eta2 = c("0.8*y4", "0.8*y5", "0.8*y6")
)


model_string <- create_sem_model_string_from_matrix(adj_matrix, variables, composite_definitions, reflective_definitions)
cat(model_string)

# Define the model using lavaan-style syntax
model_definition <- '
  # Measurement model
  eta1 =~ 0.7*y1 + 0.7*y2 + 0.7*y3
  eta2 =~ 0.8*y4 + 0.8*y5 + 0.8*y6
  
  # Structural model
  eta2 ~ 0.6*eta1
'

# Generate data based on the specified model
generated_data <- generateData(
  .model           = model_definition,
  .n               = 100,    # Number of observations
  .return_type     = "data.frame"
)


out <- csem(.data = generated_data,.model = model_string)
