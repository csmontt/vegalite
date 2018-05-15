#' Create and (optionally) visualize a Vega-Lite spec
#'
#' @param description a single element character vector that provides a description of
#'        the plot/spec.
#' @param renderer the renderer to use for the view. One of \code{canvas} or
#'        \code{svg} (the default)
#' @param export if \code{TRUE} the \emph{"Export as..."} link will
#'        be displayed with the chart.(Default: \code{FALSE}.)
#' @param source if \code{TRUE} the \emph{"View Source"} link will be displayed
#'        with the chart. (Default: \code{FALSE}.)
#' @param editor if \code{TRUE} the \emph{"Open in editor"} link will be
#'        displayed with the cahrt. (Default: \code{FALSE}.)
#' @param background plot background color. If \code{NULL} the background will be transparent.
#' @param viewport_width,viewport_height height and width of the overall
#'        visualziation viewport. This is the overall area reserved for the
#'        plot. You can leave these \code{NULL} and use \code{\link{view_size}}
#'        instead but you will want to configure both when making faceted plots.
#' @param time_format the default time format pattern for text and labels of
#'        axes and legends (in the form of \href{https://github.com/mbostock/d3/wiki/Time-Formatting}{D3 time format pattern}).
#'        Default: \code{\%Y-\%m-\%d}
#' @param number_format the default number format pattern for text and labels of
#'        axes and legends (in the form of
#'        \href{https://github.com/mbostock/d3/wiki/Formatting}{D3 number format pattern}).
#'        Default: \code{s}
#' @param autosize sizing setting (\href{https://vega.github.io/vega-lite/docs/size.html#autosize}{autosize})
#' @param padding single number to be applied to all sides, or list
#' specifying padding on each side, e.g list("top" = 5, "bottom" = 3,
#' "left" = 2, "right" = 2). Unit is pixels.
#' @param ... additional arguments
#' @references \href{http://vega.github.io/vega-lite/docs/config.html#top-level-config}{Vega-Lite top-level config}
#' @importFrom jsonlite fromJSON toJSON unbox
#' @import htmlwidgets stats
#' @importFrom htmltools tag div span
#' @importFrom utils read.csv
#' @name vegalite
#' @rdname vegalite
#' @export
#' @examples
#' dat <- jsonlite::fromJSON('[
#'     {"a": "A","b": 28}, {"a": "B","b": 55}, {"a": "C","b": 43},
#'     {"a": "D","b": 91}, {"a": "E","b": 81}, {"a": "F","b": 53},
#'     {"a": "G","b": 19}, {"a": "H","b": 87}, {"a": "I","b": 52}
#'   ]')
#'
#' vegalite() %>%
#'   add_data(dat) %>%
#'   encode_x("a", "ordinal") %>%
#'   encode_y("b", "quantitative") %>%
#'   mark_bar()
vegalite <- function(description="", renderer=c("svg", "canvas"),
                     export=FALSE, source=FALSE, editor=FALSE,
                     viewport_width=NULL, viewport_height=NULL,
                     padding = NULL, autosize = NULL,
                     background=NULL, time_format=NULL, number_format=NULL,
                     ...) {

  # forward options using x
  params <- list(
    description = description,
    data = list(),
    mark = list(),
    encoding = list(),
    transform = list(),
    embed = list("mode"="vega-lite",
                 renderer=renderer[1],
                 actions=list(export=export,
                              source=source,
                              editor=editor))
  )

  if (!is.null(padding)){
    params$config$padding <- padding
  }
  if (!is.null(autosize)){
    params$config$autosize <- autosize
  }

  if (!is.null(background)) { params$config$background <- background }
  if (!is.null(time_format)) { params$config$timeFormat <- time_format }
  if (!is.null(number_format)) { params$config$numberFormat <- number_format }

  if (!is.null(viewport_width) || !is.null(viewport_height)){
    size_policy <- htmlwidgets::sizingPolicy(defaultWidth = viewport_width,
                                             defaultHeight = viewport_height,
                                             knitr.figure = FALSE)
  } else{
    size_policy <- htmlwidgets::sizingPolicy()
  }

  # create widget
  htmlwidgets::createWidget(
    name = 'vegalite',
    x = params,
    sizingPolicy = size_policy,
    package = 'vegalite'
  )

}
