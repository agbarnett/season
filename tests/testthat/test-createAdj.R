test_that("multiplication works", {
  # Nearest neighbour matrix for 5 time points
  x <- c(NA, 1, NA, NA, NA)
  V <- toeplitz(x)
  adj_file <- tempfile(fileext = ".txt")
  adj_mat <- createAdj(matrix = V, filename = adj_file)
  lengths(adj_mat)
})
