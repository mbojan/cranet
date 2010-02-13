library(utils)

# package matrix
a <- available.packages()

# split on commas
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
