#' Fit a GLM with Month
#'
#' Fit a generalized linear model with a categorical variable of month.
#'
#' Month is fitted as a categorical variable as part of a generalized linear
#' model. Other independent variables can be added to the right-hand side of
#' `formula`.
#'
#' This model is useful for examining non-sinusoidal seasonal patterns. For
#' sinusoidal seasonal patterns see [cosinor()].
#'
#' The data frame should contain the integer months and the year as a 4 digit
#' number. These are used to calculate the number of days in each month
#' accounting for leap years.
#'
#' @param formula regression model formula, e.g., `y~x1+x2`, (do not add
#' month to the regression equation, it will be added automatically).
#' @param data a data frame. Must contain the column "months" as integer, and
#'   year as a 4 digit number.
#' @param family a description of the error distribution and link function to
#' be used in the model (default=`gaussian()`). (See [family()]
#' for details of family functions.).
#' @param refmonth reference month, must be between 1 and 12 (default=1 for
#' January).
#' @param monthvar name of the month variable which is either an integer (1 to
#' 12) or a character or factor (`Jan' to `Dec' or `January' to `December')
#' (default='month').
#' @param offsetmonth include an offset to account for the uneven number of
#' days in the month (TRUE/FALSE). Should be used for monthly counts (with
#' `family=poisson()`).
#' @param offsetpop include an offset for the population (optional), this
#' should be a variable in the data frame. Do not log-transform the offset as
#' the log-transform is applied by the function. This should be an expression,
#' as given in the example below.
#' @returns a list with the following elements:
#'   * call: the original call to the monthglm function.
#'   * fit: GLM model.
#'   * fitted: fitted values.
#'   * residuals: residuals.
#'   * out: details on the monthly estimates.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso `summary.monthglm`, `plot.monthglm`
#' @references Barnett, A.G., Dobson, A.J. (2010) *Analysing Seasonal
#' Health Data*. Springer. \doi{doi:10.1007/978-3-642-10748-1}
#' @examples
#'
#' model <- monthglm(
#'   formula = cvd~1,
#'   data = CVD,
#'   family = poisson(),
#'   offsetpop = expression(pop/100000),
#'   offsetmonth = TRUE
#'   )
#' summary(model)
#'
#' @export monthglm
monthglm <- function(
  formula,
  data,
  family = stats::gaussian(),
  refmonth = 1,
  monthvar = 'month',
  offsetmonth = FALSE,
  offsetpop = NULL
) {
  # between 1-12
  check_if_within_values(refmonth, 1, 12)
  check_if_logical(offsetmonth)

  ## original call with defaults (see amer package)
  call <- match_call_with_defaults(match.call(), sys.function())

  monthvar <- data[[monthvar]]
  ## If month is a character, create the numbers
  if (inherits(monthvar, "character")) {
    month_levels <- shorten_month_name(monthvar)
    monthvar <- factor(monthvar, levels = month_levels)
  }

  if (inherits(monthvar, "factor")) {
    # add to data for flagleap
    data$month <- as.numeric(monthvar)
    months <- relevel_months_by_ref(monthvar, refmonth)
  }

  ## Transform month numbers to names
  if (inherits(monthvar, "integer") || inherits(monthvar, "numeric")) {
    months <- relevel_months_by_ref_name(monthvar, refmonth)
  }

  # get the number of days in each month
  days <- flagleap(data = data, report = FALSE, matchin = TRUE)
  l <- nrow(data)
  if (!is.null(offsetpop)) {
    pop_offset <- with(data, eval(offsetpop))
  } else {
    pop_offset <- rep(1, l)
  } #
  if (offsetmonth) {
    month_offset <- days$n_days_month / (365.25 / 12)
  } else {
    month_offset <- rep(1, l)
  } # days per month divided by average month length
  model_offset <- log(pop_offset * month_offset)

  ## prepare data/formula
  ## A bit of a workaround update.formula(), since this doesn't really
  ## work how we expect, see
  ## stackoverflow.com/questions/40308944/removing-offset-terms-from-a-formula
  form <- append_terms_to_formula(formula, "months")

  fit <- stats::glm(
    formula = form,
    data = data,
    family = family,
    offset = model_offset
  )

  model_fit <- list(
    call = call,
    glm = fit,
    fitted.values = stats::fitted(fit),
    residuals = stats::residuals(fit)
  )

  class(model_fit) <- c("monthglm", class(model_fit))

  model_fit
}
