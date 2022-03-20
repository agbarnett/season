#' season: Tools for Uncovering and Estimating Seasonal Patterns.
#' 
#' The package contains graphical methods for displaying seasonal data and
#' regression models for detecting and estimating seasonal patterns.
#' 
#' The regression models can be applied to normal, Poisson or binomial
#' dependent data distributions. Tools are available for both time series data
#' (equally spaced in time) and survey data (unequally spaced in time).
#' 
#' Sinusoidal (parametric) seasonal patterns are available
#' (\code{\link{cosinor}}, \code{\link{nscosinor}}), as well as models for
#' monthly data (\code{\link{monthglm}}), and the case-crossover method to
#' control for seasonality (\code{\link{casecross}}).
#' 
#' \code{season} aims to fill an important gap in the software by providing a
#' range of tools for analysing seasonal data. The examples are based on health
#' data, but the functions are equally applicable to any data with a seasonal
#' pattern.
#' 
#' @name season-package
#' @aliases season-package season
#' @docType package
#' @importFrom grDevices gray
#' @importFrom graphics axis box hist lines par plot points polygon rug text
#' @importFrom stats acf as.formula cpgram fft fitted gaussian glm median model.frame na.omit pchisq qchisq qnorm quantile relevel resid residuals rgamma rnorm runif sd time acf as.formula cpgram fft fitted gaussian glm median model.frame na.omit pchisq qchisq qnorm quantile relevel resid residuals rgamma rnorm runif sd time
#' @import MASS
#' @import ggplot2 
#' @import survival
#' @author Adrian Barnett <a.barnett@qut.edu.au>\cr Peter Baker\cr Oliver Hughes 
#' 
#' Maintainer: Adrian Barnett <a.barnett@qut.edu.au>
#' @references Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal
#' Health Data}. Springer.
#' @keywords package ts models
NULL

#' Australian Football League (AFL) Players' Birthdays for the 2009 Season
#' 
#' The data are: a) the monthly frequencies of birthdays and an expected number
#' based on monthly birth statistics for 1975 to 1991. b) all 617 players'
#' initials and birthdays (excluding non-Australian born players).
#' 
#' @format A list with the following 5 variables. 
#'  \describe{
#' \item{month}{integer month (1 to 12)} \item{players}{number
#' of players born in each month (12 observations)}
#' \item{expected}{expected number of players born in each month (12
#' observations)} \item{initials}{player initials (617 observations)}
#' \item{dob}{date of birth in date format (617 observations;
#' year-month-day format)} }
#' @source Dates of birth from Wikipedia.
#' @examples
#' \donttest{data(AFL)
#' barplot(AFL$players, names.arg=month.abb)
#' }
#' 
 "AFL"
NULL


#' Cardiovascular Deaths in Los Angeles, 1987--2000
#' 
#' Monthly number of deaths from cardiovascular disease in people aged 75 and
#' over in Los Angeles for the years 1987 to 2000.
#' 
#' 
#' @format A data frame with 168 observations on the following 8 variables.
#' \describe{ \item{year}{year of death} \item{month}{month of
#' death} \item{yrmon}{a combination of year and month:
#' \eqn{year+(month-1)/12}} \item{cvd}{monthly number of CVD deaths}
#' \item{tmpd}{mean monthly temperature (degrees Fahrenheit)}
#' \item{pop}{Los Angeles population aged 75+ in the year 2000 (this
#' value is constant as only one year was available, but in general the
#' population will (of course) change over time)}
#' \item{ndaysmonth}{number of days in each month (used as an offset)}
#' \item{adj}{adjusted number of CVD deaths per month using a
#' standardised month length. Monthly number of CVD deaths multiplied by
#' (365.25/12)/ndaysmonth. So the standard month length is 30.4 days.} }
#' @references Samet JM, Dominici F, Zeger SL, Schwartz J, Dockery DW (2000).
#' \emph{The National Morbidity, Mortality, and Air Pollution Study, Part I:
#' Methods and Methodologic Issues}.  Research Report 94, Health Effects
#' Institute, Cambridge MA.
#' @source From the NMMAPS study.
#' @keywords datasets
#' @examples
#' 
#' data(CVD)
#' plot(CVD$yrmon, CVD$cvd, type='o', xlab='Date',
#'      ylab='Number of CVD deaths per month')
#' 
 "CVD"
NULL





#' Daily Cardiovascular Deaths in Los Angeles, 1987--2000
#' 
#' Daily number of deaths from cardiovascular disease in people aged 75 and
#' over in Los Angeles for the years 1987 to 2000.
#' 
#' 
#' 
#' 
#' @format A data frame with 5114 observations on the following 16 variables.
#' \describe{ \item{date}{date of death in date format
#' (year-month-day)} \item{cvd}{daily number of CVD deaths}
#' \item{dow}{day of the week (character)} \item{tmpd}{daily
#' mean temperature (degrees Fahrenheit)} \item{o3mean}{daily mean
#' ozone (parts per billion)} \item{o3tmean}{daily trimmed mean ozone
#' (parts per billion)} \item{Mon}{indicator variable for Monday}
#' \item{Tue}{indicator variable for Tuesday}
#' \item{Wed}{indicator variable for Wednesday}
#' \item{Thu}{indicator variable for Thursday}
#' \item{Fri}{indicator variable for Friday}
#' \item{Sat}{indicator variable for Saturday}
#' \item{month}{month (integer from 1 to 12)}
#' \item{winter}{indicator variable for winter}
#' \item{spring}{indicator variable for spring}
#' \item{summer}{indicator variable for summer}
#' \item{autumn}{indicator variable for autumn} }
#' @references Samet JM, Dominici F, Zeger SL, Schwartz J, Dockery DW (2000).
#' \emph{The National Morbidity, Mortality, and Air Pollution Study, Part I:
#' Methods and Methodologic Issues}. Research Report 94, Health Effects
#' Institute, Cambridge MA.
#' @source From the NMMAPS study.
#' @keywords datasets
#' @examples
#' \donttest{
#' data(CVDdaily)
#' plot(CVDdaily$date, CVDdaily$cvd, type='p', xlab='Date',
#'      ylab='Number of CVD deaths')
#' }
 "CVDdaily"
NULL





#' Exercise Data from Queensland, 2005--2007
#' 
#' Exercise data in longitudinal format from a physical activity intervention
#' study in Logan, Queensland. Some subjects were lost to follow-up, so all
#' three visits are not available for all subjects.
#' 
#' 
#' @format A data frame with 1302 observations on the following 7 variables.
#' \describe{ \item{id}{subject number} \item{visit}{visit
#' number (1, 2 or 3)} \item{date}{date of interview (year-month-day)}
#' \item{year}{year of interview} \item{month}{month of
#' interview} \item{bmi}{body mass index at visit 1 (kg/m\eqn{^2})}
#' \item{walking}{walking time per week (in minutes) at each visit} }
#' @references Eakin E, et al (2009) Telephone counselling for physical
#' activity and diet in type 2 diabetes and hypertension, \emph{Am J of Prev
#' Med}, vol 36, pages 142--9
#' @source From Prof Elizabeth Eakin and colleagues, The University of
#' Queensland, Brisbane.
#' @keywords datasets
#' @examples
#' 
#' data(exercise)
#' boxplot(exercise$walking ~ exercise$month)
#' 
 "exercise"
NULL





#' Indoor Temperature Data
#' 
#' The data are indoor temperatures (in degrees C) for a bedroom and living
#' room in a house in Brisbane, Australia for the dates 10 July 2013 to 3
#' October 2013.  Temperatures were recorded using data loggers which recorded
#' every hour to the nearest 0.5 degrees.
#' 
#' 
#' @name indoor
#' @docType data
#' @format A \code{data.frame} with the following 3 variables.  \describe{
#' \item{datetime}{date and time in \code{POSIXlt} format}
#' \item{living}{the living room temperature}
#' \item{bedroom}{the bedroom temperature} }
#' @source Adrian G Barnett.
#' @keywords datasets
#' @examples
#' 
#' data(indoor)
#' res = cosinor(bedroom~1, date='datetime', type='hourly', data=indoor)
#' summary(res)
#' 
NULL


#' Remove Letters and Characters from a String
#' 
#' Remove letters and characters from a string to leave only numbers. Removes
#' all letters (upper and lower case) and the characters \dQuote{.}, \dQuote{(}
#' and \dQuote{)}. For internal use only.
#' 
#' 
#' @name nochars
#' @param text text string.
#' @author Adrian Barnett \email{a.barnett@@qut.edu.au}
NULL





#' Initial Values for Non-stationary Cosinor
#' 
#' Creates initial values for the non-stationary cosinor decomposition
#' \code{nscosinor}. For internal use only.
#' 
#' 
#' @name nscosinor.initial
#' @param data a data frame.
#' @param response response variable.
#' @param tau vector of smoothing parameters, tau[1] for trend, tau[2] for 1st
#' seasonal parameter, tau[3] for 2nd seasonal parameter, etc. Larger values of
#' tau allow more change between observations and hence a greater potential
#' flexibility in the trend and season.
#' @param lambda distance between observations (lambda=1/12 for monthly data,
#' default).
#' @param n.season number of seasons.
#' @author Adrian Barnett \email{a.barnett@@qut.edu.au}
NULL





#' Random Inverse Gamma Distribution
#' 
#' Internal function to simulate a value from an inverse Gamma distribution,
#' used by \code{nscosinor}. See the MCMCpack library. For internal use only.
#' 
#' 
#' @name rinvgamma
#' @param n number of observations.
#' @param shape Gamma shape parameter.
#' @param scale Gamma scale parameter (default=1).
NULL





#' Schizophrenia Births in Australia, 1930--1971
#' 
#' Monthly number of babies born with schizophrenia in Australia from 1930 to
#' 1971. The national number of births and number of cases are missing for
#' January 1960 are missing.
#' 
#' 
#' 
#' @format A data frame with 504 observations on the following 6 variables.
#' \describe{ \item{year}{year of birth} \item{month}{month of
#' birth} \item{yrmon}{a combination of year and month:
#' \eqn{year+(month-1)/12}} \item{NBirths}{monthly number of births in
#' Australia, used as an offset} \item{SczBroad}{monthly number of
#' schizophrenia births using the broad diagnostic criteria}
#' \item{SOI}{southern oscillation index} }
#' @source From Prof John McGrath and colleagues, The University of Queensland,
#' Brisbane.
#' @keywords datasets
#' @examples
#' 
#' data(schz)
#' plot(schz$yrmon, schz$SczBroad, type='o', xlab='Date',
#'      ylab='Number of schizophrenia births')
#' 
 "schz"
NULL

#' Stillbirths in Queensland, 1998--2000
#' 
#' Monthly number of stillbirths in Australia from 1998 to 2000. It is a rare
#' event; there are 352 stillbirths out of 60,110 births.  To preserve
#' confidentiality the day of birth has been randomly re-ordered.
#' 
#' 
#' 
#' 
#' @format A data frame with 60,110 observations on the following 7 variables.
#' \describe{ \item{dob}{date of birth (year-month-day)}
#' \item{year}{year of birth} \item{month}{month of birth}
#' \item{yrmon}{a combination of year and month:
#' \eqn{year+(month-1)/12}} \item{seifa}{SEIFA score, an area level
#' measure of socioeconomic status in quintiles}
#' \item{gestation}{gestation in weeks}
#' \item{stillborn}{stillborn (yes/no); 1=Yes, 0=No} }
#' @source From Queensland Health.
#' @examples
#' 
#' data(stillbirth)
#' table(stillbirth$month, stillbirth$stillborn)
#' 
"stillbirth"
NULL
