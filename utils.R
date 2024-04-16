# Function to make the adjacency matrix acyclic
make_acyclic <- function(adj_matrix) {
  # Create a directed graph from the adjacency matrix
  g <- graph_from_adjacency_matrix(adj_matrix, mode = "directed", diag = FALSE)
  
  # Check if the graph is a DAG (Directed Acyclic Graph)
  if (is_dag(g)) {
    cat("The graph is already acyclic.\n")
    return(adj_matrix)  # Return the original matrix if it's already acyclic
  }
  
  # Continuously remove edges until there are no cycles
  while (!is_dag(g)) {
    # Perform a DFS to find a back edge
    dfs_result <- dfs(g, root = V(g)[1], unreachable = TRUE)
    has_cycle <- FALSE
    for (edge in E(g)) {
      # Get vertices connected by the edge
      verts <- ends(g, edge, names = FALSE)
      # Check for a back edge: edge pointing from a vertex to one of its ancestors
      if (dfs_result$order[verts[1]] > dfs_result$order[verts[2]]) {
        # It's a back edge, contributing to a cycle
        g <- delete_edges(g, edge)
        has_cycle <- TRUE
        break  # Remove one back edge at a time
      }
    }
    if (!has_cycle) {
      cat("No back edge found, but the graph is not a DAG. Check implementation.\n")
      break
    }
  }
  
  # Return the modified adjacency matrix that is now acyclic
  return(get.adjacency(g, sparse = FALSE))
}

# Function to check if a graph is a DAG
is_dag <- function(g) {
  !any(sapply(1:vcount(g), function(x) any(dfs(g, root=x, unreachable=TRUE)$cycle)))
}


# Combined fitness function
combined_fitness <- function(adj_matrix, sparsity_weight) {
  # SEM fitness calculation (using the negative of AIC to make higher values more fit)
  sem_fitness <- -mean(fitness(adj_matrix))  # Assuming the fitness function returns AIC values
  # Sparsity fitness calculation
  sparsity_fitness_value <- sparsity_fitness(adj_matrix)
  # Calculate combined fitness with the sparsity component weighted
  combined_score <- sem_fitness + (sparsity_weight * sparsity_fitness_value)
  return(combined_score)
}

# Define the fitness function
fitness_function <- function(matrix_vector) {
  print(matrix_vector)
  adj_matrix <- matrix(matrix_vector, nrow = 6, byrow = TRUE)
  print(adj_matrix)
  # Replace this with your actual fitness evaluation logic
  sum(adj_matrix)
}
