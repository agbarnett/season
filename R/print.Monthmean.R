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
#' \donttest{
#' mmean <- monthmean(
#'   data = CVD,
#'   resp = 'cvd',
#'   offsetpop = expression(pop / 100000),
#'   adjmonth = 'average'
#' )
#' mmean
#' }
print.Monthmean <- function(x, digits = 1, ...) {
  check_if_monthmean(x)
  toprint <- data.frame(
    Month = month.name,
    Mean = round(x$mean, digits)
  )
  print(toprint, row.names = FALSE, ...)
}
