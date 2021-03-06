% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dist_point_to_vector.R
\name{dist_point_to_vector}
\alias{dist_point_to_vector}
\title{Calculation of the geodesic of a point to multiple points}
\usage{
dist_point_to_vector(plon, plat, vlon, vlat)
}
\arguments{
\item{plon}{Numeric. The longitude of a point.}

\item{plat}{Numeric. The latitude of a point.}

\item{vlon}{Numeric. A vector of longitude values.}

\item{vlat}{Numeric. A vector of latitude values.}
}
\value{
Numeric. The geodesic of a point to multiple points in meters.
}
\description{
This function calculates the geodesic of a point to multiple
points given the coordinate information. It is a wrapper of
\code{\link[geodist:geodist_vec]{geodist::geodist_vec()}}.
}
\examples{

# Define vlon and vlat
vlon <- c(141.12, 141.13)
vlat <- c(-37.1, -37.0)

# Calculate the geodesic
dist_point_to_vector(141.12, -37.1, vlon, vlat)

}
