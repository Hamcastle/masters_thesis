#Clear the workspace
rm(list=ls())

#Load libraries & such
library(R.matlab)
library(gdata)
library(dplyr)
library(NISTunits)
library(ggplot2)

#Load the data 
ring_figure_data<-read.csv("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_ring/out/median_error_data.csv")

#Filter out subject KS data -- obviously had some kind of error
ring_figure_data<-filter(ring_figure_data,subjid!="KS")

#Produce the plot
ring_noring_plot<-ggplot(ring_figure_data,aes(x=trial_num,y=median_error_degrees,color=feedback_no_feedback))+geom_smooth()
last_plot()+scale_x_continuous(breaks=c(1,10,20,30,40,50),limits=c(1,50))
last_plot()+theme_classic()
last_plot()+theme(legend.position=c(.75,.8)
	last_plot()+labs(x="Trial",y="Median Error (Degrees)")
last_plot()+scale_color_discrete(name="Condition",breaks=c("feedback","no_feedback"),labels=c("Feedback","No Feedback"))
last_plot()+labs(x="Trial",y="Target/Ring Error (Deg)")
last_plot()+theme(legend.position=c(.85,.85))


#Save the plot
ggsave(filename="chapter_3_figure_1.png",plot=last_plot(),path="~/Dropbox/masters_document/figures/chapter_3/",width=10.24,height=7.68,dpi=100)