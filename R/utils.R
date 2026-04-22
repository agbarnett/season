#' Keep Month Numbers
#'
#' This is an internal function that only keeps the numbers of a string.
#'   This is used in the process of transferring months names to numbers.
#'
#' @param x character text
#'
#' @returns character text with only numbers.
#' @note internal
#' @noRd
keep_month_numbers <- function(x) {
  as.numeric(gsub(pattern = "[^0-9]", replacement = "", x = x))
}
