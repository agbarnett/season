#' Print the Results of a Cosinor
#'
#' The default print method for a `Cosinor` object produced by
#' [cosinor()]. Uses the `glm` method for [print()].
#'
#' @param x a `Cosinor` object produced by [cosinor()].
#' @param \dots optional arguments to [print()] or [plot()] methods.
#' @returns Prints basic results from [cosinor()], using print method for `glm`.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [cosinor()] [summary.Cosinor()] [glm()]
#' @examples
#' \donttest{
#'   res <- cosinor(
#'     cvd ~ 1,
#'     date = 'month',
#'     data = CVD,
#'     type = 'monthly',
#'     family = poisson(),
#'     offsetmonth = TRUE
#'     )
#'   res
#' }
#' @export
print.Cosinor <- function(x, ...) {
  
  if (!inherits(x, "Cosinor")) {
    stop("Object must be of class 'Cosinor'")
  }

  ## Use GLM function ###
  print(x$glm, ...)
} # end of function
