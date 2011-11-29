\name{pkgnet}
\alias{pkgnet}
\title{Build a network based on package availability matrix}
\description{
Given the matrix as returned by \code{available.packages}
construct a graph, of class \code{igraph} of inter-package relations.
}
\usage{
pkgnet(a, enams = c("Depends", "Suggests", "Imports", "Enhances", "LinkingTo"),
vnams = c("Version", "Priority", "License", "File", "Repository"))
}
\arguments{
  \item{a}{matrix, as returned by \code{available.packages}}
  \item{enams}{character, names of columns of \code{a} that are to be used as edge attributes}
  \item{vnams}{character, names of columns of \code{a} that are to be used as vertex attributes}
}
\details{
The resulting graph (object of class \code{igraph}) is a multigraph: there can
be multiple relationships between any given pair of vertices. Different types
of relations can be disentagled using edge attribute called \code{type}. It
stores the type of relation as provided with \code{enams} argument.
}
\value{
Object of class \code{igraph}.
}
\seealso{
\code{\link{available.packages}}, \code{\link{graph.data.frame}}
}
\examples{
a <- available.packages(contrib.url("http://cran.r-project.org", "source"))
g <- pkgnet(a)
summary(g)
}
