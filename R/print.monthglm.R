#' Prints basic results from [monthglm()]
#'
#' @param x Object of class `monthglm`
#' @param ... further arguments passed to [plot()], or from other methods.
#' @returns basic summary using the `glm` method for [print()]..
#' @examples
#' \donttest{
#' mmodel <- monthglm(
#'   formula = cvd~1,
#'   data = CVD,
#'   family = poisson(),
#'   offsetpop = expression(pop/100000),
#'   offsetmonth = TRUE
#'   )
#' mmodel
#' }
#'
#' @export
print.monthglm <- function(x, ...) {
  print(x$glm, ...)
}
