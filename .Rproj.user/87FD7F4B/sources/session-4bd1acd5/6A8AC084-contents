library(cSEM)

source("model_generated.R")

setwd("/Users/gpietrop/Desktop/pls_gp_R/test/")

variables <- c("eta1", "eta2", "eta3", "eta4", "eta5", "eta6")

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

best_file = "16_best.csv"
dataset_file = "16_dataset_generated.csv"

n_variables <- length(variables)

dataset_generated = read.csv(dataset_file)

adj_matrix <- as.matrix(read.csv(best_file, row.names = 1))
print(adj_matrix)
model_string <- create_sem_model_string_from_matrix(adj_matrix, variables, measurement_model, structural_coefficients, type_of_variable)
out <- csem(.data = dataset_generated,.model = model_string, .resample_method = "bootstrap")

a <- cSEM::summarize(out)
p_val <- round(a$Estimates$Path_estimates$p_value, 4)
p_name <- a$Estimates$Path_estimates$Name
p_name
p_val

# path coefficent 
out$Estimates$Path_estimates

infer_res <- infer(out)
infer_res$Path_estimates


model_criteria <- calculateModelSelectionCriteria(out, 
                                                  .by_equation = FALSE,
                                                  .only_structural = FALSE
)
print(model_criteria)

