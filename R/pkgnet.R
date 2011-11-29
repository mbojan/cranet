pkgnet <-
function(a, enams=c("Depends", "Suggests", "Imports", "Enhances", "LinkingTo"),
    vnams=c("Version", "Priority", "License", "File", "Repository") )
{
  # check available relations
  i <- enams %in% colnames(a)
  if(!all(i)) stop(paste("fields not found:", paste(enams[!i], collapse=", ")))
  # check other fields
  i <- vnams %in% colnames(a)
  if(!all(i)) stop(paste("fields not found:", paste(vnams[!i], collapse=", ")))
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

