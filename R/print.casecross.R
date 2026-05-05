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
#'   CVDdaily <- subset(CVDdaily, date<=as.Date('1987-12-31')) # subset for example
#'   # Effect of ozone on CVD death
#'   model1 <- casecross(cvd ~ o3mean+tmpd+Mon+Tue+Wed+Thu+Fri+Sat, data=CVDdaily)
#'   model1
#' }
#' @export
print.casecross <- function(x, ...) {
  ## Check
  if (!inherits(x, "casecross")) {
    stop("Object must be of class 'casecross'")
  }
  ## Use print.coxph
  if (!inherits(x$c.model, "coxph")) {
    stop(
      "Conditional logistic regression model object 'c.model' must be of \\
      class 'coxph'"
    )
  }
  print(x$c.model, ...)
} # end of function
