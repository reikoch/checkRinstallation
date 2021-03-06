% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gettars.R
\name{gettars}
\alias{gettars}
\title{retrieve source tarballs of installed packages}
\usage{
gettars(pkgs = NULL, srcDB = tempfile("pkgs_"))
}
\arguments{
\item{pkgs}{matrix of package names and versions}

\item{srcDB}{directory where all source tarballs are collected}
}
\value{
vector of
}
\description{
retrieve source tarballs of installed packages
}
\examples{
  tarbs <- gettars()
}
