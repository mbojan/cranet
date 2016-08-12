#' Build a network based on package availability matrix
#' 
#' Given the matrix as returned by \code{available.packages} construct a graph,
#' of class \code{igraph} of inter-package relations.
#' 
#' The resulting graph (object of class \code{igraph}) is a multigraph: there
#' can be multiple relationships between any given pair of vertices. Different
#' types of relations can be disentagled using edge attribute called
#' \code{type}. It stores the type of relation as provided with \code{enams}
#' argument.
#' 
#' @param a matrix, as returned by \code{available.packages}
#' @param enams character, names of columns of \code{a} that are to be used as
#' edge attributes
#' @param vnams character, names of columns of \code{a} that are to be used as
#' vertex attributes
#' @return Object of class \code{igraph}.
#' @seealso \code{\link{available.packages}}, \code{\link{graph.data.frame}}
#' @examples
#' \dontrun{
#' a <- available.packages(contrib.url("http://cran.r-project.org", "source"))
#' g <- pkgnet(a)
#' summary(g)
#' }
#' 
#' 
#' @export 
pkgnet <- function(object, ...) UseMethod("pkgnet")


#' @method pkgnet default
#' @rdname pkgnet
#' @export
pkgnet.default <- function(object, ...) {
  stop("don't know how to handle object of class ", oldClass(object))
}


#' @method pkgnet character
#' @rdname pkgnet
#' @export
pkgnet.character <- function(object, ap_args=NULL, ...) {
  u <- switch(object,
              cran = "https://cloud.r-project.org",
              bioc = "https://bioconductor.org/packages/3.0/bioc",
              object)
  a <- do.call("available.packages", c(list(repos=u), ap_args))
  pkgnet.matrix(a, ...)
}

#' @method pkgnet matrix
#' @rdname pkgnet
#' @export
pkgnet.matrix <- function(object, 
                   enams=c("Depends", "Suggests", "Imports", "Enhances", "LinkingTo"),
                   vnams=c("Version", "Priority", "License", "License_is_FOSS", 
                           "License_restricts_use", "OS_type", "Archs", "MD5sum", "NeedsCompilation",
                           "File", "Repository")
) {
  # check available relations
  i <- enams %in% colnames(d)
  if(!all(i)) 
    stop(paste("fields not found:", paste(enams[!i], collapse=", ")))
  # check other fields
  i <- vnams %in% colnames(d)
  if(!all(i)) 
    stop(paste("fields not found:", paste(vnams[!i], collapse=", ")))
  # list of edgelists and nodes lists
  l <- lapply(enams, function(vn)
  {
    # split on commas and drop newline
    alt <- strsplit( gsub("\n", "", a[,vn]), ", *")
    # get rid of package versions
    el <- lapply(alt, function(x)
    {
      rval <- gsub( "\\(.*\\)", "", x)
      stats::na.omit( gsub(" +", "", rval) )
    } )
    len <- sapply(el, length)
    # edge list
    edges <- data.frame( ego=rep(names(el), len), alter=unlist(el),
                         type=rep(vn, sum(len)), stringsAsFactors=FALSE)
    # node list
    nodes <- data.frame(name=sort(unique(c(names(el), unlist(el)))),
                        stringsAsFactors=FALSE)
    # add package attributes for 'a'
    mv <- match(nodes$name, a[,"Package"])
    z <- as.data.frame(a[mv, vnams], stringsAsFactors=FALSE)
    rownames(z) <- NULL
    nodes <- cbind( nodes, z )
    list(nodes=nodes, edges=edges)
  } )
  nodes <- do.call("rbind", lapply(l, "[[", "nodes"))
  nodes <- unique(nodes)
  edges <- do.call("rbind", lapply(l, "[[", "edges"))
  rval <- igraph::graph.data.frame(edges, vertices=nodes)
  rval
}
