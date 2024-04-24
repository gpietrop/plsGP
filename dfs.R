# Load igraph library
library(igraph)

has_cycle_dfs <- function(graph, adj_matrix) {
  visited <- rep(FALSE, vcount(graph))
  recStack <- rep(FALSE, vcount(graph))
  
  for (v in 1:vcount(graph)) {
    if (!visited[v]) {
      if (dfs_util(graph, v, visited, recStack, adj_matrix)) {
        return(TRUE)
      }
    }
  }
  return(FALSE)
}

dfs_util <- function(graph, v, visited, recStack, adj_matrix) {
  visited[v] <- TRUE
  recStack[v] <- TRUE
  
  neighbors <- which(adj_matrix[v, ] == 1)
  for (u in neighbors) {
    if (!visited[u] && dfs_util(graph, u, visited, recStack, adj_matrix)) {
      return(TRUE)
    } else if (recStack[u]) {
      return(TRUE)
    }
  }
  
  recStack[v] <- FALSE
  return(FALSE)
}