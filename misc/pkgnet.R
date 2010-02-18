a <- available.packages()

library(pkgnet)
g0 <- pkgnet(a)
g <- delete.vertices(g0, V(g0)[ name == "R" ] )
g <- delete.vertices(g, V(g)[ Priority %in% "recommended" ] )
bpkg <- c("stats", "tools", "utils", "methods", "stats4", "rgl", "tcltk")
g <- delete.vertices(g, V(g)[ name %in% bpkg ] )
summary(g)

npkg <- c("igraph", "network", "graph")
n <- neighborhood(g, 1, V(g)[ name %in% npkg ] )
sg <- subgraph(g, unique(unlist(n)) )
summary(sg)


koords <- layout.fruchterman.reingold(sg, params=list(niter=70))
u <- sort(unique(E(sg)$type))
typ <- match( E(sg)$type, u)
plot(sg, vertex.size=1, vertex.label=V(sg)$name, layout=koords,
    edge.arrow.size=.5, vertex.label.cex=.9, edge.color=typ)
legend("topleft", legend=u, lty=1, col=seq(along=typ))

crannet <- g0
save(crannet, file="crannet.rda")
