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
