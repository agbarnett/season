## Oct 2011
#' Summary of the Results of a Case-crossover Model
#'
#' The default summary method for an object produced by [casecross()]. Shows the
#' number of control days, the average number of control days per case days, and
#' the parameter estimates.
#'
#' @param object a [casecross()] object produced by [casecross()].
#' @param \dots further arguments passed to or from other methods.
#' @returns The number of control days, the average number of control days per
#'   case days, and the parameter estimates.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [casecross()]
#' @examples
#' \donttest{
#' # cardiovascular disease data
#' CVDdaily <- subset(CVDdaily, date<=as.Date('1987-12-31')) # subset for example
#' # Effect of ozone on CVD death
#' model1 <- casecross(cvd ~ o3mean+tmpd+Mon+Tue+Wed+Thu+Fri+Sat, data=CVDdaily)
#' summary(model1)
#' # match on day of the week
#' model2 <- casecross(cvd ~ o3mean+tmpd, matchdow=TRUE, data=CVDdaily)
#' summary(model2)
#' # match on temperature to within a degree
#' model3 <- casecross(cvd ~ o3mean+Mon+Tue+Wed+Thu+Fri+Sat, data=CVDdaily,
#'                    matchconf='tmpd', confrange=1)
#' summary(model3)
#' }
#' @export
summary.casecross <- function(object, ...) {
  if (!inherits(object, "casecross")) {
    stop("Object must be of class 'casecross'")
  }

  ## output results
  if (!object$call$stratamonth) {
    cat(
      'Time-stratified case-crossover with a stratum length of',
      object$call$stratalength,
      'days\n'
    )
  }
  if (object$call$stratamonth) {
    cat('Time-stratified case-crossover with months as strata\n')
  } # Added Oct 2011
  if (object$call$matchdow) {
    cat('Matched on day of the week\n')
  }
  if (object$call$matchconf != '') {
    cat(
      'Matched on',
      object$call$matchconf,
      'plus/minus',
      object$call$confrange,
      '\n'
    )
  }
  cat('Total number of cases', object$ncases, '\n')
  cat('Number of case days with available control days', object$ncasedays, '\n')
  cat('Average number of control days per case day', object$ncontroldays, '\n')
  cat('\nParameter Estimates:\n')
  s <- summary(object$c.model)
  print(s$coef, ...)
}
