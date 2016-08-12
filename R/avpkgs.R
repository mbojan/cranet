#' Matrix of Available Packages
#'
#' Snapshot of packages avaiable on CRAN on 2016-08-12
#'
#' @format 
#' A \Sexpr{paste(dim(pkgnet::avpkgs), collapse="x")} matrix 
#' returned by \code{\link{available.packages}} with the following column names:
#' \Sexpr{paste( dQuote(colnames(pkgnet::avpkgs)), collapse=", ")}.
#' 
#' @source Fetched from \url{http://cloud.r-project.org} on August 12, 2016.
#' 
#' @seealso
#' \code{\link{available.packages}}, \code{\link{crannet}} which is an igraph object
#' built from such matrix.
#' 
#' @keywords datasets
#' @name avpkgs
#' @docType data
NULL
