rm(list=ls())

#Load libraries & such
library(ggplot2)
library(reshape2)
library(MASS)
library(ks)
source("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_orientation/funs/getLevel.R")

#Generate some random scatterplot data
x_data<-jitter(runif(1800,-2,2),amount=1.31)
y_data<-jitter(runif(1800,-2,2),amount=3.75)
sim_data<-data.frame(x_data,y_data)
prl_targ_x<-c(-7)
prl_targ_y<-c(0)

#Get the 95% isocontour
L95<-getLevel(x_data,y_data,0.95)
kk <- MASS::kde2d(x_data, y_data)
dimnames(kk$z) <- list(kk$x, kk$y)
dc <- melt(kk$z)

#Set up the plot
outcomes_plot <- ggplot(dc, aes(x=Var1, y=Var2))+geom_contour(aes(z=value), breaks=L95, color="green4",size=1.25)+geom_point(data=sim_data,aes(x=x_data,y=y_data,z=0),color="yellow3")+theme_classic()
outcomes_plot <- outcomes_plot+scale_x_continuous(breaks=-8:8,labels=-8:8)
outcomes_plot <- outcomes_plot+scale_y_continuous(breaks=-8:8,labels=-8:8)
outcomes_plot <- outcomes_plot+theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank(),panel.border=element_blank())
outcomes_plot <- outcomes_plot+theme(legend.position="none")
outcomes_plot <- outcomes_plot+labs(x="X",y="Y")
outcomes_plot <- outcomes_plot+geom_point(aes(x=prl_targ_x,y=prl_targ_y,color="red",size=5))
outcomes_plot <- outcomes_plot+annotate("text",x=0,y=-1,label="Outcome 2:\n95% Isocontour Area ('Stability')",color="black")
outcomes_plot <- outcomes_plot+annotate("text",x=-5,y=2.5,label="Outcome 1:\nDistance Between\n Fixation Centroid and\npPRL Target ('Accuracy')")
outcomes_plot <- outcomes_plot+geom_segment(aes(x=-7,y=0,xend=0,yend=0),color="blue")
ggsave(outcomes_plot,file="outcomes_figure.pdf",path="~/Dropbox/masters_document/figures/chapter_1",units=c("mm"),width=120.65,height=100,dpi=1000)