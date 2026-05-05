## Oct 2009
#' Print the Results from Monthmean
#'
#' Print the monthly mean estimates from a `Monthmean` object produced by
#' [monthmean()].
#'
#' @param x a `Monthmean` object produced by [monthmean()].
#' @inheritParams summary.Cosinor
#' @param \dots additional arguments passed to [print()].
#' @returns a table of values of Month and means
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso `monthmean`
#' @export
#' @examples
#' \dontttest{
#' mmean <- monthmean(
#'   data=CVD,
#'   resp='cvd',
#'   offsetpop = expression(pop/100000),
#'   adjmonth = 'average'
#'   )
#' mmean
#' }
print.Monthmean <- function(x, digits = 1, ...) {
  ## Check
  if (!inherits(x, "Monthmean")) {
    stop("Object must be of class 'Monthmean'")
  }
  ## Print
  toprint <- as.data.frame(cbind(month.name, round(x$mean, digits)))
  names(toprint) <- c('Month', 'Mean')
  print(toprint, row.names = FALSE, ...)
} # end of function
