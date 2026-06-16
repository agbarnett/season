#' @importFrom generics tidy glance augment
#' @export
generics::tidy

#' @export
generics::glance

#' @export
generics::augment

#' Tidy a casecross object
#'
#' This implements the tidy method for [broom::tidy.coxph()].
#'
#' @param x A `casecross` object returned from [survival::coxph()].
#'
#' @param exponentiate Logical indicating whether or not to exponentiate the
#'   coefficient estimates. This is typical for logistic and multinomial
#'   regressions, but a bad idea if there is no log or logit link. Defaults to
#'   FALSE.
#' @param conf.int Logical indicating whether or not to include a confidence
#'   interval in the tidied output. Defaults to FALSE.
#' @param conf.level The confidence level to use for the confidence interval
#'   if conf.int = TRUE. Must be strictly greater than 0 and less than 1.
#'   Defaults to 0.95, which corresponds to a 95 percent confidence interval.
#' @param ...	For `tidy()`, additional arguments passed to `summary(x, ...)`.
#'   Otherwise ignored.
#'
#' @examples
#' # subset for example
#' CVDdaily <- subset(CVDdaily, date <= as.Date('1987-12-31'))
#' # Effect of ozone on CVD death
#' model1 <- casecross(
#'   cvd ~ o3mean + tmpd + Mon + Tue + Wed + Thu + Fri + Sat,
#'   data = CVDdaily
#' )
#' summary(model1)
#'
#' # works with "broom" style tidiers:
#' # data frame of estimate, std. error, p-value for each model term
#' # similar to "summary", but in a dataframe
#' tidy(model1)
#' # exponentiate the coefficient estimates
#' tidy(model1, exponentiate = TRUE)
#' # include confidence intervals in output
#' tidy(model1, conf.int = TRUE)
#' # change confidence interval amount
#' tidy(model1, conf.int = TRUE)
#' @export
tidy.casecross <- function(x, exponentiate, conf.int, conf.level, ...) {
  broom::tidy(x$cox_model, ...)
}

#' Construct a single row summary "glance" of a model, fit, or other object
#'
#' @param x model or other R object to convert to single-row data frame.
#' @param ... other arguments passed to methods.
#'
#' @examples
#' # subset for example
#' CVDdaily <- subset(CVDdaily, date <= as.Date('1987-12-31'))
#' # Effect of ozone on CVD death
#' model1 <- casecross(
#'   cvd ~ o3mean + tmpd + Mon + Tue + Wed + Thu + Fri + Sat,
#'   data = CVDdaily
#' )
#' summary(model1)
#' # one-line summary for each model
#' glance(model1)
#' @export
glance.casecross <- function(x, ...) {
  broom::glance(x$cox_model, ...)
}

#' Augment
#'
#' @inherit broom::augment description
#'
#' @param x Model object or other R object with information to append to
#'  observations.
#' @param ... Addition arguments to augment method.
#'
#' @export
augment.casecross <- function(x, ...) {
  broom::augment(x$cox_model, ...)
}

#' @export
tidy.Cosinor <- function(x, ...) {
  generics::tidy(x$glm, ...)
}

# … glance, augment for Cosinor

#' @export
tidy.monthglm <- function(x, ...) {
  generics::tidy(x$glm, ...)
}

# … glance, augment for monthglm

#' @export
tidy.nsCosinor <- function(x, ...) {
  data.frame(
    term = colnames(x$chains),
    mean = colMeans(x$chains),
    lower = apply(x$chains, 2, stats::quantile, probs = 0.025),
    upper = apply(x$chains, 2, stats::quantile, probs = 0.975)
  )
}
