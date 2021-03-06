% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hotspot_cluster.R
\name{print.spotoroo}
\alias{print.spotoroo}
\title{Printing spatiotemporal clustering result}
\usage{
\method{print}{spotoroo}(x, ...)
}
\arguments{
\item{x}{\code{spotoroo} object.
A result of a call to \code{\link[=hotspot_cluster]{hotspot_cluster()}}.}

\item{...}{Additional arguments will be ignored.}
}
\value{
No return value, called for side effects
}
\description{
\code{print.spotoroo()} is the \code{print} method of the class \code{spotoroo}.
}
\examples{
\donttest{

  # Time consuming functions (>5 seconds)


  # Get clustering results
  result <- hotspot_cluster(hotspots,
                           lon = "lon",
                           lat = "lat",
                           obsTime = "obsTime",
                           activeTime = 24,
                           adjDist = 3000,
                           minPts = 4,
                           minTime = 3,
                           ignitionCenter = "mean",
                           timeUnit = "h",
                           timeStep = 1)


  # print the results
  print(result)
}



}
