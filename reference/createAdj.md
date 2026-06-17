# Creates an Adjacency Matrix

Creates an adjacency matrix in a form suitable for use with
[`nimble`](https://CRAN.R-project.org/package=nimble)

## Usage

``` r
createAdj(matrix, suffix = NULL)
```

## Arguments

- matrix:

  square matrix with 1's for neighbours and NA's for non-neighbours.

- suffix:

  string to be appended to "num", "adj" and "weights" object names

## Value

A list of:

- num: the total number of neighbours

- adj: the index number of the adjacent neighbours

- weights: weights

## Details

Adjacency matrices are used by conditional autoregressive (CAR) models
to smooth estimates according to some neighbourhood map. The basic idea
is that neighbouring areas have more in common than non-neighbouring
areas and so will be positively correlated.

As well as correlations in space it is possible to use CAR models to
model similarities in time.

In this case the matrix represents those time points that we wish to
assume to be correlated.

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r
# \donttest{
# Nearest neighbour matrix for 5 time points
x <- c(NA,1,NA,NA,NA)
V <- toeplitz(x)
V
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,]   NA    1   NA   NA   NA
#> [2,]    1   NA    1   NA   NA
#> [3,]   NA    1   NA    1   NA
#> [4,]   NA   NA    1   NA    1
#> [5,]   NA   NA   NA    1   NA
createAdj(V)
#> $num
#> [1] 1 2 2 2 1
#> 
#> $adj
#> [1] 2 1 3 2 4 3 5 4
#> 
#> $weight
#> [1] 1 1 1 1 1 1 1 1
#> 
# }
```
