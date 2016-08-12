require(igraph)

# neighborhood of network "backend" packages:
# "network", "networkDynamic", "igraph", and "graph"

# drop some obvious dependencies: R, base and recommended packages
g <- delete.vertices(crannet, V(crannet)[ name == "R" ] )
g <- delete.vertices(g, V(g)[ Priority %in% "recommended" ] )
bpkg <- c("stats", "tools", "utils", "methods", "stats4", "rgl", "tcltk", "base")
g <- delete.vertices(g, V(g)[ name %in% bpkg ] )
summary(g)

# pick the neighborhood and make the subgraph
npkg <- c("igraph", "network", "graph", "networkDynamic")
n <- neighborhood(g, 1, V(g)[ name %in% npkg ] )
sg <- simplify( induced.subgraph(g, unique(unlist(n)) ) )
summary(sg)

# plot it
set.seed(2992)
koords <- layout.fruchterman.reingold(sg)
plot(sg, vertex.size=1, vertex.label=V(sg)$name, layout=koords,
     vertex.label.color="black", edge.arrow.size=.5, vertex.label.cex=.9,
     vertex.label.family="Helvetica")
