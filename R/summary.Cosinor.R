# summary.Cosinor.R
# Aug 2014 (added hourly)

#' Print and summary methods for a Cosinor
#'
#' Print and summary methods for a `Cosinor` object produced by [cosinor()].
#' `summary()` summarises the sinusoidal seasonal pattern and tests whether
#' there is a statistically significant seasonal or circadian pattern (assuming
#' a smooth sinusoidal pattern). The amplitude describes the average height of
#' the sinusoid, and the phase describes the location of the peak. The scale of
#' the amplitude depends on the link function: for logistic regression the
#' amplitude is given on a probability scale; for Poisson regression the
#' amplitude is given on an absolute scale. `print()` uses the `glm` method for
#' [print()] on the underlying model.
#'
#' @param object a `Cosinor` object produced by [cosinor()].
#' @param x a `Cosinor` or `summary.Cosinor` object.
#' @param digits minimal number of significant digits, see [print.default()].
#' @param \dots further arguments passed to or from other methods.
#' @returns `summary.Cosinor()` returns a list with the following named elements:
#'   * n: sample size.
#'   * amp: estimated amplitude.
#'   * amp.scale: the scale of the estimated amplitude (empty for standard
#'     regression; "probability scale" for logistic regression;
#'     "absolute scale" for Poisson regression).
#'   * phase: estimated peak phase on a time scale.
#'   * lphase: estimated low phase on a time scale (half a year after/before
#' `phase`).
#'   * significant: statistically significant sinusoid (TRUE/FALSE).
#'   * alpha: statistical significance level.
#'   * digits: minimal number of significant digits.
#'   * text: add explanatory text to the returned phase value (TRUE) or return
#'     a number (FALSE).
#'   * type: type of data (yearly/monthly/weekly/hourly).
#'   * ctable: table of regression coefficients.
#'
#'   `print.Cosinor()` and `print.summary.Cosinor()` are called for their side
#'   effect of printing to the console and invisibly return `x`.
#'
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [cosinor()] [plot.Cosinor()] [invyrfraction()] [glm()]
#' @examples
#' \donttest{
#' ## cardiovascular disease data (offset based on number of days in...
#' ## ...the month scaled to an average month length)
#' res <- cosinor(
#'   cvd ~ 1,
#'   date = 'month',
#'   data = CVD,
#'   type = 'monthly',
#'   family = poisson(),
#'   offsetmonth = TRUE
#'   )
#' res
#' summary(res)
#' }
#' @export
summary.Cosinor <- function(object, digits = 2, ...) {
  check_if_cosinor(object)
  type <- object$type

  s <- summary(object$glm) # create summary

  summary_df <- as.data.frame(s$coefficients, row.names = "")
  summary_df$terms <- rownames(s$coefficients)
  cosw_terms <- subset(summary_df, subset = terms == "cosw")
  sinw_terms <- subset(summary_df, subset = terms == "sinw")
  intercept_terms <- subset(summary_df, subset = terms == "(Intercept)")
  # amplitude and phase
  amp <- sqrt(cosw_terms$Estimate^2 + sinw_terms$Estimate^2)
  link <- s$family$link %||% " "
  intercept_est <- intercept_terms$Estimate
  addition <- switch(
    link,
    logit = "(probability scale)",
    cloglog = "(probability scale)",
    log = "(absolute scale)",
    # otherwise, just blank
    ""
  )
  ## TODO refactor into switch with functions
  if (link == 'logit') {
    # back-transform amp
    p1 <- exp(intercept_est) / (1 + exp(intercept_est))
    # back-transform amp
    p2 <- exp(intercept_est + amp) /
      (1 + exp(intercept_est + amp))
    amp <- p2 - p1
  }
  if (link == 'cloglog') {
    p1 <- 1 - exp(-exp(intercept_est))
    p2 <- 1 - exp(-exp(intercept_est + amp))
    amp <- p2 - p1
  }
  if (link == 'log') {
    amp <- exp(intercept_est + amp) - exp(intercept_est)
  }
  phaser <- phasecalc(
    cosine = cosw_terms$Estimate,
    sine = sinw_terms$Estimate
  )
  # convert radian phase to a date
  phase <- invyrfraction(
    frac = phaser / (2 * pi),
    type = type,
    text = object$call$text
  )
  # reverse phase (low)
  lphaser <- phaser + pi
  if (lphaser < 0) {
    lphaser <- lphaser + (2 * pi)
  } # first put in 0 to 2pi range
  if (lphaser > (2 * pi)) {
    lphaser <- lphaser - (2 * pi)
  }
  lphase <- invyrfraction(
    frac = lphaser / (2 * pi),
    type = type,
    text = object$call$text
  )
  # statistical signficance
  toreport <- rbind(cosw_terms, sinw_terms)
  adjusted <- eval(object$call$alpha) / 2
  names(toreport) <- c("estimate", "std_error", "t_value", "p_value", "terms")
  significant <- any(toreport$p_value < adjusted)
  # returns
  result <- list(
    n = length(object$residuals),
    amp = amp,
    amp.scale = addition,
    phase = phase,
    lphase = lphase,
    significant = significant,
    alpha = object$call$alpha,
    digits = digits,
    # display phase as text (TRUE/FALSE)
    text = object$call$text,
    type = type,
    # regression table (march 2020)
    ctable = s$coefficients
  )

  class(result) <- c("summary.Cosinor", class(result))
  # uses print.summary.Cosinor
  result
}

#' @describeIn summary.Cosinor Print basic results from [cosinor()] using the
#'   `glm` print method.
#' @examples
#' \donttest{
#' ## cardiovascular disease data (offset based on number of days in...
#' ## ...the month scaled to an average month length)
#' res <- cosinor(
#'   cvd ~ 1,
#'   date = 'month',
#'   data = CVD,
#'   type = 'monthly',
#'   family = poisson(),
#'   offsetmonth = TRUE
#'   )
#' res
#' summary(res)
#' }
#' @export
print.Cosinor <- function(x, ...) {
  check_if_cosinor(x)
  ## Use GLM function ###
  print(x$glm, ...)
}

# October 2011
#' @describeIn summary.Cosinor Print a `summary.Cosinor` object: amplitude,
#'   phase, statistical significance, and the regression coefficient table.
#' @returns summary of output from [cosinor()].
#' @export
#' @examples
#' ## hourly indoor temperature data
#' res <- cosinor(
#'   bedroom ~ 1,
#'   date = 'datetime',
#'   type = 'hourly',
#'   data = indoor
#' )
#' summary(res)
#' # to get the p-values for the sine and cosine estimates
#' summary(res$glm)
print.summary.Cosinor <- function(x, ...) {
  check_if_class(x, "summary.Cosinor")
  # fix the digits, October 2011
  if (!x$text) {
    x$phase <- round(x$phase, x$digits)
    x$lphase <- round(x$lphase, x$digits)
  }

  cat('Cosinor test:\n')
  cat('Number of observations =', x$n, '\n')
  cat('Amplitude =', round(x$amp, x$digits), x$amp.scale, '\n')
  cat('Phase:', x$phase, '\n')
  cat('Low point:', x$lphase, '\n')
  if (x$type == 'hourly') {
    cat(
      'Significant circadian pattern based on adjusted significance level of',
      eval(x$alpha) / 2,
      ' = ',
      x$significant,
      '\n',
      ...
    )
  }
  if (x$type != 'hourly') {
    cat(
      'Significant seasonality based on adjusted significance level of',
      eval(x$alpha) / 2,
      ' = ',
      x$significant,
      '\n',
      ...
    )
  }

  # Added March 2020
  cat('\nRegression coefficients:\n')
  print(data.frame(x$ctable))
}
