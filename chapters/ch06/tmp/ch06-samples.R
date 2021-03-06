library(ggplot2)
library(scales)
library(grid)
library(gridExtra)
library(gdata)
library(RColorBrewer)

runall <- FALSE
figure <- 7  # start at figure number...

scale.filter <- function(x) {
  x[is.na(x)] <- 0
  humanReadable(x)
}
scale.filter.nb <- function(x) {
  x[is.na(x)] <- 0
  sub("B", "", humanReadable(x))
}
getfile <- function(x) {
  paste("figures/test-793725c06f", sprintf("%03d", x), ".pdf", sep="")
}
theme_sample <- function() {
  theme_bw() + theme(legend.title=element_blank(),
        panel.border=element_blank(),
        panel.grid.major.y=element_line(color="gray80"),
        panel.grid.major.x=element_line(color="gray80"),
        panel.grid.minor=element_blank(),
        axis.ticks.length = unit(0, "cm"),
        axis.ticks.margin = unit(0.1, "cm"),
        legend.background = element_rect(colour = '#FFFFFF00', fill = '#FFFFFF', size = 0.4))
}

# load source data
fw <- read.csv("data/fivemin.csv", header=T)

if (runall) {
  fw <- read.csv("data/fivemin.csv", header=T)
  
  fw <- read.csv("data/fivemin.csv", header=T)
  fullfw <- aggregate(cbind(packets, bytes, sessions) ~ hour, data=fw, FUN=sum)
  fullfw <- fullfw[order(fullfw$hour), ] # want to be sure we're still sorted
  fullfw$iter <- seq_along(fullfw$hour)
  
  # Not a rolling average
  gcolor=rep("gray97", nrow(fullfw))
  gcolor[seq(1,nrow(fullfw), by=12)] <- "gray80"
  pcolor=rep("gray60", nrow(fullfw))
  pcolor[seq(1,nrow(fullfw), by=6)] <- "#CC0000"

  mylabel <- c("8am", "9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm")
  
  gg <- ggplot(fullfw, aes(iter, sessions))
  gg <- gg + geom_bar(stat="identity", width=0.1, color=gcolor)
  gg <- gg + geom_point(size=2, color=pcolor)
  gg <- gg + ylab("Sessions") + xlab("Time")
  gg <- gg + scale_x_continuous(labels=mylabel, 
                                breaks=seq(1,nrow(fullfw), by=12))
  gg <- gg + scale_y_continuous(labels=scale.filter.nb)
  gg <- gg + theme_bw() + theme_sample()
  print(gg)

  ggsave(getfile(10), gg, width=8, height=2.5)
  
  # rolling average (2)
  x <- seq(2, nrow(fullfw))
  y <- sapply(x, function(z) sum(fullfw$sessions[(z-1):z])/2)
  dfi <- data.frame(x, y)
  gcolor=rep("gray95", nrow(dfi))
  gcolor[seq(1,nrow(dfi), by=12)] <- "gray80"
  pcolor=rep("gray60", nrow(dfi))
  pcolor[seq(1,nrow(dfi), by=6)] <- "#CC0000"
  
#   gg <- ggplot(dfi, aes(x, y))
#   gg <- gg + geom_bar(stat="identity", width=0.1, color=gcolor)
#   gg <- gg + geom_point(size=2, color=pcolor)
#   gg <- gg + ylab("Sessions") + xlab("Time")
#   gg <- gg + scale_x_continuous(labels=mylabel, breaks=seq(2,nrow(dfi), by=12))
#   gg <- gg + scale_y_continuous(labels=scale.filter.nb)
#   gg <- gg + theme_sample()
#   print(gg)
  ggsave(getfile(figure), gg, width=8, height=3)
}
figure <- figure + 1

  

if (runall) {
  fw <- read.csv("data/fivemin.csv", header=T)
  fullfw <- aggregate(cbind(packets, bytes) ~ hour, data=fw, FUN=sum)
  gg <- ggplot(fullfw, aes(packets, bytes))
  gg <- gg + geom_point(size=3, color="#000066")
  gg <- gg + xlab("Packets") + ylab("Bytes") 
  gg <- gg + scale_x_continuous(breaks=c(12,15,18,21,24,27)*10^6, labels=scale.filter.nb)
  gg <- gg + scale_y_continuous(breaks=c(7,10,13,16,19)*10^9, labels=scale.filter)
  gg <- gg + theme_sample()
  
  print(gg)
  ggsave(getfile(figure), gg, width=8, height=5)
}
figure <- figure + 1

if (runall) {
  ## line
  # myfw <- cbind(fw, realx=seq_along(fw$hour))
  better <- data.frame(hour=unique(fw$hour), realx=seq_along(unique(fw$hour)))
  allfw <- merge(fw, better, allx=T)

  #gcolor[seq(1,nrow(fw), by=12)] <- "gray60"
  #pcolor=rep("gray60", nrow(fw))
  #pcolor[seq(1,nrow(fw), by=6)] <- "#CC0000"
  mylabel <- c("8am", "9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm")
  myb <- seq(1, length(unique(allfw$realx)), by=12)
  
  gg <- ggplot(allfw, aes(realx, bytes, group=type, color=type))
  gg <- gg + geom_smooth(stat="identity", fill="white")
  gg <- gg + theme_bw() + scale_y_log10(labels=scale.filter)
  gg <- gg + scale_x_continuous(breaks=myb, label=mylabel)
  gg <- gg + xlab("Time") + ylab("Bytes")
  gg <- gg + theme_sample() + theme(legend.position = "bottom")
  print(gg)
  # ggsave(getfile(11), gg, width=8, height=5)
  aa <- gg
  
  gg <- ggplot(allfw, aes(realx, bytes, group=type, color=type))
  gg <- gg + geom_point(size=1.5) #(stat="identity", fill="white")
  gg <- gg + theme_bw() + scale_y_log10(labels=scale.filter)
  gg <- gg + scale_x_continuous(breaks=myb, label=mylabel)
  gg <- gg + xlab("Time") + ylab("Bytes")
  gg <- gg + theme_sample() + theme(legend.position = "bottom")
  print(gg)
  pdf(getfile(11), width=11, height=5)
  grid.arrange(gg, aa, ncol=2, clip=T)
  dev.off()
  
}
figure <- figure + 1
# tring other bar chart
foo <- read.csv("~/Documents/book/bobfw/ipmap2.csv", header=T)
# vulns per device
set.seed(1492)
wk <- round(c(rnorm(12, mean=rep(c(60, 40, 2, 2), each=3), sd=rep(c(10, 10, 0.5, 0.5), each=3))), 0)
wk <- c(56, 61, 44, 50, 37, 48,  2,  2,  1,  2,  2,  1)
dev <- c("Workstation", "Server", "Network", "Printer")
sev <- c("High", "Med", "Low")
dfi <- data.frame(x=rep(dev, each=3), y=wk, sev=rep(rev(sev), 4))
dfi$x <- factor(dfi$x, levels=dev, ordered=T)
dfi$sev <- factor(dfi$sev, levels=sev, ordered=T)

color.pal <- brewer.pal(3, "Reds")

gg <- ggplot(dfi, aes(x, y))
gg <- gg + geom_bar(stat="identity", fill=color.pal[2], show_guide=F)
gg <- gg + xlab("Device Type") + ylab("Vulnerabilities")
gg <- gg + theme_sample() + theme(plot.margin = unit(c(0.5,0.4,2,0), "cm"))
gg <- gg + ggtitle("Vertical Bar Chart")
# print(gg)
aa <- gg
gg <- ggplot(dfi, aes(x, y, fill=sev))
gg <- gg + geom_bar(stat="identity") #  show_guide=F)
gg <- gg + xlab("Device Type") + ylab("Vulnerabilities")
gg <- gg + scale_fill_manual(values=rev(color.pal))
gg <- gg + theme_sample() + theme(legend.position = "bottom")
gg <- gg + ggtitle("Stacked Bar Chart")
#print(gg)
bb <- gg
gg <- ggplot(dfi, aes(x, y, fill=sev))
gg <- gg + geom_bar(stat="identity", position=position_dodge()) #  show_guide=F)
gg <- gg + xlab("Device Type") + ylab("Vulnerabilities")
gg <- gg + scale_fill_manual(values=rev(color.pal))
gg <- gg + theme_sample() + theme(legend.position = "bottom")
gg <- gg + ggtitle("Grouped Bar Chart")
#print(gg)
cc <- gg

pdf(getfile(12), width=12, height=4)
# making this bigger, when smaller the font overlaps
grid.arrange(aa, bb ,cc, ncol=3, clip=T)
dev.off()

# bar chart
if (runall) {
  # maybe pull a different color blue here?
  fw$realhour <- substr(fw$hour, 1, 2)
  barfw <- aggregate(cbind(packets, bytes, sessions) ~ type + realhour, data=fw, FUN=sum)
  barfw$type <- factor(barfw$type, levels=c("Workstation", "Server", "Network", "Printer"), ordered=T)
  allbarfw <- aggregate(cbind(packets,bytes,sessions) ~ realhour, data=barfw, FUN=sum)
  gg <- ggplot(allbarfw, aes(realhour, sessions))
  gg <- gg + geom_bar(stat="identity", fill="#000066", show_guide=F)
  gg <- gg + xlab("Hour") + ylab("Sessions")
  gg <- gg + scale_y_continuous(labels=scale.filter.nb)
  gg <- gg + scale_x_discrete(labels=mylabel)
  gg <- gg + theme_sample()
  print(gg)
  aa <- gg
  gg <- ggplot(allbarfw, aes(rev(realhour), sessions))
  gg <- gg + geom_bar(stat="identity", fill="#000066", show_guide=F)
  gg <- gg + xlab("Hour") + ylab("Sessions")
  gg <- gg + scale_y_continuous(labels=scale.filter.nb)
  gg <- gg + scale_x_discrete(labels=rev(mylabel))
  gg <- gg + theme_sample() + coord_flip()
  print(gg)
  bb <- gg
  #pdf("figures/793725c06f003.pdf", width=9, height=6)
  pdf(getfile(figure), width=8, height=3)
  grid.arrange(aa, bb, ncol=2, clip=T, widths=c(7,8))
  dev.off()
  figure <- figure + 1
  
  gg <- ggplot(barfw, aes(realhour, log10(sessions), fill=type))
  gg <- gg + geom_bar(stat="identity") #, show_guide=F)
  gg <- gg + scale_fill_brewer(palette="Set2")
  gg <- gg + xlab("Time") + ylab("")
  gg <- gg + scale_y_continuous(labels=scale.filter.nb)
  gg <- gg + scale_x_discrete(labels=mylabel)
  gg <- gg + theme_sample() + theme(axis.text.y = element_blank())
  print(gg)
  cc <- gg
  
  gg <- ggplot(barfw, aes(realhour, sessions, fill=type))
  gg <- gg + geom_bar(stat="identity", position=position_dodge(), show_guide=F)
  gg <- gg + scale_fill_brewer(palette="Set2")
  gg <- gg + xlab("Time") + ylab("Sessions")
  gg <- gg + scale_y_log10(labels=scale.filter.nb)
  gg <- gg + scale_x_discrete(labels=mylabel)
  gg <- gg + theme_sample() #+ theme(legend.position="bottom")
  print(gg)
  dd <- gg
  pdf(getfile(figure), width=12, height=5)
  # making this bigger, when smaller the font overlaps
  grid.arrange(dd, cc, ncol=2, clip=T, widths=c(8,6))
  dev.off()
  figure <- figure + 1
} else {
  figure <- figure + 2
}

if (runall) {
  ##
  ## size
  ##
  wk <- fw[which(fw$type=="Network"), ]  # not log
  gg <- ggplot(wk, aes(sessions, bytes, size=packets, color=type, fill=type))
  gg <- gg + scale_color_brewer(palette="Set2") + xlab("Sessions") + ylab("Bytes")
  gg <- gg + geom_point(alpha=1/3, shape=21, color="black", guide=F) + theme_bw()
  gg <- gg + scale_size_continuous(range = c(2, 20), trans=log10_trans(), guide=F)
  #gg <- gg + scale_x_log10(labels=scale.filter)
  #gg <- gg + scale_y_log10(labels=scale.filter) 
  gg <- gg + scale_x_continuous(labels=scale.filter)
  gg <- gg + scale_y_continuous(labels=scale.filter) 
  gg <- gg + theme(legend.position="none",
                   panel.border=element_blank(),
                   panel.grid.major.y=element_line(color="gray60"),
                   panel.grid.major.x=element_line(color="gray80"),
                   panel.grid.minor=element_blank(),
                   axis.ticks.length = unit(0, "cm"),
                   axis.ticks.margin = unit(0.1, "cm"),
                   legend.background = element_rect(colour = '#FFFFFF00', 
                                                    fill = '#FFFFFF', size = 0.4))
  print(gg)
  ggsave(getfile(figure), gg, width=8, height=5)
}
figure <- figure + 1

## log plot
#foo <- c(seq(1,10), seq(1,10)*10, seq(1,10)*100)
#dfi <- data.frame(y=c(foo, log10(foo)), x=rep(c("a", "b"), each=length(foo)*2), g=rep(seq(1,length(foo)*2), 2))

if (runall) {
  # histograms
  fullfw <- aggregate(cbind(packets, bytes, sessions) ~ hour, data=fw, FUN=sum)
  aa <- ggplot(fullfw, aes(x=sessions))
  #aa <- aa + geom_density() + theme_sample()
  aa <- aa + geom_histogram(binwidth=12000, colour="black", fill="#8DA0CB") 
  aa <- aa + scale_x_continuous(labels=scale.filter.nb)
  aa <- aa + xlab("Number of Sessions") + ylab("Count") + theme_sample()
  #print(aa)
  
  gg <- ggplot(fullfw, aes(x=sessions))
  gg <- gg + geom_histogram(aes(y=..density..), binwidth=12000, colour="#80808080", fill="#8DA0CB66", alpha=1/3)
  gg <- gg + geom_density(alpha=1/2, fill="#8DA0CB")  # Overlay with transparent density plot
  gg <- gg + xlab("Number of Sessions") + ylab("Density")
  gg <- gg + scale_x_continuous(labels=scale.filter.nb)
  gg <- gg + theme_sample()
  #print(gg)
  
  pdf(getfile(15), width=8, height=4)
  grid.arrange(aa, gg, ncol=2, clip=T)
  dev.off()
}
figure <- figure + 1

# simple box plot (replacing with previous work)
if (0) {
  gg <- ggplot(fullfw, aes(x=foo, y=sessions)) + coord_flip()
  gg <- gg + scale_y_continuous(labels=scale.filter.nb)
  gg <- gg + geom_boxplot(fill="#8DA0CB") + theme_sample() + theme(axis.text.y=element_blank())
  gg <- gg + xlab("") + ylab("Number of Sessions in 5 minutes")
  gg <- gg + theme(panel.grid.major.y=element_blank())
  print(gg)
  ggsave(getfile(figure), gg, width=8, height=2)  
}

if (0) {
  ## shape
  
  fwspec$bperp <- fwspec$bytes/fwspec$packets
  fwagg <- aggregate(bperp ~ type, data=fwspec, FUN=mean)
  fwagg$type <- factor(fwagg$type, levels=c("Workstation", "Server", "Printer", "Network"), ordered=T)
  fwagg$bperp <- round(fwagg$bperp, 0)
  gg <- ggplot(fwagg, aes(type, bperp, fill=type, label=bperp))
  gg <- gg + geom_bar(stat="identity", show_guide=F)
  gg <- gg + xlab("") + ylab("Bytes") + scale_fill_brewer(palette="Set2")
  gg <- gg + geom_text(aes(x=fwagg$type, y=fwagg$bperp+15), size=4)
  gg <- gg + ggtitle("Bytes per Packet by Device")
  gg <- gg + theme_bw()
  gg <- gg + theme(legend.title=element_blank(),
                   panel.border=element_blank(),
                   panel.background=element_blank(),
                   panel.grid.major.y=element_line(color="gray70"), 
                   panel.grid.major.x=element_blank(),
                   panel.grid.minor=element_blank(),
                   # axis.text.y = element_blank(),
                   axis.ticks.length = unit(0, "cm"),
                   axis.ticks.margin = unit(0.1, "cm"))
  print(gg)
  ggsave("figures/793725c06f010.pdf", gg, width=8, height=5)
  
  ##
  ## Shapes
  ##
  gg <- ggplot(fwspec, aes(packets, bytes, shape=type, color=type))
  gg <- gg + scale_color_brewer(palette="Set2") + xlab("Packets") + ylab("Bytes")
  gg <- gg + geom_point(size=5, alpha=1/3) + theme_bw()
  gg <- gg + scale_x_log10(labels=scale.filter)
  gg <- gg + scale_y_log10(labels=scale.filter) 
  gg <- gg + theme(legend.title=element_blank(),
                   panel.border=element_blank(),
                   panel.grid.major.y=element_line(color="gray60"),
                   panel.grid.major.x=element_line(color="gray80"),
                   panel.grid.minor=element_blank(),
                   axis.ticks.length = unit(0, "cm"),
                   axis.ticks.margin = unit(0.1, "cm"),
                   legend.background = element_rect(colour = '#FFFFFF00', fill = '#FFFFFF', size = 0.4))
  #print(gg)
  aa <- gg
  gg <- ggplot(fwspec, aes(sessions, bytes, shape=type, color=type))
  gg <- gg + scale_color_brewer(palette="Set2") + xlab("Sessions") + ylab("Bytes")
  gg <- gg + geom_point(size=5, alpha=1/3) + theme_bw()
  gg <- gg + scale_x_log10(labels=scale.filter)
  gg <- gg + scale_y_log10(labels=scale.filter) 
  gg <- gg + theme(legend.title=element_blank(),
                   panel.border=element_blank(),
                   panel.grid.major.y=element_line(color="gray60"),
                   panel.grid.major.x=element_line(color="gray80"),
                   panel.grid.minor=element_blank(),
                   axis.ticks.length = unit(0, "cm"),
                   axis.ticks.margin = unit(0.1, "cm"),
                   legend.background = element_rect(colour = '#FFFFFF00', fill = '#FFFFFF', size = 0.4))
  #print(gg)
  grid.arrange(aa, gg, ncol=2, clip=T)
  
}

if (0) {
#   foo <- read.csv("~/Documents/book/bobfw/forjay-network.csv", header=T)
#   goo <- data.frame(ip=foo[[7]], sys=foo[[3]], type="Network")
#   foo <- read.csv("~/Documents/book/bobfw/forjay-servers.csv", header=T)
#   goo <- rbind(goo, data.frame(ip=foo[[15]], sys=foo[[32]], type="Server"))
#   
#   write.csv(goo, "~/Documents/book/bobfw/ip-map.csv", row.names=F)
#   forjay-servers.csv
#   #[8/29/13 10:17:02 AM] Bob Rudis: Windows 7 Task Worker
#   #[8/29/13 10:17:08 AM] Bob Rudis: Windows 7 Developer Workstation
#   #[8/29/13 10:17:17 AM] Bob Rudis: Linux Developer Workstation
#   
#   foo <- read.csv("~/Documents/book/bobfw/treemap.csv", header=T)
#   foo$count <- 1
#   foo <- foo[which(foo$sessions>0), ]
#   mine <- aggregate(cbind(count, sessions) ~ cat + type, data=foo, FUN=sum)
#   mine$mean <- mine$sessions/mine$count
  #map.market(id=mine$cat, area=mine$count, group=mine$type, color=mine$mean, main="what the")

#  write.csv(mine, "~/Documents/book/bobfw/ipmap2.csv", row.names=F)
  foo <- read.csv("~/Documents/book/bobfw/ipmap2.csv", header=T)
  foo$mean <- foo$sessions/foo$count
  map.market(id=foo$label, area=sqrt(foo$count)^1.3, group=foo$type, color=sqrt(foo$mean), main="what the", lab= c("group"=F, "id"=T))
  map.market(id=foo$label, area=foo$count, group=foo$type, color=sqrt(foo$mean), main="what the", lab= c("group"=F, "id"=T))
}

if (runall) {
  one <- read.csv("~/Documents/book/bobfw/onemin2.csv", header=T)
  allone <- aggregate(bytes ~ hour, data=one, FUN=sum)
  allone <- allone[with(allone, order(hour)), ]
  allone$iter <- seq_along(allone$hour)
  mylabel <- c("8am", "9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm")
  mybreaks <- seq(1, nrow(allone), by=60)
  gg <- ggplot(allone, aes(iter, bytes)) 
  gg <- gg + geom_line()
  gg <- gg + ylab("Bytes") + xlab("Time")
  gg <- gg + scale_x_continuous(labels=mylabel, breaks=mybreaks)
  gg <- gg + scale_y_continuous(labels=scale.filter, limits=c(0,max(allone$bytes)))
  gg <- gg + theme_sample()
  print(gg)
  aa <- gg
  #
  # average 2
  rollav <- function(x, by=2) {
    sapply(seq(by,length(x)), function(z) mean(x[(z-by):z]))
  }
  rez <- rollav(allone$bytes, 2)
  av2 <- data.frame(iter=seq_along(rez), bytes=rez)
  mybreaks <- seq(1, nrow(av2), by=60)
  gg <- ggplot(av2, aes(iter, bytes)) 
  gg <- gg + geom_line()
  gg <- gg + ylab("Bytes") + xlab("Time")
  gg <- gg + scale_x_continuous(labels=mylabel, breaks=mybreaks)
  gg <- gg + scale_y_continuous(labels=scale.filter, limits=c(0,max(allone$bytes)))
  gg <- gg + theme_sample()
  print(gg)
  bb <- gg
  #
  # average 3
  rez <- rollav(allone$bytes, 5)
  av2 <- data.frame(iter=seq_along(rez), bytes=rez)
  mybreaks <- seq(1, nrow(av2), by=60)
  gg <- ggplot(av2, aes(iter, bytes)) 
  gg <- gg + geom_line()
  gg <- gg + ylab("Bytes") + xlab("Time")
  gg <- gg + scale_x_continuous(labels=mylabel, breaks=mybreaks)
  gg <- gg + scale_y_continuous(labels=scale.filter, limits=c(0,max(allone$bytes)))
  gg <- gg + theme_sample()
  print(gg)
  cc <- gg
  aa <- aa + ggtitle("Total Bytes per Minute")
  bb <- bb + ggtitle("Moving Average over 2 Mins")
  cc <- cc + ggtitle("Moving Average over 5 Mins")
  pdf(getfile(17), width=8, height=6)
  grid.arrange(aa, bb, cc, ncol=1, clip=T)
  dev.off()
  
}

if (runall) {
  one <- read.csv("~/Documents/book/bobfw/onemin2.csv", header=T)
  allone <- aggregate(bytes ~ hour, data=one, FUN=sum)
  allone <- allone[with(allone, order(hour)), ]
  allone$iter <- seq_along(allone$hour)
  mylabel <- c("8am", "9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm")
  mybreaks <- seq(1, nrow(allone), by=60)
  gg <- ggplot(allone, aes(iter, bytes, color=bytes)) 
  gg <- gg + geom_line(alpha=1/30, size=4)
  gg <- gg + geom_line(alpha=1/20, size=2)
  gg <- gg + geom_point(alpha=1/10, size=6)
  gg <- gg + geom_point(alpha=1/2, size=2)
  gg <- gg + ylab("Bytes") + xlab("Time")
  gg <- gg + scale_x_continuous(labels=mylabel, breaks=mybreaks)
  gg <- gg + scale_y_continuous(labels=scale.filter, limits=c(0,max(allone$bytes)))
  gg <- gg + theme_sample() + theme(legend.position="none")
  print(gg)
}

if (runall) {
  pdf(getfile(18), width=8, height=2)
  par(mar=c(0,0,0,0))
  plot(NULL, xlim=c(0,120), ylim=c(50,100), yaxt="n", ann=FALSE, xaxt="n", bty="n")
  text(17.5,89, "Sequantial", pos=3)
  blue <- brewer.pal(5, "Blues")
  rdpu <- brewer.pal(5, "RdPu")
  ygb <- brewer.pal(5, "YlGnBu")
  text(30,83, "Blues", pos=4)
  text(30,73, "RdPu", pos=4)
  text(30,63, "YlGnBu", pos=4)
  for (i in seq(5)) {
    rect(i*5, 80, (i*5)+5, 86, col=blue[i], border=NA)
    rect(i*5, 70, (i*5)+5, 76, col=rdpu[i], border=NA)
    rect(i*5, 60, (i*5)+5, 66, col=ygb[i], border=NA)
  }
  text(57.5,89, "Diverging", pos=3)
  blue <- brewer.pal(5, "RdBu")
  rdpu <- brewer.pal(5, "PiYG")
  ygb <- brewer.pal(5, "BrBG")
  text(70,83, "RdBu", pos=4)
  text(70,73, "PiYG", pos=4)
  text(70,63, "BrBG", pos=4)
  for (i in seq(5)) {
    rect(40+(i*5), 80, (i*5)+45, 86, col=blue[i], border=NA)
    rect(40+(i*5), 70, (i*5)+45, 76, col=rdpu[i], border=NA)
    rect(40+(i*5), 60, (i*5)+45, 66, col=ygb[i], border=NA)
  }
  text(97.5,89, "Qualitative", pos=3)
  blue <- brewer.pal(5, "Set1")
  rdpu <- brewer.pal(5, "Set2")
  ygb <- brewer.pal(5, "Accent")
  text(110,83, "Set1", pos=4)
  text(110,73, "Set2", pos=4)
  text(110,63, "Accent", pos=4)
  for (i in seq(5)) {
    rect(80+(i*5), 80, (i*5)+85, 86, col=blue[i], border=NA)
    rect(80+(i*5), 70, (i*5)+85, 76, col=rdpu[i], border=NA)
    rect(80+(i*5), 60, (i*5)+85, 66, col=ygb[i], border=NA)
  }
  par(mar=c(5.1,4.1,4.1,2.1))
  dev.off()
}

##
## Color Wheel
##
if (runall) {
  my.shift <- function(x, y) {
    x[c(seq(y+1, length(x)), seq(1, y))]
  }
  my.num <- 120
  r.col <- sin(seq(0,pi, length.out=my.num))
  my.cols <- rgb(r.col, my.shift(r.col, my.num/3), my.shift(r.col, 2*(my.num/3)))
  pdf(getfile(19), width=4, height=4)
  par(mar=c(0,0,0,0))
  pie(rep(1, length(my.cols)), col = my.cols, border=NA, labels="", radius=1)
  par(mar=c(5.1,4.1,4.1,2.1))
  dev.off()
  
}

## 
## My Time Series mess
##
if (runall) {
  my.fw <- read.csv("data/3weeks.csv", header=T)
  
  my.fw2 <- aggregate(bytes ~ dh.seq, data=my.fw, FUN=mean)
#  my.fw2$seq <- seq_along(my.fw2$dh.seq)
  aa.breaks <- 144+seq(1,nrow(my.fw), by=nrow(my.fw)/21)
  aa.lab <- rep(c("S", "M", "T", "W", "T", "F", "S"), 3)
  bb.breaks <- nrow(my.fw2)/42 + seq(1, nrow(my.fw2), by=nrow(my.fw2)/21)


  aa <- ggplot(my.fw, aes(x=seq, y=bytes)) + geom_line(color="steelblue") + theme_bw() + 
    scale_y_continuous(labels=scale.filter, limits=c(0, max(my.fw$bytes))) + ggtitle("Basic Line Plot") +
    scale_x_continuous(labels=aa.lab, breaks=aa.breaks) + xlab("Day") + ylab("Bytes")
  print(aa)
  
  bb <- ggplot(my.fw2, aes(x=dh.seq, y=bytes)) + geom_line(color="steelblue") + theme_bw() + 
    scale_y_continuous(labels=scale.filter, limits=c(0, max(my.fw$bytes))) + ggtitle("One hour averages") +
    scale_x_continuous(labels=aa.lab, breaks=bb.breaks) + xlab("Day") + ylab("Bytes")
  
  
  cc <- ggplot(outfw, aes(x=seq, y=bytes)) + geom_point(alpha=2/3, size=1, color="steelblue") + 
    theme_bw() + ggtitle("Using Points") + 
    scale_y_continuous(labels=scale.filter, limits=c(0, max(my.fw$bytes))) +
    scale_x_continuous(labels=aa.lab, breaks=aa.breaks) + xlab("Day") + ylab("Bytes")
  

  pdf(getfile(20), width=9, height=7)
  grid.arrange(aa, bb, cc, ncol=1, clip=T)
  dev.off()
  
  #     geom_point(size=0.5, alpha=1/4, color="blue") + theme_bw() + 
  
  cc <- ggplot(outfw, aes(x=day, y=bytes)) + geom_jitter(alpha=1/2, size=1, color="steelblue", position = position_jitter(width = .3)) + 
    geom_boxplot(outlier.shape=NA, colour="gray40", fill="steelblue", alpha=1/5) + theme_bw() + scale_y_continuous(labels=scale.filter)
  scale_x_discrete() + geom_boxplot() + theme_bw() + scale_y_continuous(labels=scale.filter)
  
  ggplot(outfw, aes(x=day, y=bytes)) + geom_boxplot(outlier.shape = NA, alpha=0.5) + theme_bw()
  
  print(cc)
  pdf(getfile(20), width=9, height=7)
  grid.arrange(aa, bb, cc, ncol=1, clip=T)
  dev.off()
  
}

## bubble chart
wk <- fw[which(fw$type=="Network"), ]  # not log
myred <- brewer.pal(3, "Set2")[3]

gg <- ggplot(wk, aes(sessions, bytes, size=packets, color=type, fill=type))
gg <- gg + scale_color_brewer(palette="Set2") + xlab("Sessions") + ylab("Bytes")
gg <- gg + geom_point(alpha=1/3, shape=21, color="gray50", guide=F) + theme_bw()
gg <- gg + scale_size_continuous(name="Packet Count", range = c(1, 20), trans=log10_trans())
gg <- gg + scale_x_continuous(labels=scale.filter.nb)
gg <- gg + scale_y_continuous(labels=scale.filter, limits=c(0, max(wk$bytes)*1.1)) 
gg <- gg + theme_sample() + theme(legend.position="none")
gg <- gg + ggtitle("alpha = 1/3")

gg <- ggplot(wk, aes(sessions, bytes, size=packets, color=type, fill=type))
gg <- gg + xlab("Sessions") + ylab("Bytes")
gg <- gg + geom_point(alpha=1/3, shape=21, fill=myred, color="gray80", guide=F)
gg <- gg + theme_bw()
gg <- gg + scale_size_continuous(name="Packet Count", range = c(1, 20), trans=log10_trans())
gg <- gg + ggtitle("alpha = 1/3")
gg <- gg + scale_x_continuous(labels=scale.filter.nb)
gg <- gg + scale_y_continuous(labels=scale.filter, limits=c(0, max(wk$bytes)*1.1)) 
gg <- gg + theme_sample() + theme(legend.position="bottom", legend.title = element_text(colour="black", size=10))
bb <- gg

#print(gg)
#ggsave(getfile(13), gg, width=8, height=5)
gg <- ggplot(wk, aes(sessions, bytes, size=packets, color=type, fill=type))
#gg <- gg + scale_color_brewer(palette="Set2", guide=F)
gg <- gg + xlab("Sessions") + ylab("Bytes")
gg <- gg + geom_point(alpha=1, shape=21, fill=myred, color="gray80", guide=F)
gg <- gg + theme_bw()
gg <- gg + scale_size_continuous(name="Packet Count", breaks=c(1,10), range = c(1, 20), trans=log10_trans())
gg <- gg + ggtitle("alpha = 1")
gg <- gg + scale_x_continuous(labels=scale.filter.nb)
gg <- gg + scale_y_continuous(labels=scale.filter, limits=c(0, max(wk$bytes)*1.1)) 
gg <- gg + theme_sample() + theme(legend.position="bottom", legend.title = element_text(colour="black", size=10))
aa <- gg
#print(gg)
#ggsave(getfile(13), gg, width=8, height=5)
pdf(getfile(13), width=9, height=5)
grid.arrange(aa, bb, ncol=2, clip=T)
dev.off()

foo <- sapply(seq(-2, 12, by=0.2), dnorm, x=seq(10))
mfoo <- round(max(foo), 1)
plotme <- function(x) { 
  ff <- data.frame(y=foo[ ,x], x=seq_along(foo[ ,x]))
  gg <- ggplot(ff, aes(x, y)) + geom_bar(stat="identity") + 
        ylim(c(0,mfoo)) + theme_bw()
  ggsave(paste("movie/slide", x, ".png", sep=''), gg, width=6, height=4)
}
sapply(seq_along(foo[1, ]), plotme)
#plotme(foo[, 1], mfoo, frame)

## simulating FW data
jfw <- aggregate(bytes ~ hour, data=fw, FUN=sum)
jfw$jhour <- substr(jfw$hour, 1, 2)
jfw$jmin <- substr(jfw$hour, 3, 4)
jfw$seq <- seq_along(jfw$hour)
hourmod <- c(0.2, 0.2, 0.2, 0.2, 0.4, 0.6, 0.8, 1) # 1 to 8 am
hourmod <- c(hourmod, 1.1, 1.1, 1, .9, 1.1, 1, 1, 0.8, .5) # 9 to 5 pm
hourmod <- c(hourmod, .3, .5, .5, .4, .3, .2, .2)
jsd <- NULL
for(m in sprintf("%02d", seq(0, 55, by=5))) {
  jsd <- c(jsd, sd(jfw$bytes[jfw$jmin==m]))
}
jmean <- mean(jsd)
jsd <- sd(jsd)
nmean <- mean(jfw$bytes)

#      rval <- rnorm(1, mean=nmean, sd=rnorm(1, mean=jmean, sd=jsd))
#      if(is.nan(rval)) {
#        rval <- rnorm(1, mean=nmean, sd=rnorm(1, mean=jmean, sd=jsd))
#      }

set.seed(1492)
outfw <- NULL
for(d in seq(21)) {
  for(h in seq_along(hourmod)) {
    for(m in sprintf("%02d", seq(0, 55, by=5))) {
      rval <- rnorm(1, mean=mean(jfw$bytes[jfw$jmin==m]), sd=sd(jfw$bytes[jfw$jmin==m]))
      if (d==1 | d==8 | d==15) {
        rval <- rval * (min(hourmod)+(hourmod[h]*0.18))
      } else if (d==7 | d==14 | d==21) {
        rval <- rval * (min(hourmod)+(hourmod[h]*0.25))
      } else {
        rval <- rval * hourmod[h]
      }
      rval <- round(rval, 0)
      my.h <- sprintf("%02d", h)
      fwcmp <- data.frame(hour=paste(my.h, m, sep=""), bytes=rval, day=d, hour=my.h)
      if(is.null(outfw)) {
        outfw <- fwcmp
      } else {
        outfw <- rbind(outfw, fwcmp)
      }
    }
  }
}

outfw$seq <- seq_along(outfw$hour)
plot(outfw$seq, outfw$bytes, type="l")
plot(outfw$seq[outfw$day==3], outfw$bytes[outfw$day==3], type="l")
outfw$day <- factor(outfw$day)

outfw$dhour <- paste(sprintf("%02d", outfw$day), outfw$hour.1, sep="")


my.fw <- read.csv("data/3weeks.csv", header=T)

my.fw2 <- aggregate(bytes ~ day+hour, data=my.fw, FUN=mean)
my.fw2$seq <- seq_along(my.fw2$day)

aa <- ggplot(outfw, aes(x=seq, y=bytes)) + geom_line(color="steelblue") + theme_bw()+ scale_y_continuous(labels=scale.filter, limits=c(0, max(outfw$bytes))) + ggtitle("Basic Line Plot")

bb <- ggplot(outfw2, aes(x=seq, y=bytes)) + geom_line(color="steelblue") + theme_bw()+ scale_y_continuous(labels=scale.filter, limits=c(0, max(outfw$bytes))) + ggtitle("One hour averages")

cc <- ggplot(outfw, aes(x=seq, y=bytes)) + geom_point(alpha=1/2, size=1, color="steelblue") + 
  geom_point(size=0.5, alpha=1/4, color="blue") + theme_bw() + scale_y_continuous(labels=scale.filter, limits=c(0, max(outfw$bytes))) + ggtitle("Using Points")

cc <- ggplot(outfw, aes(x=day, y=bytes)) + geom_jitter(alpha=1/2, size=1, color="steelblue", position = position_jitter(width = .3)) + 
  geom_boxplot(outlier.shape=NA, colour="gray40", fill="steelblue", alpha=1/5) + theme_bw() + scale_y_continuous(labels=scale.filter)
  scale_x_discrete() + geom_boxplot() + theme_bw() + scale_y_continuous(labels=scale.filter)

ggplot(outfw, aes(x=day, y=bytes)) + geom_boxplot(outlier.shape = NA, alpha=0.5) + theme_bw()
  
print(cc)
pdf(getfile(20), width=9, height=7)
grid.arrange(aa, bb, cc, ncol=1, clip=T)
dev.off()

foo <- read.csv("~/Downloads/sess.out.out", sep="\t", header=T)

# random walk
incols <- seq(.5, 1, length.out=20)
grays <- rev(rgb(incols, incols, incols))
set.seed(1)
src <- matrix(c(rep(seq(-1, 1), 3), rep(seq(-1, 1), each=3)), ncol=2, byrow=T)
setup <- matrix(c(0, 0), ncol=2)
p2 <- matrix(c(0, 0), ncol=2)
p3 <- matrix(c(0, 0), ncol=2)
p4 <- matrix(c(0, 0), ncol=2)
par(mar=c(0,0,0,0))
for(i in seq(2000)) { 
  png(paste("movie/rw-", sprintf("%04d", i), ".png", sep=""))
  plot(setup[seq(max(1,i-19), i), ], type="p", col=grays, xlim=c(-70, 70), ylim=c(-70,70),  yaxt="n", ann=FALSE, xaxt="n", bty="n")
  setup <- rbind(setup, setup[nrow(setup), ] + src[sample(1:9, 1), ])
  points(setup[nrow(setup), 1], setup[nrow(setup), 2], type="p", pch=16, col="red")
  if (i > 200) {
    points(p2[seq(max(1,i-219), i-200), ], type="p", col=grays)
    p2 <- rbind(p2, p2[nrow(p2), ] + src[sample(1:9, 1), ])
    points(p2[nrow(p2), 1], p2[nrow(p2), 2], type="p", pch=16, col="blue")
  }
  if (i > 400) {
    points(p3[seq(max(1,i-419), i-400), ], type="p", col=grays)
    p3 <- rbind(p3, p3[nrow(p3), ] + src[sample(1:9, 1), ])
    points(p3[nrow(p3), 1], p3[nrow(p3), 2], type="p", pch=16, col="green")
  }
  if (i > 600) {
    points(p4[seq(max(1,i-619), i-600), ], type="p", col=grays)
    p4 <- rbind(p4, p4[nrow(p4), ] + src[sample(1:9, 1), ])
    points(p4[nrow(p4), 1], p4[nrow(p4), 2], type="p", pch=16, col="purple")
  }
  dev.off()
#  Sys.sleep(0.1)
}
  par(mar=c(5.1,4.1,4.1,2.1))
  