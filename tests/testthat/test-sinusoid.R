test_that("sinusoid plots without error for a range of inputs", {
  sn_1 <- sinusoid(amplitude = 1, frequency = 1, phase = 1)
  sn_2 <- sinusoid(amplitude = 2.5, frequency = 2, phase = 0)
  sn_3 <- sinusoid(amplitude = 1, frequency = 0.5, phase = pi)
  expect_snapshot(sn_1)
  expect_snapshot(sn_2)
  expect_snapshot(sn_3)

  snp_1 <- autoplot(sn_1)
  snp_2 <- autoplot(sn_2)
  snp_3 <- autoplot(sn_3)
  snp_4 <- autoplot(sn_1) + ggplot2::geom_line(colour = "red")

  vdiffr::expect_doppelganger("sinusoid-A1-F1-P1", snp_1)
  vdiffr::expect_doppelganger("sinusoid-A2.5-F2-P0", snp_2)
  vdiffr::expect_doppelganger("sinusoid-A1-F0.5-Ppi", snp_3)
  vdiffr::expect_doppelganger("sinusoid-A1-F1-P1-red", snp_4)
})
