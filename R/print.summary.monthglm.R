# print.summary.monthglm.R

#' printing a summary of a month.glm
#' @name print.summary.monthglm
#' @method print summary.monthglm
#' @param x a \code{summary.monthglm} object produced by
#' \code{summary.monthglm}.
#' @param \dots further arguments passed to or from other methods.
#' @export
print.summary.monthglm <- function(x, ...){
  ## report results
  cat('Number of observations =',x$n,'\n')
  if (x$month.effect=="RR"){
    cat('Rate ratios','\n')
  }
  if (x$month.effect=="OR"){
    cat('Odds ratios','\n')
  }
  print(x$month.ests, ...)
}
