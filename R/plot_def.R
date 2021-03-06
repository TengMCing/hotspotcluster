#' Default method of plotting the clustering results
#'
#' This function plots the clustering result spatially as a scatter plot.
#'
#' @param result `spotoroo` object. A result of a call to [hotspot_cluster()].
#' @param cluster Character/Integer. If "all", plot all clusters. If a integer
#'                vector is given, plot corresponding clusters.
#' @param hotspot Logical. If `TRUE`, plot the hot spots.
#' @param noise Logical. If `TRUE`, plot the noise points.
#' @param ignition Logical. If `TRUE`, plot the ignition points.
#' @param from **OPTIONAL**. Date/Datetime/Numeric. Start time. The data type
#'                           needs to be the same as the provided
#'                           observed time.
#' @param to **OPTIONAL**. Date/Datetime/Numeric. End time. The data type
#'                         needs to be the same as the provided observed time.
#' @param bg **OPTIONAL**. `ggplot` object. If specified, plot onto
#'                         this object.
#' @return A `ggplot` object. The plot of the clustering results.
#' @examples
#' \donttest{
#'
#'   # Time consuming functions (>5 seconds)
#'
#'
#'   # Get clustering results
#'   result <- hotspot_cluster(hotspots,
#'                           lon = "lon",
#'                           lat = "lat",
#'                           obsTime = "obsTime",
#'                           activeTime = 24,
#'                           adjDist = 3000,
#'                           minPts = 4,
#'                           minTime = 3,
#'                           ignitionCenter = "mean",
#'                           timeUnit = "h",
#'                           timeStep = 1)
#'
#'   # Plot a subset of clusters
#'   plot_def(result, cluster = 1:3)
#'
#'   # Plot all clusters
#'   plot_def(result, cluster = "all")
#' }
#'
#'
#' @export
plot_def <- function(result,
                     cluster = "all",
                     hotspot = TRUE,
                     noise = FALSE,
                     ignition = TRUE,
                     from = NULL,
                     to = NULL,
                     bg = NULL) {

  if (!"spotoroo" %in% class(result)) {
    stop('Needs a "spotoroo" object as input.')
  }

  # define ggplot function
  aes <- ggplot2::aes
  geom_point <- ggplot2::geom_point
  labs <- ggplot2::labs
  theme <- ggplot2::theme
  theme_bw <- ggplot2::theme_bw
  ggplot <- ggplot2::ggplot
  element_blank <- ggplot2::element_blank
  unit <- ggplot2::unit
  scale_color_brewer <- ggplot2::scale_color_brewer

  # define dplyr function
  filter <- dplyr::filter

  # pass CMD CHECK variables
  lon <- lat <- membership <- NULL



  # safety check
  check_type_bundle("logical", hotspot, ignition, noise)
  is_length_one_bundle(hotspot, ignition, noise)

  # extract corresponding clusters
  if (!identical("all", cluster)){
    check_type("numeric", cluster)

    if (length(cluster) == 0) stop("Please provide valid membership labels.")

    indexes <- result$ignition$membership %in% cluster
    result$ignition <- result$ignition[indexes, ]

    indexes <- result$hotspots$membership %in% c(cluster, -1)
    result$hotspots <- result$hotspots[indexes, ]
  }

  # from date
  if (!is.null(from)) {
    is_length_one(from)
    indexes <- result$ignition$obsTime >= from
    result$ignition <- result$ignition[indexes, ]

    indexes <- result$hotspots$obsTime >= from
    result$hotspots <- result$hotspots[indexes, ]

    if (nrow(result$hotspots) == 0) {
      stop(paste("No hot spots/noise observed later than", from))
    }
  }

  # to date
  if (!is.null(to)) {
    is_length_one(to)
    indexes <- result$ignition$obsTime <= to
    result$ignition <- result$ignition[indexes, ]

    indexes <- result$hotspots$obsTime <= to
    result$hotspots <- result$hotspots[indexes, ]

    if (nrow(result$hotspots) == 0) {
      stop(paste("No hot spots/noise observed ealier than", from))
    }
  }


  # whether or not to draw on an existing plot
  if (ggplot2::is.ggplot(bg)) {
    p <- bg
  } else {
    p <- ggplot() +
      theme_bw(base_size = 9) +
      theme(axis.line = element_blank(),
            axis.text = element_blank(),
            axis.ticks = element_blank(),
            axis.title = element_blank(),
            panel.background = element_blank(),
            panel.border = element_blank(),
            panel.grid = element_blank(),
            panel.spacing = unit(0, "lines"),
            plot.background = element_blank(),
            legend.justification = c(0, 0),
            legend.position = c(0, 0))
  }

  if (length(unique(result$hotspots$membership)) <= 9) {

    # draw hot spots
    if (hotspot) {

      p <- p + geom_point(data = filter(result$hotspots,
                                        !noise),
                          aes(lon,
                              lat,
                              col = as.character(membership)),
                          alpha = 0.4,
                          size = 1.5)

    }

    # draw noise
    if (noise) {

      p <- p + geom_point(data = filter(result$hotspots,
                                        noise),
                          aes(lon,
                              lat),
                          col = "black",
                          alpha = 0.2,
                          size = 1.5)

    }

    # draw ignitions
    if (ignition & length(unique(result$hotspots$membership)) > 1) {
      p <- p +
        geom_point(data = result$ignition,
                            aes(lon,
                                lat),
                   col = "black",
                   size = 1.5)
    }

    # define color
    p <- p + scale_color_brewer(palette = "Set1") +
      theme(legend.position = "none") +
      labs(col = "")

  } else {
    # too many clusters
    # draw hot spots
    if (hotspot) {

      p <- p + geom_point(data = filter(result$hotspots,
                                        !noise),
                          aes(lon,
                              lat),
                          col = "black",
                          alpha = 0.4,
                          size = 1.5)

    }

    # draw noises
    if (noise) {

      p <- p + geom_point(data = filter(result$hotspots,
                                        noise),
                          aes(lon,
                              lat),
                          col = "blue",
                          alpha = 0.2,
                          size = 1.5)

    }

    # draw ignitions
    if (ignition) {
      p <- p +
        geom_point(data = result$ignition,
                   aes(lon,
                       lat),
                   col = "red",
                   size = 1.5)
    }

    # define color
    p <- p +
      theme(legend.position = "none") +
      labs(col = "")
  }




  # add title
  title <- paste("Fires Selected:", nrow(result$ignition), "\n")
  left <- min(result$hotspots$obsTime)
  right <- max(result$hotspots$obsTime)

  if (!is.null(from)) left <- from
  title <- paste0(title, "From: ", left, "\n")

  if (!is.null(to)) right <- to
  title <- paste0(title, "To:      ", right)

  title2 <- "Overview of Fires"
  if (ignition) title2 <- paste0(title2, " and Ignition Locations")

  p <- p + labs(title = title2,
                         subtitle = title)


  # return the plot
  return(p)


}
