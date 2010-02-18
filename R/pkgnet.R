pkgnet <-
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

