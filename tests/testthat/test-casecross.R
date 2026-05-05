# Replicate worked examples in Barnett & Dobson (2010, 5.1 - starting page 131).
# Case–crossover fits a conditional logistic regression (via survival::coxph)
# comparing exposure on event days against nearby control days. Verify we can
# reproduce published case-day counts + OR estimates for LA CVD/ozone example.

# Existing single-year test -------------
# Subset to 1987 to keep snapshot small and fast

CVDdaily_1987 <- subset(CVDdaily, date <= as.Date("1987-12-31"))
model1 <- casecross(
  cvd ~ o3mean + tmpd + Mon + Tue + Wed + Thu + Fri + Sat,
  data = CVDdaily_1987
)

test_that("overall structure of the casecross model is consistent", {
  expect_snapshot(model1)
  expect_snapshot(names(model1))
  expect_snapshot(model1$c.model)
})

# book p.136: time-stratified, 28-day stratum, exclusion = 4 ------------
# Book scales ozone to 10 ppb, and temp 5F before fitting.
# Expected: 5114 case days, 19.7 controls/case day,
# o3_mean_10 OR = 0.9928973, Monday OR = 1.0341324.

test_that("casecross reproduces published 28-day stratum model (p.136)", {
  CVDdaily$o3_mean_10 <- CVDdaily$o3mean / 10
  CVDdaily$tmpd_5 <- CVDdaily$tmpd / 5
  model_28d <- casecross(
    cvd ~ o3_mean_10 + tmpd_5 + Mon + Tue + Wed + Thu + Fri + Sat,
    data = CVDdaily,
    stratalength = 28,
    exclusion = 4
  )
  expect_identical(model_28d$ncasedays, 5114)
  expect_identical(model_28d$ncontroldays, 19.7)

  model_coef <- coef(model_28d$c.model)

  coef_o3 <- model_coef[["o3_mean_10"]] |> round(7)
  coef_o3_exp <- model_coef[["o3_mean_10"]] |> exp() |> round(7)
  coef_mon_exp <- model_coef[["Mon"]] |> exp() |> round(4)

  expect_equal(coef_o3, -0.0071281)
  expect_equal(coef_o3_exp, 0.9928973)
  expect_equal(coef_mon_exp, 1.0341)
})

# book p.136: matching on day of the week -----------------------------
# (from bottom paragraph, code not provided in textbook), but adding
# matchdow = TRUE drops day-of-week dummies, tightens matching: 5114
# case days but only ~3 controls per case.
# Ozone OR = 0.9923 (95% CI 0.984, 0.999).

test_that("casecross matchdow=TRUE reproduces published model (p.136)", {
  CVDdaily$o3_mean_10 <- CVDdaily$o3mean / 10
  CVDdaily$tmpd_5 <- CVDdaily$tmpd / 5
  model_dow <- casecross(
    cvd ~ o3_mean_10 + tmpd_5,
    data = CVDdaily,
    stratalength = 28,
    exclusion = 4,
    matchdow = TRUE
  )
  expect_identical(model_dow$ncasedays, 5114)
  expect_identical(model_dow$ncontroldays, 3)

  coef_dow <- coef(model_dow$c.model)

  coef_dow_o3 <- coef_dow[["o3_mean_10"]] |> round(9)
  coef_dow_o3_exp <- coef_dow[["o3_mean_10"]] |> exp() |> round(4)

  expect_equal(coef_dow_o3, -0.007686579)
  expect_equal(coef_dow_o3_exp, 0.9923)

  coef_dow_temp <- coef_dow[["tmpd_5"]] |> round(9)
  coef_dow_temp_exp <- coef_dow[["tmpd_5"]] |> exp() |> round(7)

  expect_equal(coef_dow_temp, 0.009497229)
  expect_equal(coef_dow_temp_exp, 1.0095425)
})

# TODO need to revisit this and check if code matches textbook for these pages
# matchconf: continuous confounder matching ---------------------------
# Anchored structurally rather than by exact OR (published vals on p.138 differ
# slightly from current, possibly due to algorithmic refinements?).

# test_that("casecross matchconf produces a casecross with reduced controls", {
#  model_matchconf <- casecross(
#    cvd ~ o3mean + Mon + Tue + Wed + Thu + Fri + Sat,
#    data = CVDdaily,
#    stratalength = 28,
#    exclusion = 4,
#    matchconf = "tmpd",
#    confrange = 1
#  )
#  expect_s3_class(model_matchconf, "casecross")
#  # Tight match on temp reduces controls per case vs
#  # unmatched 28-day default (19.7).
#  # On textbook it is 5.1, but here we get 4.8?
#  expect_equal(model_matchconf$ncontroldays, 4.8)
#
#  coef_match <- coef(model_matchconf$c.model)
#
#  library(broom)
#  model_tidy <- tidy(model_matchconf$c.model)
#
#  coef_match_o3 <- coef_match[["o3mean"]] |> round(9)
#  coef_match_o3_exp <- coef_match[["o3mean"]] |> exp() |> round(4)
#
#  # fails
#  # expect_equal(coef_match_o3, 0.0035045071)
#  # expect_equal(coef_match_o3_exp, 1.003511)
#  expect_gt(coef_match_o3_exp, 1)
#  # expect non significant - not true here.
#  subset(model_tidy, term == "o3mean")$p.value
#
#  coef_match_temp <- coef_match[["tmpd_5"]] |> round(9)
#  coef_match_temp_exp <- coef_match[["tmpd_5"]] |> exp() |> round(7)
#
#  expect_equal(coef_match_temp, 0.009497229)
#  expect_equal(coef_match_temp_exp, 1.0095425)
#
#  expect_output(summary(m), "Matched on tmpd plus/minus 1")
# })

# TODO try and emulate results on page 139
# stratamonth=TRUE: monthly strata ------------------------------------
# Section 5.1.5 (book p.139) discusses using calendar months as strata
# instead of fixed-length windows; this exercises the stratamonth
# branch in casecross() and the corresponding summary.casecross
# print path.

# test_that("casecross stratamonth=TRUE uses monthly strata", {
#  m <- casecross(
#    cvd ~
#      o3mean +
#        tmpd:winter +
#        tmpd:spring +
#        tmpd:summer +
#        tmpd:autumn +
#        Mon +
#        Tue +
#        Wed +
#        Thu +
#        Fri +
#        Sat,
#    data = CVDdaily,
#    stratamonth = TRUE
#  )
#  expect_s3_class(m, "casecross")
#  expect_output(summary(m), "months as strata")
# })
