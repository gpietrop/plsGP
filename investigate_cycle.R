# Define your adjacency matrix
adj_matrix <- matrix(c(
  0, 1, 0, 0, 0, 0,  # A depends on B
  0, 0, 1, 0, 0, 0,  # B depends on C
  0, 0, 0, 1, 0, 0,  # C depends on D
  0, 0, 0, 0, 0, 0,  # D depends back on B (Cycle B, C, D)
  0, 0, 0, 0, 0, 0,  # E no dependencies
  0, 0, 0, 0, 0, 0   # F no dependencies
), nrow = 6, byrow = TRUE)

# Create graph from adjacency matrix
g <- graph_from_adjacency_matrix(adj_matrix, mode = "directed", weighted = NULL)

# Source the cycle detection functions
source("dfs.R")

# Check for cycle
has_cycle <- has_cycle_dfs(g, adj_matrix)
print(has_cycle)  # Should print TRUE if there's a cycle
