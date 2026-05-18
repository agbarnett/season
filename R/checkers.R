check_if_class <- function(x, class) {
  if (!inherits(x, class)) {
    stop(
      "x must be of class: ",
      class,
      "\nWe see class: ",
      class(x),
      call. = FALSE
    )
  }
}

check_if_cosinor <- function(x) {
  check_if_class(x, "Cosinor")
}

check_if_monthglm <- function(x) {
  check_if_class(x, "monthglm")
}

check_if_monthmean <- function(x) {
  check_if_class(x, "Monthmean")
}

check_if_nonlintest <- function(x) {
  check_if_class(x, "nonlintest")
}

check_if_nscosinor <- function(x) {
  check_if_class(x, "nsCosinor")
}

check_if_casecross <- function(x) {
  check_if_class(x, "casecross")
}

check_if_date <- function(x) {
  if (!inherits(x, "Date")) {
    stop(
      "date variable must be in date format, see ?Dates",
      call. = FALSE
    )
  }
}

check_if_exclusion_lt_0 <- function(x) {
  if (x < 0) {
    stop(
      "Minimum value for exclusion is zero",
      call. = FALSE
    )
  }
}

check_formula_has_iv <- function(x) {
  if (length(x) <= 2) {
    stop(
      "Must be at least one independent variable",
      call. = FALSE
    )
  }
}

check_if_logical <- function(x) {
  if (!is.logical(x)) {
    stop(
      "x must be of class: logical",
      "\nWe see class: ",
      class(x),
      call. = FALSE
    )
  }
}

check_if_hourly_posixct <- function(type, date) {
  if (type == 'hourly' && !inherits(date, "POSIXct")) {
    stop(
      "date variable must be of class POSIXct when type = 'hourly'",
      call. = FALSE
    )
  }
}

check_if_daily_date <- function(type, date) {
  if (type == 'daily' && !inherits(date, 'Date')) {
    stop(
      "date variable must be of class Date when type = 'daily'",
      call. = FALSE
    )
  }
}

check_if_within_values <- function(x, val1, val2) {
  if (any(x < val1) || any(x > val2)) {
    stop(
      "x must be within ",
      val1,
      " and ",
      val2,
      "\n",
      "We see a range of: ",
      min(x),
      "-",
      max(x),
      call. = FALSE
    )
  }
}

check_if_btn_values <- function(x, val1, val2) {
  if (any(x <= val1) || any(x >= val2)) {
    stop(
      "x must be between ",
      val1,
      " and ",
      val2,
      "\n",
      "We see a range of: ",
      min(x),
      "-",
      max(x),
      call. = FALSE
    )
  }
}

check_if_btn_0_1 <- function(x) {
  check_if_btn_values(x, 0, 1)
}

check_if_matrix <- function(matrix) {
  if (!is.matrix(matrix)) {
    stop(
      'Input must be a matrix',
      "\nWe see class: ",
      class(matrix),
      call. = FALSE
    )
  }
}

check_if_square <- function(matrix) {
  if (dim(matrix)[1] != dim(matrix)[2]) {
    stop(
      'Matrix must be square',
      "\nWe see dim: ",
      dim(matrix)[1],
      "x",
      dim(matrix)[2],
      call. = FALSE
    )
  }
}

check_if_symmetric <- function(matrix) {
  if (!isSymmetric(matrix)) {
    stop('Matrix must be symmetric', call. = FALSE)
  }
}

check_tau_cycles <- function(tau, cycles) {
  if (length(tau) != length(cycles) + 1) {
    stop(
      "'tau' must be a vector of size 'cycle' + 1\n",
      "i.e., a smoothing parameter (tau) for each cycle, plus one for trend\n",
      "We see:\n",
      "length tau:",
      length(tau),
      "\n",
      "length cycle:",
      length(cycles),
      call. = FALSE
    )
  }
}

check_cycles <- function(cycles) {
  if (any(sum(cycles <= 0))) {
    stop(
      "cycles must be > 0\n",
      "There are ",
      sum(cycles <= 0),
      " values below 0",
      call. = FALSE
    )
  }
}

check_response_na <- function(resp) {
  if (anyNA(resp)) {
    stop(
      "There must be no missing data in the dependent variable\n",
      "We see: ",
      sum(is.na(resp)),
      " missing value(s)",
      call. = FALSE
    )
  }
}

check_burnin_iters <- function(burnin, niters) {
  if (burnin > niters) {
    stop(
      "Number of iterations must be greater than burn-in\n",
      "We see:\n",
      "burnin: ",
      burnin,
      "\nniters: ",
      burnin,
      call. = FALSE
    )
  }
}
