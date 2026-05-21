## Oct 2011
#' Case--crossover Analysis to Control for Seasonality
#'
#' Fits a time-stratified case--crossover to regularly spaced time series data.
#' The function is not suitable for irregularly spaced individual data. The
#' function only uses a time-stratified design, and other designs such as the
#' symmetric bi-directional design, are not available.
#'
#' The case--crossover method compares "case" days when events occurred
#' (e.g., deaths) with control days to look for differences in exposure that
#' might explain differences in the number of cases. Control days are selected
#' to be nearby to case days, which means that only recent changes in the
#' independent variable(s) are compared. By only comparing recent values, any
#' long-term or seasonal variation in the dependent and independent variable(s)
#' can be eliminated. This elimination depends on the definition of nearby and
#' on the seasonal and long-term patterns in the independent variable(s).
#'
#' Control and case days are only compared if they are in the same stratum. The
#' stratum is controlled by `stratalength`, the default value is 28 days,
#' so that cases and controls are compared in four week sections.  Smaller
#' stratum lengths provide a closer control for season, but reduce the
#' available number of controls.  Control days that are close to the case day
#' may have similar levels of the independent variable(s). To reduce this
#' correlation it is possible to place an `exclusion` around the cases.
#' The default is 2, which means that the smallest gap between a case and
#' control will be 3 days.
#'
#' To remove any confounding by day of the week it is possible to additionally
#' match by day of the week (`matchdow`), although this usually reduces
#' the number of available controls. This matching is in addition to the strata
#' matching.
#'
#' It is possible to additionally match case and control days by an important
#' confounder (`matchconf`) in order to remove its effect. Control days
#' are matched to case days if they are:
#'   i) in the same strata,
#'   ii) have the same day of the week if `matchdow=TRUE`,
#'   iii) have a value of `matchconf` that is within plus/minus `confrange` of
#'   the value of `matchconf` on the case day.
#'
#' If the range is set too narrow then the number of available controls will
#' become too small, which in turn means the number of case days with at least
#' one control day is compromised.
#'
#' The method uses conditional logistic regression (see [survival::coxph()]),
#' so the parameter estimates are odds ratios.
#'
#' The code assumes that the data frame contains a date variable (in
#' [Date()] format) called "date".
#'
#' @param formula formula. The dependent variable should be an integer count
#' (e.g., daily number of deaths).
#' @param data data set as a data frame.
#' @param exclusion exclusion period (in days) around cases, set to 2
#' (default). Must be greater than or equal to zero and smaller than
#' `stratalength`.
#' @param stratalength length of stratum in days, set to 28 (default).
#' @param matchdow match case and control days using day of the week
#' (TRUE/default=FALSE). This matching is in addition to the strata matching.
#' @param usefinalwindow use the last stratum in the time series, which is
#' likely to contain less days than all the other strata (TRUE/default=FALSE).
#' @param matchconf match case and control days using an important confounder
#' (optional; must be in quotes). `matchconf` is the variable to match on.
#' This matching is in addition to the strata matching. Default is NULL - no
#' confounder is used.
#' @param confrange range of the confounder within which case and control days
#' will be treated as a match (optional). Range = `matchconf` (on case
#' day) \eqn{+/-} `confrange`.
#' @param stratamonth use strata based on months, default=FALSE. Instead of a
#' fixed strata size when using `stratalength`.
#' @returns a list with the following elements:
#'   * call: the original call to the casecross function.
#'   * cox_model: conditional logistic regression model of class `coxph`.
#'   * n_cases: total number of cases.
#'   * n_case_days: number of case days with at least one control day.
#'   * n_control_days: average number of control days per case day.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso `summary.casecross`, `coxph`
#' @references Janes, H., Sheppard, L., Lumley, T. (2005) Case-crossover
#' analyses of air pollution exposure data: Referent selection strategies and
#' their implications for bias. *Epidemiology* 16(6), 717--726.
#' \doi{doi:10.1097/01.ede.0000181315.18836.9d.}
#'
#' Barnett, A.G., Dobson, A.J. (2010) *Analysing Seasonal Health Data*.
#' Springer. \doi{doi:10.1007/978-3-642-10748-1}
#' @examples
#' \donttest{
#' # cardiovascular disease data
#' # subset for example
#' CVDdaily <- subset(CVDdaily, date <= as.Date('1987-12-31'))
#' # Effect of ozone on CVD death
#' model1 <- casecross(
#'   cvd ~ o3mean + tmpd + Mon + Tue + Wed + Thu + Fri + Sat,
#'   data = CVDdaily
#' )
#' summary(model1)
#' # match on day of the week
#' model2 <- casecross(cvd ~ o3mean + tmpd, matchdow = TRUE, data = CVDdaily)
#' summary(model2)
#' # match on temperature to within a degree
#' model3 <- casecross(
#'   cvd ~ o3mean + Mon + Tue + Wed + Thu + Fri + Sat,
#'   data = CVDdaily,
#'   matchconf = "tmpd",
#'   confrange = 1
#' )
#' summary(model3)
#' }
#'
#' @export
casecross <- function(
  formula,
  data,
  exclusion = 2,
  stratalength = 28,
  matchdow = FALSE,
  usefinalwindow = FALSE,
  matchconf = NULL,
  confrange = 0,
  stratamonth = FALSE
) {
  # Setting some variables to NULL first (for R CMD check)
  outcome <- dow <- case <- timex <- dow.x <- dow.y <- match_day.x <- NULL
  match_day.y <- window_num.x <- window_num.y <- NULL
  this_data <- data
  this_data$dow <- as.numeric(format(this_data$date, '%w'))

  check_if_date(this_data$date)
  check_if_exclusion_lt_0(exclusion)
  check_formula_has_iv(formula)

  ## original call with defaults (see amer package)
  call <- match_call_with_defaults(match.call(), sys.function())

  form <- append_terms_to_formula(formula, "date + dow")

  if (!is.null(matchconf)) {
    parts <- paste(formula)
    dep <- parts[2]
    indep <- parts[3]
    form <- stats::as.formula(paste(dep, "~", indep, '+date+dow+', matchconf))
  }

  # remove cases with missing covariates
  data_to_use <- stats::model.frame(
    form,
    data = this_data,
    na.action = stats::na.omit
  )

  inform_irregularly_spaced(data_to_use$date)

  ## Create strata
  if (stratamonth) {
    match_day <- as.numeric(format(data_to_use$date, '%d'))
    window_num <- window_num_stratamonth(data_to_use$date)
  }

  # use minimum data in entire sample
  date_diff <- as.numeric(data_to_use$date) - min(as.numeric(data_to_use$date))
  # used as strata number
  time <- as.numeric(date_diff) + 1
  if (!stratamonth) {
    ## Get the earliest time and difference all dates from this time
    ## Increase strata windows in jumps of 'stratalength'
    window_num <- floor(date_diff / stratalength) + 1
    n_windows <- floor(nrow(this_data) / stratalength) + 1
    # Day number in strata
    match_day <- date_diff - ((window_num - 1) * stratalength) + 1
    ## Exclude the last window if it is less than 'stratalength'
    last_window <- data_to_use[data_to_use$window_num == n_windows, ]
    if (nrow(last_window) > 0) {
      # only apply to data sets with some data in the final window
      last_length <- max(time[window_num == n_windows]) -
        min(time[window_num == n_windows]) +
        1
      if (last_length < stratalength && !usefinalwindow) {
        data_to_use <- data_to_use[window_num < n_windows, ]
      }
    }
  }
  ## Create the case data
  cases <- data_to_use
  # binary indicator of case
  cases$case <- 1
  # Needed for conditional logistic regression
  cases$timex <- 1
  cases$window_num <- window_num
  cases$time <- time
  cases$diff_days <- NA
  cases$match_day <- match_day
  cases$outcome <- data_to_use[, as.character(formula[2])]

  # Create a case number for matching
  if (is.null(matchconf)) {
    cases_to_merge <- subset(
      cases,
      select = c(match_day, time, outcome, window_num, dow)
    )
  }
  if (!is.null(matchconf)) {
    also <- match(matchconf, names(cases))
    cases_to_merge <- subset(
      cases,
      select = c(match_day, time, outcome, window_num, dow, also)
    )
  }
  n_cases <- nrow(cases)
  cases_to_merge$case_num <- 1:n_cases
  # Duplicate case series to make controls
  max_windows <- max(cases$window_num)
  rows_to_rep <- NULL
  case_num <- NULL
  # Fix for missing windows (thanks to Yuming)
  windowrange <- as.numeric(levels(as.factor(window_num)))
  for (k in windowrange) {
    # loop through every window
    small <- min(cases$time[cases$window_num == k])
    large <- max(cases$time[cases$window_num == k])
    these <- rep(small:large, large - small + 1)
    rows_to_rep <- c(rows_to_rep, these)
    case_num <- c(case_num, sort(these))
  }
  # create controls from cases
  # can fall over if there's missing data
  controls <- cases[rows_to_rep, ]
  controls <- subset(controls, select = c(-case, -timex, -time, -outcome))
  # Replace case number
  controls$case_num <- case_num
  # Merge cases with controls by case number
  controls <- merge(controls, cases_to_merge, by = 'case_num')
  # must be in same stratum window
  controls <- controls[controls$window_num.x == controls$window_num.y, ]
  # binary indicator of case
  controls$case <- 0
  # Needed for conditional logistic regression
  controls$timex <- 2
  controls$diff_days <- abs(controls$match_day.x - controls$match_day.y)
  # remove the exclusion window
  controls <- controls[controls$diff_days > exclusion, ]
  # match on day of the week
  if (matchdow) {
    controls <- controls[controls$dow.x == controls$dow.y, ]
  }
  # match on a confounder
  if (!is.null(matchconf)) {
    one <- paste0(matchconf, '.x')
    two <- paste0(matchconf, '.y')
    find_1 <- grep(one, names(controls))
    find_2 <- grep(two, names(controls))
    match_diff <- abs(controls[, find_1] - controls[, find_2])
    controls <- controls[match_diff <= confrange, ]
    controls <- subset(
      controls,
      select = c(
        -case_num,
        -dow.x,
        -dow.y,
        -match_day.x,
        -match_day.y,
        -window_num.x,
        -window_num.y,
        -find_1,
        -find_2
      )
    )
    find_c <- match(matchconf, names(cases))

    final_cases <- subset(
      cases,
      select = c(-dow, -match_day, -window_num, -find_c)
    )
    # update formula to remove matchconf
    indep <- gsub(indep, pattern = paste0("\\+ ", matchconf), replacement = '')
  }
  if (is.null(matchconf)) {
    controls <- subset(
      controls,
      select = c(
        -case_num,
        -dow.x,
        -dow.y,
        -match_day.x,
        -match_day.y,
        -window_num.x,
        -window_num.y
      )
    )
    final_cases <- subset(cases, select = c(-dow, -match_day, -window_num))
  }
  finished <- rbind(final_cases, controls)
  ## Remove empty controls
  finished <- finished[finished$outcome > 0, ]
  ## Count the number of control days without a case day, and the total number
  ## of cases
  only_control <- finished[finished$case == 0, ]
  n_cases <- nrow(table(only_control$time))
  which_times <- unique(only_control$time)
  extra_only <- final_cases[final_cases$time %in% which_times, ]
  n_controls <- round(mean(as.numeric(table(only_control$time))), 1)
  ## Run the conditional logistic regression

  indep <- parse_indep(formula)

  form_final <- stats::as.formula(paste(
    'Surv(timex,case)~',
    indep,
    '+strata(time)'
  ))

  cox_model <- survival::coxph(
    form_final,
    weights = outcome,
    data = finished,
    method = "breslow"
  )

  result <- list(
    call = call,
    cox_model = cox_model,
    n_cases = sum(extra_only$outcome),
    n_case_days = n_cases,
    n_control_days = n_controls
  )

  class(result$cox_model) <- c("coxph", class(cox_model))
  class(result) <- c("casecross", class(result))

  result
}
