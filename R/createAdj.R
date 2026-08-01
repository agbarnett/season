#' Creates an Adjacency Matrix
#'
#' Creates an adjacency matrix in a form suitable for use with
#'   [`nimble`](https://CRAN.R-project.org/package=nimble)
#'
#' Adjacency matrices are used by conditional autoregressive (CAR) models to
#' smooth estimates according to some neighbourhood map. The basic idea is
#' that neighbouring areas have more in common than non-neighbouring areas and
#' so will be positively correlated.
#'
#' As well as correlations in space it is possible to use CAR models to model
#' similarities in time.
#'
#' In this case the matrix represents those time points that we wish to assume
#' to be correlated.
#'
#' @param matrix square matrix with 1's for neighbours and NA's for
#' non-neighbours.
#' @param suffix string to be appended to "num", "adj" and
#' "weights" object names
#' @returns A list of:
#'   * num: the total number of neighbours
#'   * adj: the index number of the adjacent neighbours
#'   * weights: weights
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @examples
#' \donttest{
#' # Nearest neighbour matrix for 5 time points
#' x <- c(NA,1,NA,NA,NA)
#' V <- toeplitz(x)
#' V
#' createAdj(V)
#' }
#'
#' @export createAdj
createAdj <- function(matrix, suffix = NULL) {
  check_if_matrix(matrix)
  check_if_square(matrix)
  check_if_symmetric(matrix)

  all_missing <- all(is.na(matrix))
  # return early
  if (all_missing) {
    return(
      list(
        num = rep(0, nrow(matrix)),
        adj = 0,
        weight = 0
      )
    )
  }

  # Vectors from matrix
  num <- rowSums(matrix, na.rm = TRUE)
  is_present <- !is.na(matrix)
  # This is essentially a rowwise which
  adj <- which(is_present, arr.ind = TRUE, useNames = FALSE)[, 1]
  weight <- rep(1, sum(is_present))

  ret <- list(
    num = num,
    adj = adj,
    weight = weight
  )

  ret
}
