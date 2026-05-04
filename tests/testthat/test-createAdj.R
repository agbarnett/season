test_that("adjacency matrix works", {
  # Nearest neighbour matrix for 5 time points
  x <- c(NA, 1, NA, NA, NA)
  V <- toeplitz(x)
  adj_mat <- createAdj(matrix = V)
  expect_snapshot(adj_mat)
})

test_that("adjacency matrix errors as expectd", {
  # Nearest neighbour matrix for 5 time points
  x <- c(NA, 1, NA, NA, NA)
  V <- toeplitz(x)

  # fails when not a matrix
  expect_snapshot(
    error = TRUE,
    createAdj(matrix = as.data.frame(V))
  )
  # fails when not square
  expect_snapshot(
    error = TRUE,
    createAdj(matrix = rbind(V, c(rep(0, 5))))
  )
  # fails when not symmetric
  V[1, 2] <- 2
  expect_snapshot(
    error = TRUE,
    createAdj(matrix = V)
  )
})
