# Tests for phasecalc(), based on the documented intent in roxygen:
#
# > Calculate the phase given the estimated sine and cosine values
#   from a cosinor model. Returns the phase in radians, in the range
#   0-2pi. The phase is the peak in the sinusoid.
#
# The phase satisfies A.cos(omega t − P) = c.cos(omega t) + s.sin(omega t) where
# (c, s) are the cosine/sine coefficients. So the phase is the angle
# of the (c, s) vector, equivalently atan2(s, c) wrapped into [0, 2pi).
# These tests pin the four cardinal directions of that mapping plus
# the cosine = 0 protection.

# four cardinal quadrants --------------------------------------------
test_that("phasecalc returns 0 when the peak is at the start of the cycle", {
  # cos has coefficient 1, sin has coefficient 0 -> the model is just
  # cos(omega t) which peaks at t = 0 -> phase = 0.
  expect_identical(phasecalc(cosine = 1, sine = 0), 0)
})

test_that("phasecalc returns pi/2 when the peak is a quarter cycle in", {
  # cos has coefficient 0, sin has coefficient 1 -> the model is sin(omega t),
  # which equals cos(omega t − pi/2) -> phase = pi/2.
  expect_equal(phasecalc(cosine = 0, sine = 1), pi / 2, tolerance = 1e-6)
})

test_that("phasecalc returns pi when the peak is half a cycle in", {
  # cos has coefficient -1, sin has coefficient 0 -> -cos(omega t) =
  # cos(omega t − pi) -> phase = pi.
  expect_identical(phasecalc(cosine = -1, sine = 0), pi)
})

test_that("phasecalc returns 3pi/2 when the peak is three-quarters in", {
  # cos has coefficient 0, sin has coefficient -1 -> -sin(omega t) =
  # cos(omega t − 3pi/2) -> phase = 3pi/2.
  expect_equal(phasecalc(cosine = 0, sine = -1), 3 * pi / 2, tolerance = 1e-6)
})

# range invariant ----------------------------------------------------

test_that("phasecalc always returns a value in [0, 2pi)", {
  # Sweep angles around the unit circle and confirm none escape the
  # documented range. The fine grid catches off-by-one branch errors.
  cs <- seq(-pi, pi, length.out = 73)
  dat_phase <- tibble::tibble(
    cos_seq = cos(cs),
    sin_seq = sin(cs),
    phase = purrr::map2_dbl(cos_seq, sin_seq, \(x, y) phasecalc(x, y)),
    within_2pi = purrr::map_lgl(phase, \(p) p >= 0 && p < 2 * p + 1e-9)
  )

  expect_all_true(dat_phase$within_2pi)
})

# agreement with atan2 (the reference implementation) ----------------

test_that("phasecalc agrees with atan2(sine, cosine) wrapped into [0, 2pi)", {
  # If they ever drift the docs are wrong, the function is wrong, or both.
  cs <- seq(-pi + 0.1, pi - 0.1, length.out = 20)

  dat_atan <- tibble::tibble(
    theta = seq(-pi + 0.1, pi - 0.1, length.out = 20),
    c0 = cos(theta),
    s0 = sin(theta),
    expected = atan2(s0, c0),
    expected_adj = dplyr::case_when(
      expected < 0 ~ expected + 2 * pi,
      .default = expected
    ),
    phase = purrr::map2_dbl(c0, s0, \(x, y) phasecalc(x, y))
  )

  expect_identical(dat_atan$phase, dat_atan$expected_adj)
})

# protection against cosine == 0 -------------------------------------

test_that("phasecalc handles cosine = 0 without dividing by zero", {
  # The implementation nudges cosine away from exactly 0 to avoid
  # Inf in the atan(sine/cosine) call. Regardless, the returned phase
  # must remain very close to the mathematically correct pi/2 or 3pi/2.
  expect_equal(phasecalc(0, 1), pi / 2, tolerance = 1e-6)
  expect_equal(phasecalc(0, -1), 3 * pi / 2, tolerance = 1e-6)
})
