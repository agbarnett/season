\name{stillbirth}
\alias{stillbirth}
\docType{data}
\title{Stillbirths in Queensland, 1998--2000}
\description{
  Monthly number of stillbirths in Australia from 1998 to 2000. It is a rare event; there are 352 stillbirths out of 60,110 births.
  To preserve confidentiality the day of birth has been randomly re-ordered.}
\usage{data(stillbirth)}
\format{
  A data frame with 60,110 observations on the following 7 variables.
  \describe{
    \item{\code{dob}}{date of birth (year-month-day)}
    \item{\code{year}}{year of birth}
    \item{\code{month}}{month of birth}
    \item{\code{yrmon}}{a combination of year and month: \eqn{year+(month-1)/12}}
    \item{\code{seifa}}{SEIFA score, an area level measure of socioeconomic status in quintiles}
    \item{\code{gestation}}{gestation in weeks}
    \item{\code{stillborn}}{stillborn (yes/no); 1=Yes, 0=No}
  }
}
\source{
  From Queensland Health (\url{http://www.health.qld.gov.au/}).
}
\examples{\donttest{
data(stillbirth)
table(stillbirth$month, stillbirth$stillborn)
}
}
