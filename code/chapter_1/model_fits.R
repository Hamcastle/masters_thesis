rm(list=ls())
#Load needed libraries
library(lme4)
library(stargazer)

#Load the error data
error_data<-data.frame(read.csv("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_orientation/out/by_subject_median_error_data.csv"))

#Load the 95% isocontour area stability data
stability_95_data<-data.frame(read.csv("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_orientation/out/gaze_isocontour_data.csv"))

#rename variables so things come out straight from stargazer
colnames(error_data)[12]<-"abs_blocknum"
colnames(error_data)[3]<-"orientation"
colnames(error_data)[11]<-"first_or_second_block_training"

#Fit the error data model
error_model<-lmer(log_median_error~abs_blocknum+orientation*as.factor(first_or_second_block_training)+(1+abs_blocknum|subject_id),error_data)

#Fit the 95% stability data model
stability_model <- lmer(isocontour_area~abs_blocknum+orientation*as.factor(first_or_second_block_training)+(1+abs_blocknum|subjid),stability_95_data)

#Generate a table using stargazer
stargazer(error_model,stability_model,dep.var.labels=c("Accuracy (Log Pixels)","Stability (Pixels Squared)"),covariate.labels=c("Absolute Block Number","Orientation Condition","First or Second Session of Training","Orientation x First or Second Session of Training"),no.space=TRUE,out="~/Dropbox/masters_document/figures/chapter_1/oculotrain_phase1_orientation_performance_model_output.tex")