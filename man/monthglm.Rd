\name{monthglm}
\alias{monthglm}
\alias{print.monthglm}
\title{Fit a GLM with Month}
\description{Fit a generalized linear model with a categorical
  variable of month.}
\usage{
monthglm(formula, data, family=gaussian(), refmonth=1,
         monthvar='month',offsetmonth=FALSE, offsetpop=NULL)
\method{print}{monthglm}(x, ...)
}
\arguments{
  \item{formula}{regression model formula, e.g., \code{y~x1+x2}, (do not
    add month to the regression equation, it will be added
    automatically).}
  \item{data}{a data frame.}
  \item{family}{a description of the error distribution and link
    function to be used in the model (default=\code{gaussian()}). (See
    \code{\link{family}} for details of family functions.).}
  \item{refmonth}{reference month, must be between 1 and 12 (default=1
    for January).}
  \item{monthvar}{name of the month variable which is either
    an integer (1 to 12) or a character or factor (`Jan' to
    `Dec' or `January' to `December') (default='month').}
  \item{offsetmonth}{include an offset to account for the uneven number
    of days in the month (TRUE/FALSE). Should be used for monthly counts
    (with \code{family=poisson()}).}
  \item{offsetpop}{include an offset for the population (optional), this
    should be a variable in the data frame. Do not log-transform the
    offset as the log-transform is applied by the function.}
  \item{x}{Object of class \code{monthglm}}
  \item{\dots}{further arguments passed to or from other methods.}
}
\details{Month is fitted as a categorical variable as part of a
  generalized linear model. Other independent variables can be added to
  the right-hand side of \code{formula}.

  This model is useful for examining non-sinusoidal seasonal
  patterns. For sinusoidal seasonal patterns see \code{\link{cosinor}}.

  The data frame should contain the integer months and the year as a 4 digit number. These are used to calculate the number of days in each month accounting for leap years.
}
\value{
  \item{call}{the original call to the monthglm function.}
  \item{fit}{GLM model.}
  \item{fitted}{fitted values.}
  \item{residuals}{residuals.}
  \item{out}{details on the monthly estimates.}
}
\seealso{\code{summary.monthglm}, \code{plot.monthglm}}
\references{Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal Health Data}. Springer.}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{\donttest{
data(CVD)
mmodel = monthglm(formula=cvd~1 ,data=CVD, family=poisson(),
                  offsetpop=expression(pop/100000), offsetmonth=TRUE)
summary(mmodel)
}
}
