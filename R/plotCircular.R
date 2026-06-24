#' Circular Plot Using Segments
#'
#' A circular plot useful for visualising monthly or weekly data.
#'
#' A circular plot can be useful for spotting the shape of the seasonal pattern.
#' This function can be used to plot any circular patterns, e.g., weekly or
#' monthly. The method assumes that monthly data starts in January and weekly
#' data starts on Monday.
#'
#' The plots are also called rose diagrams, with the segments then called
#' "petals".
#'
#' @param data Dataset to use for plot as a data.frame.
#' @param time time variable in the data, typically month or day of the week.
#' @param type type of data to plot, either "monthly" or "weekly", default:monthly.
#' @param areas variable(s) to plot, the area of the segments (or petals) are
#' proportional to this variable.
#' @param clockwise plot in a clockwise direction, default:TRUE.
#' @param spoke.col spoke colour, default:black.
#' @param main title for plot, default:blank
#' @param xlab x axis label, default:blank
#' @param ylab y axis label, default:blank
#' @param pieces.col colours for circular pieces, default:"white" for
#' 1st and "grey" for second variable. Note that a list of available
#' colours may be found with [colours()].
#' @param legend Where to plot legend, only relevant if two variables. Default
#'   is "bottom". See [ggplot2::guide_legend()] for details, specifically
#'   "position". Set to "none" for no legend. Options are: "top", "right",
#'   "bottom", "left", or "inside".
#' @returns a circular plot in ggplot2 format, also known as "rosebud", and
#'   "nightingale" plots.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @references Fisher, N.I. (1993) *Statistical Analysis of Circular Data*.
#'   Cambridge University Press, Cambridge.
#' @examples
#' ## Monthly numbers of AFL players
#' AFL.frame = data.frame(AFL[c("month", "players", "expected")])
#'aplot1 = plotCircular(
#'  data = AFL.frame,
#'  time = "month",
#'  areas = "players",
#'  legend = "none")
#' ## The observed and expected number of players per month
#' aplot = plotCircular(
#' data = AFL.frame,
#' time = "month",
#' areas = c("players", "expected"))
#' ## Creating weekly data as an example
#'weekfreq <- data.frame(day = 1:7, counts = rpois(n = 7, lambda = 5))
#'wplot = plotCircular(
#'  data = weekfreq,
#'  time = "day",
#'  type = "weekly",
#'  areas = "counts",
#'  legend = "none")
#'
#' @export
plotCircular = function(
  data = NULL,
  type = "monthly",
  time = NULL,
  areas = NULL,
  main = NULL,
  xlab = NULL,
  ylab = NULL,
  clockwise = TRUE,
  legend = "bottom",
  spoke.col = NULL,
  pieces.col = NULL
) {
  # colours
  pieces.col <- pieces.col %||% c("white", "grey")
  spoke.col <- spoke.col %||% "black"

  legend <- rlang::arg_match(
    legend,
    values = c("top", "right", "bottom", "left", "inside", "none")
  )
  # rename time variable
  index <- names(data) == time
  names(data)[index] = "id"

  # convert to long for multiple areas
  long <- tidyr::pivot_longer(
    data,
    cols = tidyr::all_of(areas),
    names_to = "group"
  ) |>
    dplyr::mutate(
      id = id - 1, # make January zero
      group = factor(group)
    ) #

  # circular plot
  circle <- ggplot2::ggplot(
    data = long,
    ggplot2::aes(x = id, y = value, fill = group)
  ) +
    ggplot2::geom_bar(
      width = 1,
      stat = "identity",
      position = "dodge",
      col = spoke.col
    ) +
    ggplot2::scale_fill_manual(values = pieces.col) +
    ggplot2::labs(
      title = main,
      x = xlab,
      y = ylab
    ) +
    ggplot2::theme_bw() +
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank())

  if (type == "monthly") {
    circle <- circle +
      ggplot2::scale_x_continuous(breaks = 0:11, labels = month.abb) +
      ggplot2::coord_polar(theta = "x", start = -2 * pi / 24) # offset
  }

  if (type == "weekly") {
    days <- c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
    circle <- circle +
      ggplot2::scale_x_continuous(breaks = 0:6, labels = days) +
      ggplot2::coord_polar(theta = "x", start = -2 * pi / 14) # offset
  }

  # reverse direction option
  if (!clockwise) {
    circle <- circle + ggplot2::coord_polar(theta = "x", direction = -1)
  }

  circle + ggplot2::theme(legend.position = legend)
}
