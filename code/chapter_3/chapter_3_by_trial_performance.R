	rm(list=ls())
	#Load libraries
	library(ggplot2)
	library(scales)
	library(gridExtra)
	#Load the data for errors/stability
	error_data<-read.csv("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_ring/out/median_error_data.csv")
	stability_data<-read.csv("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_ring/out/gaze_isocontour_data.csv")

	#Filter KS's data out
	error_data<-filter(error_data,subjid!="KS")
	stability_data<-filter(stability_data,subjid!="KS")

	#Source the code for computing the means/SEs/CIs frames
	source("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_eccentricity/funs/general_support_functions/normDataWithin.R")
	source("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_eccentricity/funs/general_support_functions/summarySE.R")
	source("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_eccentricity/funs/general_support_functions/summarySEWithin.R")

	#Plot the error data
	error_plot<-ggplot(error_data,aes(x=trial_num,y=log_median_error,color=feedback_no_feedback))+geom_smooth()
	error_plot<-error_plot+theme_classic()
	error_plot<-error_plot+labs(x="Trial Number",y="Accuracy (Log-pix)")
	error_plot<-error_plot+annotate("text",x=45,y=4.25,label="a",size=10)
	error_plot<-error_plot+scale_color_discrete(name="Condition",labels=c("Feedback","No Feedback"))

	#Plot the stability data
	stability_plot<-ggplot(stability_data,aes(x=trial_num,y=isocontour_area,color=condition))+geom_smooth()
	stability_plot<-stability_plot+theme_classic()
	stability_plot<-stability_plot+labs(x="Trial Number",y="Stability (Pix^2)")
	stability_plot<-stability_plot+annotate("text",x=45,y=550000,label="b",size=10)
	stability_plot<-stability_plot+scale_color_discrete(name="Condition",labels=c("Feedback","No Feedback"))

	#Put the two plots together
	grid.arrange(error_plot,stability_plot)

	#Save the combined figure in the required format for VisRes
	ggsave("~/Dropbox/masters_document/figures/chapter_3/outcome_by_trial.pdf",arrangeGrob(error_plot,stability_plot),units=c("mm"),width=120.65,height=100,dpi=1000)