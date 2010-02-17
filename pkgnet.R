library(utils)

# package matrix
a <- available.packages()

# split on commas and remove new-lines
alt <- strsplit( gsub("\n", "", a[,"Depends"]), ", *")

# get rid of package versions and other rubbish
el <- lapply(alt, function(x) 
{
    rval <- gsub( "\\(.*\\)", "", x)
    na.omit( gsub(" +", "", rval) )
} )

ego <- names(el)
alter <- unique(unlist(el))

# compare name sets
length(ego)
length(alter)
length(intersect(ego, alter))
setdiff(alter, ego)
length( setdiff(ego, alter) )


library(igraph)
len <- sapply(el, length)


vnams <- c("Version", "Priority", "Bundle", "License", "File",
    "Repository")

nodes <- data.frame( name=sort(unique(c(ego, alter))))
mv <- match(nodes$name, a[,"Package"])
z <- a[mv, vnams]
rownames(z) <- NULL
nodes <- cbind( nodes, z )

edges <- data.frame(ego=rep(names(el), len), alter=unlist(el))

# pełna sieć ze wszystkimi śmieciami (R, MASS etc.)
g <- graph.data.frame(edges, vertices=nodes)
summary(g)


g1 <- delete.vertices(g, which( V(g)$name == "R") -1 )



set.seed(2992)
k <- layout.fruchterman.reingold(g1)
save(k, file="gfull-fr.rda")

plot(g1, vertex.label=NA, vertex.size=2, layout=k)




pkgnet <- function(a, enams=c("Depends", "Suggests", "Contains", "Imports", "Enhances"),
    vnams=c("Version", "Priority", "Bundle", "License", "File", "Repository") )
{
    require(igraph)
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
     rval <- graph.data.frame(edges, vertices=nodes)
     rval
}




g <- pkgnet(a)



# select the largest component
sg <- delete.vertices(g, V(g)[ name == "R" ] )
k <- clusters(sg)
ids <- which(k$membership == 1) - 1
sg <- subgraph(sg, ids)

koords <- layout.fruchterman.reingold(sg, params=list(niter=30))

typ <- E(sg)$type


library(RColorBrewer)
palette(brewer.pal(8, "Dark2"))

pdf("netall.pdf", 70, 70)
plot(sg, vertex.size=.3, vertex.label=NA, edge.color=match(typ, unique(typ)),
    layout=koords, edge.arrow.size=.3, vertex.color="black")
dev.off()


# subgraph based on edges
gdep <- 
