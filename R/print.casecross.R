## print.casecross.R
## Prints basic results from casecross
## Oct 2009

#' Print the Results of a Case-Crossover Model
#'
#' The default print method for a [casecross()] object produced by
#' [casecross()].
#'
#' Uses [print.coxph()].
#'
#' @param x a [casecross()] object produced by [casecross()].
#' @param \dots optional arguments to [print()] or [plot()] methods.
#' @returns printed output of [casecross()].
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [casecross()], [summary.casecross()], [coxph()]
#' @examples
#' \donttest{
#' # subset for example
#' CVDdaily <- subset(CVDdaily, date <= as.Date('1987-12-31'))
#' # Effect of ozone on CVD death
#' model1 <- casecross(
#'   cvd ~ o3mean + tmpd + Mon + Tue + Wed + Thu + Fri + Sat,
#'   data = CVDdaily
#' )
#' model1
#'
#' }
#' @export
print.casecross <- function(x, ...) {
  check_if_casecross(x)
  if (!inherits(x$cox_model, "coxph")) {
    stop(
      "Conditional logistic regression model object 'cox_model'",
      " must be of class 'coxph'"
    )
  }
  print(x$cox_model, ...)
}
