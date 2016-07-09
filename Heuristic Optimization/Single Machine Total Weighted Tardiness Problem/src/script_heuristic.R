best.known <- read.table("wtbest100b.txt")
a.cost <- read.table("vnd/vnd-earl-tr-ins-ex.dat")$V1
a.cost <- 100 * (a.cost - best.known)/best.known
mean(a.cost[a.cost != "NaN"])
b.cost <- read.table("vnd/vnd-rand-tr-ins-ex.dat")$V1
b.cost <- 100 * (b.cost - best.known)/best.known
mean(b.cost[b.cost != "NaN"])
t.test (a.cost[[1]] , b.cost[[1]], paired=T)$p.value
wilcox.test (a.cost[[1]] , b.cost[[1]], paired=T)$p.value
