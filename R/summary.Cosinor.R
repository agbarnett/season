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
#' @return `summary.Cosinor()` returns a list with the following named elements:
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
  type <- object$call$type

  if (!inherits(object, "Cosinor")) {
    stop("Object must be of class 'Cosinor'")
  }
  s <- summary(object$glm) # create summary
  cnames <- row.names(s$coefficients)
  cindex <- sum(as.numeric(cnames == 'cosw') * (seq_along(cnames)))
  sindex <- sum(as.numeric(cnames == 'sinw') * (seq_along(cnames)))
  # amplitude and phase
  amp <- sqrt((s$coefficients[cindex, 1]^2) + (s$coefficients[sindex, 1]^2))
  addition <- ''
  link <- s$family$link
  if (is.null(s$family$link)) {
    link <- ' '
  }
  if (link == 'logit') {
    # back-transform amp
    p1 <- exp(s$coefficients[1, 1]) / (1 + exp(s$coefficients[1, 1]))
    # back-transform amp
    p2 <- exp(s$coefficients[1, 1] + amp) /
      (1 + exp(s$coefficients[1, 1] + amp))
    amp <- p2 - p1
    addition <- "(probability scale)"
  }
  if (link == 'cloglog') {
    p1 <- 1 - exp(-exp(s$coefficients[1, 1]))
    p2 <- 1 - exp(-exp(s$coefficients[1, 1] + amp))
    amp <- p2 - p1
    addition <- "(probability scale)"
  }
  if (link == 'log') {
    amp <- exp(s$coefficients[1, 1] + amp) - exp(s$coefficients[1, 1])
    addition <- "(absolute scale)"
  }
  phaser <- phasecalc(
    cosine = s$coefficients[cindex, 1],
    sine = s$coefficients[sindex, 1]
  )
  # convert radian phase to a date
  phase <- invyrfraction(
    frac = phaser / (2 * pi),
    type = object$call$type,
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
    type = object$call$type,
    text = object$call$text
  )
  # statistical signficance
  toreport <- rbind(s$coefficients[cindex, ], s$coefficients[sindex, ])
  adjusted <- eval(object$call$alpha) / 2
  significant <- as.logical(sum(toreport[, 4] < adjusted))
  # returns
  ret <- list()
  ret$n <- length(object$residuals)
  ret$amp <- amp
  ret$amp.scale <- addition
  ret$phase <- phase
  ret$lphase <- lphase
  ret$significant <- significant
  ret$alpha <- object$call$alpha
  ret$digits <- digits
  ret$text <- object$call$text # display phase as text (TRUE/FALSE)
  ret$type <- type
  ret$ctable <- s$coefficients # regression table (march 2020)
  class(ret) <- "summary.Cosinor"
  ret # uses print.summary.Cosinor
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
  if (!inherits(x, "Cosinor")) {
    stop("Object must be of class 'Cosinor'")
  }

  ## Use GLM function ###
  print(x$glm, ...)
} # end of function

# October 2011
#' @describeIn summary.Cosinor Print a `summary.Cosinor` object: amplitude,
#'   phase, statistical significance, and the regression coefficient table.
#' @returns summary of output from [cosinor()].
#' @export
#' @examples
#' ## hourly indoor temperature data
#' res = cosinor(bedroom~1, date='datetime', type='hourly', data=indoor)
#' summary(res)
#' # to get the p-values for the sine and cosine estimates
#' summary(res$glm)
print.summary.Cosinor <- function(x, ...) {
  ## report results
  if (!inherits(x, "summary.Cosinor")) {
    stop("Object must be of class 'summary.Cosinor'")
  }
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
