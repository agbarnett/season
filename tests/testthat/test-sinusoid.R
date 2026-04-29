test_that("sinusoid plots without error for a range of inputs", {
  pdf(file = tempfile(fileext = ".pdf"))
  on.exit(dev.off())
  expect_no_error(sinusoid(amplitude = 1, frequency = 1, phase = 1))
  expect_no_error(sinusoid(amplitude = 2.5, frequency = 2, phase = 0))
  expect_no_error(sinusoid(amplitude = 1, frequency = 0.5, phase = pi))
  expect_no_error(sinusoid(
    amplitude = 1,
    frequency = 1,
    phase = 1,
    col = "red"
  ))
})
