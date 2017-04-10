rm(list=ls())
#Load libraries & such
library(plyr)
library(dplyr)
library(ggplot2)
#Source the within subjects means/CI generation code
source('~/Dropbox/neu_experiments/oculotrain_experiment_phase1_eccentricity/funs/general_support_functions/sourceDir.R') 
sourceDir('~/Dropbox/neu_experiments/oculotrain_experiment_phase1_eccentricity/funs/general_support_functions/')

#Load the data
error_t_test_data<-data.frame(read.csv("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_eccentricity/out/median_error_data.csv"))
stability_t_test_data<-data.frame(read.csv("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_eccentricity/out/gaze_isocontour_data.csv"))

#Filter it
abs_block_num_filter<-c(1,3)
filtered_error_data<-filter(error_t_test_data,abs_block_num %in% abs_block_num_filter)
filtered_stability_data<-filter(stability_t_test_data, abs_blocknum %in% abs_block_num_filter)

#Create variables that are standardized versions (effectively z-scores here) of the real outcome measure values
filtered_error_data$error_z_scores<-scale(filtered_error_data$log_median_error,center=TRUE,scale=TRUE)
filtered_stability_data$stability_z_scores<-scale(filtered_stability_data$isocontour_area,center=TRUE,scale=TRUE)

#Compress and summarize the data to get back the mean/CI data for each outcome measure data frame
summary_error_data<-summarySEwithin(filtered_error_data,measurevar="error_z_scores",withinvars="abs_block_num",idvar="subjid",conf.interval=.95)
summary_stability_data<-summarySEwithin(filtered_stability_data,measurevar="stability_z_scores",withinvars="abs_blocknum",idvar="subjid",conf.interval=.95)

#Make the plot
#start with a bare call to ggplot
color_for_legend<-c("Accuracy"="#f04546","Stability"="#3591d1")
t_test_plot<-ggplot()
#First the error data
t_test_plot<-t_test_plot+geom_point(data=summary_error_data,aes(x=abs_block_num,y=error_z_scores,group=abs_block_num,color="Accuracy"))
t_test_plot<-t_test_plot+geom_line(data=summary_error_data,aes(x=abs_block_num,y=error_z_scores,group=1,color="Accuracy"))
t_test_plot<-t_test_plot+geom_errorbar(data=summary_error_data,aes(x=abs_block_num,ymin=error_z_scores-ci,ymax=error_z_scores+ci,color="Accuracy"))

#Now the stability data @ 95% isocontour
t_test_plot<-t_test_plot+geom_point(data=summary_stability_data,aes(x=abs_blocknum,y=stability_z_scores,group=abs_blocknum,color="Stability"))
t_test_plot<-t_test_plot+geom_line(data=summary_stability_data,aes(x=abs_blocknum,y=stability_z_scores,group=1,color="Stability"))
t_test_plot<-t_test_plot+geom_errorbar(data=summary_stability_data,aes(x=abs_blocknum,ymin=stability_z_scores-ci,ymax=stability_z_scores+ci,color="Stability"))

#Clean up the formatting
t_test_plot<-t_test_plot+labs(x="Training Block",y="Performance (Z-Scores)")
t_test_plot<-t_test_plot+theme_classic()

#Add a legend
t_test_plot<-t_test_plot+scale_color_manual(name="Outcome Measure",values=color_for_legend)

#Save the figure
ggsave(t_test_plot,file='~/Dropbox/neu_experiments/oculotrain_experiment_phase1_orientation/figs/paired_t_results.pdf',units=c("mm"),width=120.65,height=100,dpi=1000)