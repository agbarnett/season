# createAdj.R
# create an adjancency matrix by first creating a matrix

#' Creates an Adjacency Matrix
#'
#' Creates an adjacency matrix in a form suitable for using in `BRugs` or
#' WinBUGS.
#'
#' Adjacency matrices are used by conditional autoregressive (CAR) models to
#' smooth estimates according to some neighbourhood map.  The basic idea is
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
#' @return A list of:
#'   * num: the total number of neighbours
#'   * adj: the index number of the adjacent neighbours
#'   * weights: weights
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @examples
#' \donttest{
#' # Nearest neighbour matrix for 5 time points
#' x = c(NA,1,NA,NA,NA)
#' (V = toeplitz(x))
#' createAdj(V)
#' }
#'
#' @export createAdj
createAdj <- function(matrix, suffix = NULL) {
  # checks
  if (!is.matrix(matrix)) {
    stop('Input must be a matrix')
  }
  if (dim(matrix)[1] != dim(matrix)[2]) {
    stop('Matrix must be square')
  }
  if (!isSymmetric(matrix)) {
    stop('Matrix must be symmetric')
  }
  # Vectors from matrix
  n <- nrow(matrix)
  num <- rowSums(matrix, na.rm = TRUE)
  adj <- vector(length = sum(num), mode = 'numeric')
  weight <- vector(length = sum(num), mode = 'numeric')
  index <- 1
  for (i in 1:n) {
    ind <- !is.na(matrix[i, ])
    xxx <- as.numeric(ind) * (1:n)
    if (sum(xxx) > 0) {
      aaa <- xxx[ind]
      www <- matrix[i, ind]
      adj[index:(index + length(aaa) - 1)] <- aaa
      weight[index:(index + length(aaa) - 1)] <- www
      index <- index + length(aaa)
    }
  }

  toret <- list(
    num = num,
    adj = adj,
    weight = weight
  )
  return(toret)
}
