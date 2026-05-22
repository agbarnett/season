check_if_class <- function(
  x,
  class,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  if (!inherits(x, class)) {
    cli::cli_abort(
      c(
        "{.arg {arg}} must be of class {.cls {class}}.",
        "i" = "We see class {.cls {class(x)}}."
      ),
      call = call
    )
  }
}

check_if_cosinor <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  check_if_class(x, "Cosinor", arg = arg, call = call)
}

check_if_monthglm <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  check_if_class(x, "monthglm", arg = arg, call = call)
}

check_if_monthmean <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  check_if_class(x, "Monthmean", arg = arg, call = call)
}

check_if_nonlintest <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  check_if_class(x, "nonlintest", arg = arg, call = call)
}

check_if_nscosinor <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  check_if_class(x, "nsCosinor", arg = arg, call = call)
}

check_if_casecross <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  check_if_class(x, "casecross", arg = arg, call = call)
}

check_if_date <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  if (!inherits(x, "Date")) {
    cli::cli_abort(
      c(
        "{.arg {arg}} must be in {.cls Date} format.",
        "i" = "See {.help Dates}."
      ),
      call = call
    )
  }
}


check_if_exclusion_lt_0 <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  if (x < 0) {
    cli::cli_abort(
      "{.arg {arg}} must be {.val 0} or greater.",
      call = call
    )
  }
}

check_formula_has_iv <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  if (length(x) <= 2) {
    cli::cli_abort(
      "{.arg {arg}} must have at least one independent variable.",
      call = call
    )
  }
}

check_if_logical <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  if (!is.logical(x)) {
    cli::cli_abort(
      c(
        "{.arg {arg}} must be {.cls logical}.",
        "i" = "We see class {.cls {class(x)}}."
      ),
      call = call
    )
  }
}

check_if_hourly_posixct <- function(
  type,
  date,
  arg = rlang::caller_arg(date),
  call = rlang::caller_env()
) {
  if (type == "hourly" && !inherits(date, "POSIXct")) {
    cli::cli_abort(
      "{.arg {arg}} must be of class {.cls POSIXct} when {.code type = \"hourly\"}.",
      call = call
    )
  }
}

check_if_daily_date <- function(
  type,
  date,
  arg = rlang::caller_arg(date),
  call = rlang::caller_env()
) {
  if (type == "daily" && !inherits(date, "Date")) {
    cli::cli_abort(
      "{.arg {arg}} must be of class {.cls Date} when {.code type = \"daily\"}.",
      call = call
    )
  }
}

check_if_within_values <- function(
  x,
  val1,
  val2,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  if (any(x < val1) || any(x > val2)) {
    cli::cli_abort(
      c(
        "{.arg {arg}} must be within {.val {val1}} and {.val {val2}}.",
        "i" = "We see a range of {.val {min(x)}} to {.val {max(x)}}."
      ),
      call = call
    )
  }
}

check_if_btn_values <- function(
  x,
  val1,
  val2,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  if (any(x <= val1) || any(x >= val2)) {
    cli::cli_abort(
      c(
        "{.arg {arg}} must be between {.val {val1}} and {.val {val2}}.",
        "i" = "We see a range of {.val {min(x)}} to {.val {max(x)}}."
      ),
      call = call
    )
  }
}

check_if_btn_0_1 <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  check_if_btn_values(x, 0, 1, arg = arg, call = call)
}

check_if_matrix <- function(
  matrix,
  arg = rlang::caller_arg(matrix),
  call = rlang::caller_env()
) {
  if (!is.matrix(matrix)) {
    cli::cli_abort(
      c(
        "{.arg {arg}} must be a {.cls matrix}.",
        "i" = "We see class {.cls {class(matrix)}}."
      ),
      call = call
    )
  }
}

check_if_square <- function(
  matrix,
  arg = rlang::caller_arg(matrix),
  call = rlang::caller_env()
) {
  if (dim(matrix)[1] != dim(matrix)[2]) {
    cli::cli_abort(
      c(
        "{.arg {arg}} must be a square matrix.",
        "i" = "We see dimensions {dim(matrix)[1]} x {dim(matrix)[2]}."
      ),
      call = call
    )
  }
}

check_if_symmetric <- function(
  matrix,
  arg = rlang::caller_arg(matrix),
  call = rlang::caller_env()
) {
  if (!isSymmetric(matrix)) {
    cli::cli_abort(
      "{.arg {arg}} must be a symmetric matrix.",
      call = call
    )
  }
}

check_tau_cycles <- function(
  tau,
  cycles,
  arg_tau = rlang::caller_arg(tau),
  arg_cycles = rlang::caller_arg(cycles),
  call = rlang::caller_env()
) {
  if (length(tau) != length(cycles) + 1) {
    cli::cli_abort(
      c(
        "{.arg {arg_tau}} must have length {.val {length(cycles) + 1}}.",
        "i" = "One smoothing parameter per cycle, plus one for trend.",
        "x" = "We see length({.arg {arg_tau}}) = {length(tau)}, length({.arg {arg_cycles}}) = {length(cycles)}."
      ),
      call = call
    )
  }
}

check_cycles <- function(
  cycles,
  arg = rlang::caller_arg(cycles),
  call = rlang::caller_env()
) {
  if (any(cycles <= 0)) {
    cli::cli_abort(
      c(
        "{.arg {arg}} must be greater than {.val 0}.",
        "x" = "We see {sum(cycles <= 0)} value{?s} <= 0."
      ),
      call = call
    )
  }
}

check_response_na <- function(
  resp,
  arg = rlang::caller_arg(resp),
  call = rlang::caller_env()
) {
  if (anyNA(resp)) {
    cli::cli_abort(
      c(
        "{.arg {arg}} must not contain missing values.",
        "x" = "We see {sum(is.na(resp))} missing value{?s}."
      ),
      call = call
    )
  }
}

check_burnin_iters <- function(
  burnin,
  niters,
  arg_burnin = rlang::caller_arg(burnin),
  arg_niters = rlang::caller_arg(niters),
  call = rlang::caller_env()
) {
  if (burnin > niters) {
    cli::cli_abort(
      c(
        "{.arg {arg_niters}} must be greater than {.arg {arg_burnin}}.",
        "x" = "We see {.arg {arg_burnin}} = {burnin}, {.arg {arg_niters}} = {niters}."
      ),
      call = call
    )
  }
}
