\name{pkgnet}
\alias{pkgnet}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
pkgnet(a, enams = c("Depends", "Suggests", "Contains", "Imports", "Enhances"), vnams = c("Version", "Priority", "Bundle", "License", "File", "Repository"))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{a}{
%%     ~~Describe \code{a} here~~
}
  \item{enams}{
%%     ~~Describe \code{enams} here~~
}
  \item{vnams}{
%%     ~~Describe \code{vnams} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function(a, enams=c("Depends", "Suggests", "Contains", "Imports", "Enhances"),
    vnams=c("Version", "Priority", "Bundle", "License", "File", "Repository") )
{
    # list of edgelists and nodes lists
    l <- lapply(enams, function(vn)
        {
            # split on commas and drop newline
            alt <- strsplit( gsub("\n", "", a[,vn]), ", *")
            # get rid of package versions
            el <- lapply(alt, function(x)
                {
                    rval <- gsub( "\\(.*\\)", "", x)
                    na.omit( gsub(" +", "", rval) )
                } )
            len <- sapply(el, length)
            # edge list
            edges <- data.frame( ego=rep(names(el), len), alter=unlist(el), type=rep(vn, sum(len)))
            # node list
            nodes <- data.frame(name=sort(unique(c(names(el), unlist(el)))))
            # add package attributes for 'a'
            mv <- match(nodes$name, a[,"Package"])
            z <- a[mv, vnams]
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
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
