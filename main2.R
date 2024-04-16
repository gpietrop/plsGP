# load packages
library(cSEM)

source("model.R")

adj_matrix <- matrix(c(
  0, 0, 0, 0, 0, 0,  # IMAG dependencies
  1, 0, 0, 0, 0, 0,  # EXPE dependencies
  0, 1, 0, 0, 0, 0,  # QUAL dependencies
  0, 1, 1, 0, 0, 0,  # VAL dependencies
  1, 1, 1, 1, 0, 1,  # SAT dependencies
  1, 0, 0, 0, 1, 0   # LOY dependencies
), nrow = 6, byrow = TRUE)

model_string <- create_sem_model_string_from_matrix(adj_matrix)
cat(model_string)

out <- csem(.data = satisfaction,.model = model_string)

names(verify(out))
verify(out)
summarize(out)

assess(out)

model_criteria <- calculateModelSelectionCriteria(out)
# Extract the AIC values
aic_values <- model_criteria$AIC

# Print AIC values
print(aic_values)

# Save AIC values to a vector
aic_vector <- as.vector(aic_values)  # Convert to a vector if not already
