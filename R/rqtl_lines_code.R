# plot of lines of code in R/qtl, over time

library(broman)
source("colors.R")
bgcolor <- "white"
fgcolor <- "black"
col_lab <- "slateblue"
# override the point colors
color2 <- broman::brocolors("crayons")[c("Cornflower", "Tickle Me Pink", "Sea Green")]

lines <- read.csv("../Data/lines_code_by_version.csv")
lines <- lines[nrow(lines):1,]
library(lubridate)
lines[,2] <- ymd(as.character(lines[,2]))

pdf("../Figs/rqtl_lines_code.pdf", width=11, height=5.5, pointsize=18)
par(mar=c(1.1, 5.1, 1.1, 0.1),las=1,fg=fgcolor,col=fgcolor,col.axis=fgcolor,col.lab=col_lab,
    bg=bgcolor,bty="n")

yat <- seq(0, 40000, by=5000)

yr <- 2000:2022
idea <- as.numeric(dmy("23 Feb 2000"))
R100 <- as.numeric(dmy("29 Feb 2000"))
svn <- as.numeric(dmy("16 Jan 2008"))
git <- as.numeric(dmy("12 Feb 2009"))
xaxis <- as.numeric(ymd(paste0(yr, "-1-1")))
xat <- (xaxis + as.numeric(ymd(paste0(yr-1, "-12-31"))))/2

grayplot(lines[,2], lines[,3], xlab="", ylab="", yat=yat, xat=NA,
         hlines=yat, pch=21, col="black", bg=color2[1], ylim=c(0, 40000),
         mgp.x=c(1.6, 0.4, 0), vlines=xat, yaxs="i", vlines.col="gray65",
         hlines.col=fgcolor, bgcolor="gray85",
         xlim=range(xaxis), xaxs="i", mgp.y=c(3.3, 0.4, 0))
#title(xlab="Year", col.lab=col_lab, cex.lab=1.7, mgp=c(2,0,0))
title(ylab="Lines of code", col.lab=col_lab, cex.lab=1.5, mgp=c(3.6,0,0))
for(i in 4:5)
  points(lines[,2], lines[,i], pch=21, col="black", bg=color2[i-2])

u <- par("usr")
for(i in 2:length(xaxis)) {
  col <- ifelse(i %% 2, "gray65", "gray85")
  h <- diff(u[3:4])*0.05
  start <- max(c(xaxis[i-1], u[1]))
  end <- min(c(xaxis[i], u[2]))
  rect(start, u[3], end, u[3]-h, xpd=TRUE,
       col=col, border=col, lend=1, ljoin=1)
  text((start + end)/2, u[3]-h/2, yr[i-1], col=fgcolor, xpd=TRUE, cex=0.6)
}
abline(h=0, col="black")

top <- u[3]+diff(u[3:4])*0.07
bot <- u[3]+diff(u[3:4])*0.01
txt <- u[3]+diff(u[3:4])*0.09
col <- rgb(58, 58, 144, maxColorValue=255)
arrows(idea,top,idea, bot, len=0.1, col=col, lwd=2)
arrows(svn, top, svn, bot, len=0.1, col=col, lwd=2)
arrows(git, top, git, bot, len=0.1, col=col, lwd=2)
text(idea, txt, "idea", adj=c(0, 0), col=col)
text(svn, txt, "svn", adj=c(0.5, 0), col=col)
text(git, txt, "git", adj=c(0.5, 0), col=col)

x <- max(lines[,2])
x2 <- ymd("2021-12-20")
text(c(x2,x2,x2), lines[nrow(lines),3:5] - 1800*c(1,-1,-1),
     c("R", "C", "doc"), col=col, adj=c(1, 0.5), cex=1)

box()
dev.off()
