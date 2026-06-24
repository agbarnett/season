# plotCircular.R
# circular plot
## Changes
## 7/2/10: incorporated titles/axes labels/colour setting/auto legend
## June 2026: switch to ggplot

#" Circular Plot Using Segments
#"
#" A circular plot useful for visualising monthly or weekly data.
#"
#" A circular plot can be useful for spotting the shape of the seasonal
#" pattern. This function can be used to plot any circular patterns, e.g.,
#" weekly or monthly. The method assumes that monthly data starts in January and weekly data starts on Monday.
#"
#" The plots are also called rose diagrams, with the segments then called
#" "petals".
#"
#" @param data Dataset to use for plot as a data.frame.
#" @param time time variable in the data, typically month or day of the week.
#" @param type type of data to plot, either "monthly" or "weekly", default:monthly.
#" @param area variable(s) to plot, the area of the segments (or petals) are
#" proportional to this variable.
#" @param clockwise plot in a clockwise direction, default:TRUE.
#" @param spoke.col spoke colour, default:black.
#" @param main title for plot, default:blank
#" @param xlab x axis label, default:blank
#" @param ylab y axis label, default:blank
#" @param pieces.col colours for circular pieces, default:"white" for
#" 1st and "grey" for second variable. Note that a list of available
#" colours may be found with [colours()].
#" @param legend whether to include legend or not, default:TRUE when plotting
#" two variables
#" @returns a circular plot in ggplot2 format, also known as "rosebud", and "nightingale" plots.
#" @author Adrian Barnett \email{a.barnett@qut.edu.au}
#" @references Fisher, N.I. (1993) *Statistical Analysis of Circular
#" Data*. Cambridge University Press, Cambridge.
#" @examples
#" ## Monthly numbers of AFL players
#" AFL.frame = data.frame(AFL[c("month", "players", "expected")])
#"aplot1 = plotCircular(
#"  data = AFL.frame,
#"  time = "month",
#"  areas = "players",
#"  legend = FALSE)
#" ## The observed and expected number of players per month
#" aplot = plotCircular(
#" data = AFL.frame,
#" time = "month",
#" areas = c("players", "expected"))
#" ## Creating weekly data as an example
#"weekfreq <- data.frame(day = 1:7, counts = rpois(n = 7, lambda = 5))
#"wplot = plotCircular(
#"  data = weekfreq,
#"  time = "day",
#"  type = "weekly",
#"  areas = "counts",
#"  legend = FALSE)
#"
#" @export
plotCircular = function(
  data = NULL,
  type = "monthly",
  time = NULL,
  areas = NULL,
  main = NULL,
  xlab = NULL,
  ylab = NULL,
  clockwise = TRUE,
  legend = TRUE,
  spoke.col = NULL,
  pieces.col = NULL
) {
  # colours
  pieces.col <- pieces.col %||% c("white", "grey")
  spoke.col <- spoke.col %||% "black"

  # rename time variable
  index <- names(data) == time
  names(data)[index] = "id"

  # convert to long for multiple areas
  long <- pivot_longer(data, cols = all_of(areas), names_to = "group") %>%
    mutate(
      id = id - 1, # make January zero
      group = factor(group)
    ) #

  # circular plot
  circle <- ggplot(data = long, aes(x = id, y = value, fill = group)) +
    geom_bar(
      width = 1,
      stat = "identity",
      position = "dodge",
      col = spoke.col
    ) +
    scale_fill_manual(values = pieces.col) +
    ggtitle(main) +
    xlab(xlab) +
    ylab(ylab) +
    theme_bw() +
    theme(panel.grid.minor = element_blank())
  #  geom_text(data = daysoftheweek, aes(x=Var1, label = day))

  # if monthly
  if (type == "monthly") {
    circle <- circle +
      scale_x_continuous(breaks = 0:11, labels = month.abb) +
      coord_polar(theta = "x", start = -2 * pi / 24) # offset
  }

  # if weekly
  if (type == "weekly") {
    days <- c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
    circle <- circle +
      scale_x_continuous(breaks = 0:6, labels = days) +
      coord_polar(theta = "x", start = -2 * pi / 14) # offset
  }

  # reverse direction option
  if (clockwise == FALSE) {
    circle <- circle + coord_polar(theta = "x", direction = -1)
  }
  # legend
  if (legend == FALSE) {
    circle <- circle + theme(legend.position = "none")
  }
  return(circle)
}
