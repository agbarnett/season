\name{exercise}
\alias{exercise}
\docType{data}
\title{Exercise Data from Queensland, 2005--2007}
\description{
  Exercise data in longitudinal format from a physical activity intervention study in Logan, Queensland. Some subjects were lost to follow-up, so all three visits are not available for all subjects.}
\usage{data(exercise)}
\format{
  A data frame with 1302 observations on the following 7 variables.
  \describe{
    \item{\code{id}}{subject number}
    \item{\code{visit}}{visit number (1, 2 or 3)}
    \item{\code{date}}{date of interview (year-month-day)}
    \item{\code{year}}{year of interview}
    \item{\code{month}}{month of interview}
    \item{\code{bmi}}{body mass index at visit 1 (kg/m\eqn{^2})}
    \item{\code{walking}}{walking time per week (in minutes) at each visit}
  }
}
\source{
  From Prof Elizabeth Eakin and colleagues, The University of Queensland, Brisbane.
}
\references{Eakin E, et al (2009) Telephone counselling for physical activity and diet in type 2 diabetes and hypertension, \emph{Am J of Prev Med}, vol 36, pages 142--9}
\examples{\donttest{
data(exercise)
boxplot(exercise$walking ~ exercise$month)
}
}
\keyword{datasets}
