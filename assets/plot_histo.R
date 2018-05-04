# An R script to produce a plot of histogram output from jellyfish
data <- read.table("histo.out", header=FALSE)
names(data) <- c("x","y")
png("histo.png",height=400,width=800)
plot(data$x,data$y,main="distribution of k-mer frequencies",xlab="# times k-mer detected",ylab="# k-mers",xlim=c(0,100),ylim=c(0,200000))
dev.off()
