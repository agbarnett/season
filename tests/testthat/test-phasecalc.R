
test_that("phasecalc works", {
  expect_equal(phasecalc(5,4),0.6747409,tolerance=1e-4)
  expect_equal(phasecalc(5,-4),5.608444,tolerance=1e-4)
  expect_equal(phasecalc(-5,-4),3.816333,tolerance=1e-4)
})
## testing that phasecalc correctly calculates phase 
## for different combinations of pos/neg sin and cos. Values are based on manual calculations.