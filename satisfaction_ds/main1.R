source("model.R")

# Example usage:
# Creating a 4x4 matrix where each variable can depend on each other
adj_matrix <- matrix(c(
  0, 0, 0, 0,  # OrgPres dependencies
  1, 0, 0, 0,  # OrgIden dependencies
  1, 1, 0, 0,  # AffJoy dependencies
  1, 1, 0, 0   # AffLove dependencies
), nrow = 4, byrow = TRUE)

model_Bergami <- create_model_string_from_matrix(adj_matrix)
cat(model_Bergami)


outBergamiboot <- csem(.data = BergamiBagozzi2000,.model = model_Bergami,
                       .disattenuate = T,
                       .PLS_weight_scheme_inner = 'factorial',
                       .tolerance = 1e-5,
                       .resample_method = 'bootstrap',.R = 499)
verify(outBergamiboot)
summarize(outBergamiboot)

assess(outBergamiboot)

calculateModelSelectionCriteria(outBergamiboot)
