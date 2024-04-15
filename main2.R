source("model.R")

adj_matrix <- matrix(c(
  0, 1, 0, 0, 0, 0,  # IMAG dependencies
  0, 0, 1, 1, 1, 0,  # EXPE dependencies
  0, 0, 0, 1, 1, 0,  # QUAL dependencies
  0, 0, 0, 0, 1, 0,  # VAL dependencies
  1, 1, 1, 1, 0, 1,  # SAT dependencies
  1, 0, 0, 0, 1, 0   # LOY dependencies
), nrow = 6, byrow = TRUE)

model_string <- create_sem_model_string_from_matrix(adj_matrix)
cat(model_string)

out <- csem(.data = satisfaction,.model = model_string)

verify(out)
summarize(out)

assess(out)

calculateModelSelectionCriteria(out)
