

#' Network based packages on CRAN
#' 
#' This is a network object containing packages and relations between them. It
#' is based on a snapshot taken on February 18, 2010 around 18:30 GMT.
#' 
#' 
#' @name crannet
#' @docType data
#' @format The network object is of class \code{igraph}. It is a directed
#' network which contains 2277 packages (vertices) and 6903 inter-package
#' relations (edges). The network, together with vertex and edge attributes is
#' build from the matrix as returned by \code{\link{available.packages}}, which
#' in turn is based on package DESCRIPTION files.
#' 
#' There are following vertex attributes, usually based on corresponding
#' entries in the package DESCRIPTION file: \describe{ \item{name}{character,
#' package name} \item{Version}{character, package version number}
#' \item{Priority}{character, package priority, one of "contrib", "optional",
#' or "recommended"} \item{Bundle}{name of the bundle the package is part of,
#' now empty as bundles are no longer used (?)} \item{License}{character, name
#' of the license the package is released under} \item{File}{character, not
#' sure (?)} \item{Repository}{character, name of the repository in which the
#' package is available} }
#' 
#' The network is a multi-graph, i.e. there may be multiple edges between a
#' given pair of nodes. This corresponds to the fact, that package X may, for
#' example, both depend and import package Y.  To disentangle the types of
#' relations one can use edge attributes.  There are following edge attributes
#' in this object: \describe{ \item{type}{character, type of inter-package
#' relation, one of "Depends", "Enhances", "Imports", "Suggests"} }
#' @source Fetched from \url{http://cran.at.r-project.org} on February 18,
#' 2010.
#' @keywords datasets
#' @examples
#' 
#' data(crannet)
#' 
#' # neighborhood of network "backend" packages:
#' # "network", "igraph", and "graph"
#' 
#' # using 'in' oprator does not work in examples !?!?
#' inn <- function(x, y) match(x, y, nomatch=0) > 0
#' 
#' # drop some obvious dependencies: R, base and recommended packages
#' g <- delete.vertices(crannet, V(crannet)[ name == "R" ] )
#' g <- delete.vertices(g, V(g)[ inn(Priority, "recommended") ] )
#' bpkg <- c("stats", "tools", "utils", "methods", "stats4", "rgl", "tcltk",
#'   "base")
#' g <- delete.vertices(g, V(g)[ inn(name, bpkg) ] )
#' summary(g)
#' 
#' # pick the neighborhood and make the subgraph
#' npkg <- c("igraph", "network", "graph")
#' n <- neighborhood(g, 1, V(g)[ inn(name, npkg) ] )
#' sg <- subgraph(g, unique(unlist(n)) )
#' summary(sg)
#' 
#' # plot it
#' set.seed(2992)
#' koords <- layout.fruchterman.reingold(sg, params=list(niter=80))
#' u <- sort(unique(E(sg)$type))
#' typ <- match( E(sg)$type, u)
#' palette(rainbow(3))
#' plot(sg, vertex.size=1, vertex.label=V(sg)$name, layout=koords,
#'   vertex.label.color="black", edge.arrow.size=.5, vertex.label.cex=.9,
#'   edge.color=typ, vertex.label.family="Helvetica")
#' legend("bottomleft", legend=u, lty=1, col=seq(along=typ))
#' palette("default")
#' 
NULL





#' Network analysis of relations between R packages
#' 
#' Package DESCRIPTION files allows for specifying several types of
#' inter-package relations.  These include fields like Depends, Suggests,
#' Enhances etc. This package allows for recovering graph structure based on
#' these relations. Network representation of R repositories enables the user
#' to fruitfully explore the interconnected space of available R functionality
#' while the developers or repository maintainers can quickly scan package
#' forward and reverse dependencies.
#' 
#' 
#' @name pkgnet-package
#' @docType package
#' @author Author and maintainter: Michal Bojanowski
#' \email{m.j.bojanowski@@uu.nl}
#' @keywords package
NULL



