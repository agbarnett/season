#' Printing a summary of a month.glm
#'
#' @param x a `summary.monthglm` object produced by [summary.monthglm()].
#' @param \dots further arguments passed to or from other methods.
#' @returns summary of monthglm results. This includes, number of observations,
#'  and a table of the mean, lower, upper, z value, and p value for each of the
#'  months.
#' @examples
#' mmodel <- monthglm(
#'   formula = cvd~1,
#'   data = CVD,
#'   family = poisson(),
#'   offsetpop = expression(pop/100000),
#'   offsetmonth = TRUE
#'   )
#' summary(mmodel)
#' @export
print.summary.monthglm <- function(x, ...) {
  ## report results
  cat('Number of observations =', x$n, '\n')
  ratios <- switch(
    x$month.effect,
    RR = "Rate ratios\n",
    OR = "Odds ratios\n",
    ""
  )
  cat(
    ratios,
    "\n"
  )
  print(x$month.ests, ...)
  invisible(x)
}
