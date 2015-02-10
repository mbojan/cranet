#' Snapshot of CRAN packages
#'
#' Snapshot of CRAN packages made on 2015-02-10
#'
#' @format The network object is of class \code{igraph}. It is a directed
#' network which contains 2277 packages (vertices) and 6903 inter-package
#' relations (edges). The network, together with vertex and edge attributes is
#' build from the matrix as returned by \code{\link{available.packages}}, which
#' in turn is based on package DESCRIPTION files.
#' 
#' There are following vertex attributes, usually based on corresponding
#' entries in the package DESCRIPTION file:
#' \describe{
#' \item{name}{character, package name}
#' \item{Version}{character, package version number}
#' \item{Priority}{character, package priority, one of "contrib", "optional", or "recommended"}
#' \item{Bundle}{name of the bundle the package is part of, now empty as bundles are no longer used (?)}
#' \item{License}{character, name #' of the license the package is released under}
#' \item{File}{character, not #' sure (?)}
#' \item{Repository}{character, name of the repository in which the package is available}
#' }
#' 
#' The network is a multi-graph, i.e. there may be multiple edges between a
#' given pair of nodes. This corresponds to the fact, that package X may, for
#' example, both depend and import package Y.  To disentangle the types of
#' relations one can use edge attributes.  There are following edge attributes
#' in this object:
#' \describe{
#' \item{type}{character, type of inter-package relation, one of "Depends", "Enhances", "Imports", "Suggests"}
#' }
#'
#' @source Fetched from \url{http://cran.at.r-project.org} on February 18, 2010.
#' @keywords datasets
#' @docType data
#' @name crannet
#' @example examples/crannet.R
NULL
