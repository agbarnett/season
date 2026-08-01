# plotMonth.R
# function to plot monthly results by month
# assumes the data are in order
# assumes there are numeric variables for month and year

#' Plot Results by Month
#'
#' Plots results by month. Assumes the data frame contains variables called
#'   year and month.
#'
#' `r lifecycle::badge("deprecated")` Soft-deprecated in favour of
#' [plot_month()], which returns a ggplot object you can extend with `+`.
#' The existing function still works.
#'
#' @param data a data frame.
#' @param resp response variable to plot.
#' @param panels number of panels to use in plot (1 or 12). 12 gives one panel
#' per month, 1 plots all the months in the same panel.
#' @param \dots further arguments passed to or from other methods.
#' @returns Facetted lineplot of response over time, one facet per month.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [plot_month()]
#' @references Barnett, A.G., Dobson, A.J. (2010) *Analysing Seasonal
#' Health Data*. Springer. \doi{doi:10.1007/978-3-642-10748-1}
#' @examples
#' \donttest{
#'   # Recommended:
#'   plot_month(data = CVD, resp = "cvd", panels = 12)
#'   # Still works, but deprecated:
#'   plotMonth(data = CVD, resp = "cvd", panels = 12)
#' }
#'
#' @export
plotMonth <- function(data, resp, panels = 12, ...) {
  lifecycle::deprecate_warn(
    when = "0.3.17",
    what = "plotMonth()",
    with = "plot_month()"
  )
  # Setting some variables to NULL first (for R CMD check)
  year <- yaxis <- Month <- NULL

  if (!panels %in% c(1, 12)) {
    cli::cli_abort(
      "{.arg panels} must be {.val 1} or {.val 12}, not {.val {panels}}."
    )
  }
  data$yaxis <- subset(data, select = resp)[, 1]

  # 12 panels
  # to change facet_wrap labels
  data$Month <- factor(data$month, levels = 1:12, labels = month.abb)
  if (panels == 12) {
    gplot <- ggplot2::ggplot(
      data,
      ggplot2::aes(
        x = year,
        y = yaxis
      )
    ) +
      ggplot2::geom_line() +
      ggplot2::theme_bw() +
      ggplot2::xlab(' ') +
      ggplot2::ylab(resp) +
      ggplot2::facet_wrap(~Month)
    print(gplot)
  }

  # 1 panels
  if (panels == 1) {
    gplot <- ggplot2::ggplot(
      data,
      ggplot2::aes(
        year,
        yaxis,
        color = Month
      )
    ) +
      ggplot2::geom_line() +
      ggplot2::theme_bw() +
      ggplot2::xlab(' ') +
      ggplot2::ylab(resp)
    print(gplot)
  }
}

#' Plot a response by month (ggplot2)
#'
#' Plots results by month. Assumes the data frame contains variables called
#'   year and month. Faceted or coloured line plot of a monthly response over
#'   time. Assumes the data frame contains `year` and `month` columns.
#'
#' @param data a data frame containing `year`, `month`, and the response.
#' @param resp character; name of the response variable.
#' @param panels 1 (overlay) or 12 (one facet per month). Default 12.
#' @returns a ggplot object.
#' @seealso [plotMonth()] (deprecated wrapper)
#' @export
#' @examples
#' \donttest{
#' plot_month(data = CVD, resp = "cvd", panels = 12)
#' plot_month(data = CVD, resp = "cvd", panels = 1) +
#'   ggplot2::theme_minimal()
#' }
plot_month <- function(data, resp, panels = 12) {
  month <- NULL
  if (!panels %in% c(1, 12)) {
    cli::cli_abort(
      "{.arg panels} must be {.val 1} or {.val 12}, not {.val {panels}}."
    )
  }
  year <- yaxis <- Month <- NULL
  data <- transform(
    data,
    yaxis = data[[resp]],
    Month = factor(month, levels = 1:12, labels = month.abb)
  )

  if (panels == 12) {
    ggplot2::ggplot(
      data = data,
      ggplot2::aes(
        x = year,
        y = yaxis
      )
    ) +
      ggplot2::geom_line() +
      ggplot2::theme_bw() +
      ggplot2::labs(
        x = NULL,
        y = resp
      ) +
      ggplot2::facet_wrap(~Month)
  } else {
    ggplot2::ggplot(
      data = data,
      ggplot2::aes(
        x = year,
        y = yaxis,
        color = Month
      )
    ) +
      ggplot2::geom_line() +
      ggplot2::theme_bw() +
      ggplot2::labs(
        x = NULL,
        y = resp
      )
  }
}
