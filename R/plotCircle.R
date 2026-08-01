# Function to plot monthly rates using a grey shaded circular "country"
# Assumes estimates are in numerical order, 1=Jan, 2=Feb, etc
# April 2009

#' Circular Plot
#'
#' Circular plot of a monthly variable. This circular plot can be useful for
#' estimates of an annual seasonal pattern. Darker shades of grey correspond to
#' larger numbers.
#'
#' `r lifecycle::badge("deprecated")` Soft-deprecated in favour of
#' [plot_circle()], which returns a ggplot object you can extend with `+`.
#' The base R plot below still works.
#'
#' @param months monthly variable to plot, the shades of grey of the 12
#' segments are proportional to this variable. The first result is assumed to
#' be January, the second February, and so on.
#' @param dp decimal places for statistics, default=1.
#' @param \dots additional arguments to [plot()]
#' @returns a donut-type plot of a monthly variable
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [plot_circle()]
#' @examples
#' \donttest{
#' # Recommended:
#' plot_circle(months = seq(1, 12, 1), dp = 0)
#' # Still works, but deprecated:
#' plotCircle(months = seq(1, 12, 1), dp = 0)
#' }
#'
#' @export
plotCircle <- function(months, dp = 1, ...) {
  lifecycle::deprecate_warn(
    when = "0.3.17",
    what = "plotCircle()",
    with = "plot_circle()"
  )
  if (length(months) != 12) {
    cli::cli_abort(
      c(
        "{.arg months} must have length {.val 12}.",
        "i" = "Got length {length(months)}."
      )
    )
  }
  op <- par(no.readonly = TRUE) # the whole list of settable par's.
  # create grey scale, standardise results to [0.2,1]
  # add small number to prevent very dark colours
  stan0to1 <- (months - min(months)) / (max(months) - min(months))
  stan1to0 <- abs(stan0to1 - 1) # reverse so that darker shades are higher
  stan <- (stan1to0 * 0.7) + 0.3 # [0.3,1]
  dens <- gray(stan)
  plot(
    0,
    0,
    bty = 'n',
    xlab = '',
    main = '',
    ylab = '',
    type = 'p',
    xlim = c(-1, 1),
    ylim = c(-1, 1),
    col = 'white',
    yaxt = 'n',
    xaxt = 'n',
    ...
  ) # blank plot

  # important constants
  bins <- 12
  clockstart <- pi / 2 # default clock start at 12 o'clock
  half <- 2 * pi / (bins * 2) # for moving text half-way round
  start <- pi / 4
  scale <- 1
  detail <- 50
  # Polygons for each month
  for (m in 1:12) {
    poly <- matrix(data = NA, nrow = ((detail + 1) * 2) + 3, ncol = 2)
    index <- 0
    index <- index + 1
    mstart <- (2 * pi * m / bins) + start
    poly[index, 1] <- -1 * scale * cos(mstart)
    poly[index, 2] <- 1 * scale * sin(mstart)
    index <- index + 1
    poly[index, 1] <- -0.7 * scale * cos(mstart)
    poly[index, 2] <- 0.7 * scale * sin(mstart)
    for (i in 0:detail) {
      index <- index + 1
      x <- (mstart + (2 * pi * i / (detail * bins)))
      poly[index, 1] <- -0.7 * scale * cos(x)
      poly[index, 2] <- 0.7 * scale * sin(x)
    }
    index <- index + 1
    poly[index, 1] <- -1 * scale * cos(x)
    poly[index, 2] <- 1 * scale * sin(x)
    for (i in detail:0) {
      index <- index + 1
      x <- (mstart + (2 * pi * i / (detail * bins)))
      poly[index, 1] <- -1 * scale * cos(x)
      poly[index, 2] <- 1 * scale * sin(x)
    }
    polygon(poly, col = dens[m], border = 'black')
  }
  # Month labels
  for (j in 1:bins) {
    x <- -0.85 * cos((2 * pi * j / bins) + start + half)
    y <- 0.85 * sin((2 * pi * j / bins) + start + half)
    label <- month.abb[j]
    text(x, y, label)
  }
  ## Add a colour bar to the centre of the plot
  # total bar height = 1
  bartoplot <- seq(1, 0.3, -0.1)
  dens <- gray(bartoplot)
  width <- 0.1
  height <- 0.05
  nbars <- length(bartoplot)
  # unstandardise results for text label
  unstan <- (((bartoplot - 0.3) / 0.7) * (max(months) - min(months))) +
    min(months)
  for (i in 1:nbars) {
    x <- c(-width, width, width, -width, -width) - width
    yref <- ((i - 1) - (nbars / 2)) / (nbars + 2)
    y <- c(
      yref - height,
      yref - height,
      yref + height,
      yref + height,
      yref - height
    )
    polygon(x, y, col = dens[i], border = NA, lwd = 1)
    # text label
    # convert to character
    clabel2 <- formatC(unstan[nbars - i + 1], format = "f", digits = dp)
    text(2 * width, yref, clabel2)
  }
  par(op) # restore graphic settings
}

#' Circular plot of monthly values (ggplot2)
#'
#'
#' Circular plot of a monthly variable. This circular plot can be useful for
#' estimates of an annual seasonal pattern. Darker shades of grey correspond to
#' larger numbers.
#' Pie chart where each segment is one month and the fill is shaded
#' to indicate the value (darker = larger). The first value is assumed to
#' be January.
#' This circular plot can be useful for
#' estimates of an annual seasonal pattern. Darker shades of grey correspond to
#' larger numbers.
#'
#' @param months a length-12 numeric vector of monthly values, January first.
#' @param dp decimal places for the per-month label, default 1.
#' @returns a ggplot object.
#' @author Nicholas Tierney
#' @seealso [plotCircle()] (deprecated base R version)
#' @export
#' @examples
#' \donttest{
#' plot_circle(months = seq(1, 12, 1), dp = 0)
#' plot_circle(months = c(1, 3, 5, 7, 9, 11, 12, 10, 8, 6, 4, 2)) +
#'   ggplot2::labs(title = "Example monthly pattern")
#' }
plot_circle <- function(months, dp = 1) {
  if (length(months) != 12) {
    cli::cli_abort(
      c(
        "{.arg months} must have length {.val 12}.",
        "i" = "Got length {length(months)}."
      )
    )
  }
  month_num <- value <- label <- NULL
  dat <- data.frame(
    month_num = factor(month.abb, levels = month.abb),
    value = months,
    label = formatC(months, format = "f", digits = dp)
  )
  ggplot2::ggplot(
    data = dat,
    ggplot2::aes(
      x = month_num,
      y = 1,
      fill = value
    )
  ) +
    ggplot2::geom_col(width = 1, colour = "black") +
    ggplot2::coord_polar(start = 0) +
    ggplot2::scale_y_continuous(limits = c(-1, 1)) + # <-- donut hole
    ggplot2::scale_fill_gradient(low = "white", high = "grey30") +
    ggplot2::geom_text(ggplot2::aes(y = 0.5, label = month_num), size = 3) +
    ggplot2::theme_void() +
    ggplot2::labs(fill = NULL)
}
