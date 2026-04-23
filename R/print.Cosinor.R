## print.Cosinor.R
## Prints basic results from Cosinor

#' Print the Results of a Cosinor
#'
#' The default print method for a `Cosinor` object produced by
#' `cosinor`.
#'
#' Uses `print.glm`.
#'
#' @param x a `Cosinor` object produced by `cosinor`.
#' @param \dots optional arguments to `print` or `plot` methods.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso `cosinor`, `summary.Cosinor`, `glm`
#' @export
print.Cosinor <- function(x, ...) {
  ## Checks
  if (!inherits(x, "Cosinor")) {
    stop("Object must be of class 'Cosinor'")
  }

  ## Use GLM function ###
  print(x$glm, ...)
} # end of function
