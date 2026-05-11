#' Calculate monthly mean or adjusted monthly mean for count data.
#'
#' For time series recorded at monthly intervals it is often useful to examine
#' (and plot) the average in each month. When using count data we should adjust
#' the mean to account for the unequal number of days in the month (e.g., 31 in
#' January and 28 or 29 in February).
#'
#' This function assumes that the data set (`data`) contains variables for
#' the year and month called year and month, respectively.
#'
#' @param data Data frame with variables "month" and "year"
#' @param resp Response variable in data for which the means will be calculated.
#' @param offsetpop optional population, used as an offset (default=NULL).
#' @param adjmonth adjust monthly counts and scale to a 30 day month ("thirty")
#'   or the average month length ("average") (default="none").
#' @returns Returns an object of class "Monthmean" with the following
#' parts:
#'   * mean: a vector of length 12 with the monthly means.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [plot.Monthmean()]
#' @references Barnett, A.G., Dobson, A.J. (2010) *Analysing Seasonal
#' Health Data*. Springer. \doi{doi:10.1007/978-3-642-10748-1}
#' @examples
#' \donttest{
#' # cardiovascular disease data
#' mmean <- monthmean(
#'   data=CVD,
#'   resp='cvd',
#'   offsetpop = expression(pop/100000),
#'   adjmonth = 'average'
#'   )
#' mmean
#' plot(mmean)
#'
#' mmean <- monthmean(
#'   data=CVD,
#'   resp='cvd',
#'   offsetpop = expression(pop/100000),
#'   adjmonth = 'thirty'
#'   )
#' }
#'
#' @export monthmean
monthmean <- function(
  data,
  resp,
  offsetpop = NULL,
  adjmonth = c("none", "thirty", "average")
) {
  adjmonth <- rlang::arg_match(adjmonth)

  if (is.null(data)) {
    stop("must have an input data set (data)")
  }
  if (is.null(resp)) {
    stop("must have an input variable (resp)")
  }
  nnn <- names(data)
  if (!any(nnn == 'year')) {
    stop("data set must contain a variable with the 4 digit year called 'year'")
  }
  if (!any(nnn == 'month')) {
    stop(
      "data set must contain a variable with the numeric month called 'month'"
    )
  }
  # get the number of days in each month
  days <- flagleap(data)

  if (is.null(offsetpop)) {
    adjp <- 1
  } else {
    adjp <- with(data, eval(offsetpop))
  } # population adjustment

  resp_vec <- data[[resp]]

  mean_adjust <- function(adjf) {
    mean <- vector(length = 12, mode = 'numeric')
    for (i in 1:12) {
      mean[i] <- mean(
        resp_vec[data$month == i] * (adjf / days$n_days_month[i]) / adjp
      )
    }
    mean
  }

  if (adjmonth == 'thirty') {
    mean <- mean_adjust(adjf = 30)
  }
  if (adjmonth == 'average') {
    mean <- mean_adjust(adjf = 365.25 / 12)
  }

  if (adjmonth == "none") {
    mean <- stats::aggregate(
      x = data[[resp]],
      by = list(data$month),
      FUN = \(x) {
        mean(x / adjp)
      }
    )[, 2]
  }

  result <- list(
    mean = as.vector(mean)
  )

  class(result) <- c('Monthmean', class(result))

  result
}
