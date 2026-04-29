test_that("inyrfraction works", {
  expect_snapshot(
    invyrfraction(frac = c(0, 0.5, 1), type = "hourly", text = TRUE)
  )
  expect_snapshot(
    invyrfraction(frac = c(0, 0.5, 1), type = "hourly", text = FALSE)
  )
  # expect_snapshot(
  #   invyrfraction(frac = c(0, 0.5, 1), type = "daily", text = TRUE)
  # )
  # expect_snapshot(
  #   invyrfraction(frac = c(0, 0.5, 1), type = "daily", text = FALSE)
  # )
  expect_snapshot(
    invyrfraction(frac = c(0, 0.5, 1), type = "weekly", text = TRUE)
  )
  expect_snapshot(
    invyrfraction(frac = c(0, 0.5, 1), type = "weekly", text = FALSE)
  )
  expect_snapshot(
    invyrfraction(frac = c(0, 0.5, 1), type = "monthly", text = TRUE)
  )
  expect_snapshot(
    invyrfraction(frac = c(0, 0.5, 1), type = "monthly", text = FALSE)
  )
})

## Uses easily visually identifiable year fractions to test
## if the function correctly maps them to their month/hour/week
