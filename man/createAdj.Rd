\name{createAdj}
\alias{createAdj}
\title{Creates an adjacency matrix}
\description{Creates an adjacency matrix in a form suitable for using in
  \code{BRugs} or WinBUGS.
}
\usage{createAdj(matrix, filename='Adj.txt', suffix=NULL)} 
\arguments{
  \item{matrix}{square matrix with 1's for neighbours and NA's for
    non-neighbours.}
  \item{filename}{filename that the adjacency matrix file will be
    written to (default=\sQuote{Adj.txt}).}
  \item{suffix}{string to be appended to \sQuote{num}, \sQuote{adj} and
    \sQuote{weights} object names}
}
\details{Adjacency matrices are used by conditional autoregressive (CAR)
  models to smooth estimates according to some neighbourhood map. 
  The basic idea is that neighbouring areas have more in common than
  non-neighbouring areas and so will be positively correlated.

  As well as correlations in space it is possible to use CAR models to
  model similarities in time.

  In this case the matrix represents those time points that we wish to
  assume to be correlated.
}
\value{
  Creates a text file named \code{filename} that contains the total
  number of neighbours (num), the index number of the adjacent
  neighbours (adj) and the weights (weights).
} 
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{
\donttest{
# Nearest neighbour matrix for 5 time points
x = c(NA,1,NA,NA,NA)
(V = toeplitz(x))
createAdj(V)
}
}
