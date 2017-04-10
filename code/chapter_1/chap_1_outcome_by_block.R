	rm(list=ls())
	#Load libraries
	library(ggplot2)
	library(scales)
	library(gridExtra)
	#Load the data for errors/stability
	figure_1_model_error_data<-read.csv("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_orientation/out/by_subject_median_error_data.csv")
	figure_1_model_stability_data<-read.csv("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_orientation/out/gaze_isocontour_data.csv")

	#Source the code for computing the means/SEs/CIs frames
	source("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_eccentricity/funs/general_support_functions/normDataWithin.R")
	source("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_eccentricity/funs/general_support_functions/summarySE.R")
	source("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_eccentricity/funs/general_support_functions/summarySEWithin.R")

	#Create an object for the summarized data
	summarized_error_data<-summarySEwithin(figure_1_model_error_data,measurevar="log_median_error",withinvars="abs_block_num",idvar="subject_id",na.rm=TRUE,conf.interval=.95)
	summarized_stability_data<-summarySEwithin(figure_1_model_stability_data,measurevar="isocontour_area",withinvars="abs_blocknum",idvar="subjid",na.rm=TRUE,conf.interval=.95)

	#Generate the figure for the error data
	figure_1_error_data_plot <- ggplot(summarized_error_data,aes(x=as.numeric(abs_block_num),y=log_median_error))
	figure_1_error_data_plot <- figure_1_error_data_plot+geom_line()+geom_point(shape=21,fill="white")+geom_errorbar(width=.1,aes(ymin=log_median_error-se,ymax=log_median_error+se))
	figure_1_error_data_plot <- figure_1_error_data_plot+geom_vline(xintercept=4.5,linetype=2)+labs(x="\nAbsolute Block Number",y="Accuracy (Log-pix)\n")
	figure_1_error_data_plot <- figure_1_error_data_plot+scale_x_continuous(limits=c(1,8),breaks=c(1:8))+theme_classic()
	figure_1_error_data_plot <- figure_1_error_data_plot + annotate("text",x=8,y=3.4,label="a",size=10)
	figure_1_error_data_plot <- figure_1_error_data_plot + scale_y_continuous(limits=c(2.8,3.6),breaks=c(2.8,3.0,3.2,3.4,3.6))

	#Generate the figure for the stability data
	figure_1_stability_data_plot <- ggplot(summarized_stability_data,aes(x=as.numeric(abs_blocknum),y=isocontour_area))
	figure_1_stability_data_plot <- figure_1_stability_data_plot+geom_line()+geom_point(shape=22,fill="white")+geom_errorbar(width=.1,aes(ymin=isocontour_area-se,ymax=isocontour_area+se))
	figure_1_stability_data_plot <- figure_1_stability_data_plot+geom_vline(xintercept=4.5,linetype=2)+labs(x="\nAbsolute Block Number",y="Stability (Pix^2)\n")
	figure_1_stability_data_plot <- figure_1_stability_data_plot+scale_x_continuous(limits=c(1,8),breaks=c(1:8))+theme_classic()
	figure_1_stability_data_plot <- figure_1_stability_data_plot+annotate("text",x=8,y=145000,label="b",size=10)
	figure_1_stability_data_plot <- figure_1_stability_data_plot+scale_y_continuous(limits=c(50000,175000),breaks=c(50000,75000,100000,125000,150000,175000))

	#Put the two plots together
	grid.arrange(figure_1_error_data_plot,figure_1_stability_data_plot)

	#Save the combined figure in the required format for VisRes
	ggsave("~/Dropbox/masters_document/figures/chapter_1/outcome_by_block.pdf",arrangeGrob(figure_1_error_data_plot,figure_1_stability_data_plot),units=c("mm"),width=120.65,height=120,dpi=1000)
