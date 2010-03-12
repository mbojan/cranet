a <- available.packages()

library(pkgnet)
g0 <- pkgnet(a)
g <- delete.vertices(g0, V(g0)[ name == "R" ] )
g <- delete.vertices(g, V(g)[ Priority %in% "recommended" ] )
bpkg <- c("stats", "tools", "utils", "methods", "stats4", "rgl", "tcltk")
g <- delete.vertices(g, V(g)[ name %in% bpkg ] )
summary(g)

# plot total graph
koords <- layout.fruchterman.reingold(g, params=list(niter=70))
u <- sort(unique(E(g)$type))
typ <- match( E(g)$type, u)
plot(g, vertex.size=1, layout=koords, vertex.label=NA,
    edge.arrow.size=.5, vertex.label.cex=.9, edge.color=typ)
legend("topleft", legend=u, lty=1, col=seq(along=typ))





# only network packages
npkg <- c("igraph", "network", "graph")
n <- neighborhood(g, 1, V(g)[ name %in% npkg ] )
sg <- subgraph(g, unique(unlist(n)) )
summary(sg)

koords <- layout.fruchterman.reingold(sg, params=list(niter=70))
u <- sort(unique(E(sg)$type))
typ <- match( E(sg)$type, u)
plot(sg, vertex.size=1, vertex.label=V(sg)$name, layout=koords,
    edge.arrow.size=.5, vertex.label.cex=.9, edge.color=typ,
       vertex.label.color="black")
legend("topleft", legend=u, lty=1, col=seq(along=typ))

crannet <- g0
save(crannet, file="crannet.rda")




#============================================================================

# plotting multigraphs so that multiple ties in the same dyad are drawn curved
# with different degree of curvature

# example network
n <- graph(c(0,1, 0,1, 1,0, 1,0, 1,2, 1,2, 1,2, 2,3, 3,2),
    directed=TRUE)
n$layout <- layout.fruchterman.reingold(n)

plot(n, edge.curved = seq(.1, 0.5, length=ecount(n)))
