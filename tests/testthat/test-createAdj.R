test_that("adjacency matrix works", {
  # Nearest neighbour matrix for 5 time points
  x <- c(NA, 1, NA, NA, NA)
  V <- toeplitz(x)
  adj_file <- tempfile(fileext = ".txt")
  adj_mat <- createAdj(matrix = V, filename = adj_file)
  expect_snapshot(adj_mat)
})

test_that("adjacency matrix errors as expectd", {
  # Nearest neighbour matrix for 5 time points
  x <- c(NA, 1, NA, NA, NA)
  V <- toeplitz(x)
  adj_file <- tempfile(fileext = ".txt")

  # fails when not a matrix
  expect_snapshot(
    error = TRUE,
    createAdj(matrix = as.data.frame(V), filename = adj_file)
  )
  # fails when not square
  expect_snapshot(
    error = TRUE,
    createAdj(matrix = rbind(V, c(rep(0, 5))), filename = adj_file)
  )
  # fails when not symmetric
  V[1, 2] <- 2
  expect_snapshot(
    error = TRUE,
    createAdj(matrix = V, filename = adj_file)
  )
})
