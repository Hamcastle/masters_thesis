rm(list=ls())
#Load needed libraries
library(lme4)
library(stargazer)

#Load the error data
error_data<-data.frame(read.csv("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_eccentricity/out/median_error_data.csv"))

#Load the 95% isocontour area stability data
stability_data<-data.frame(read.csv("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_eccentricity/out/gaze_isocontour_data.csv"))

#rename variables so things come out straight from stargazer
colnames(error_data)[12]<-"abs_blocknum"
colnames(error_data)[9]<-"eccentricity"
colnames(error_data)[11]<-"first_or_second_block_training"

#Fit the error data model
error_model<-lmer(log_median_error~abs_blocknum+eccentricity*as.factor(first_or_second_block_training)+(1+abs_blocknum|subjid),error_data)

#Fit the 95% stability data model
stability_model <- lmer(isocontour_area~abs_blocknum+eccentricity*as.factor(first_or_second_block_training)+(1+abs_blocknum|subjid),stability_data)

#Generate a table using stargazer
stargazer(error_model,stability_model,dep.var.labels=c("Accuracy (Log Pixels)","Stability (Pixels Squared)"),covariate.labels=c("Absolute Block Number","Eccentricity Condition","First or Second Block of Training","Eccentricity x First or Second Training Session"),no.space=TRUE,out="~/Dropbox/masters_document/figures/chapter_2/oculotrain_phase1_eccentricity_performance_model_output.tex")