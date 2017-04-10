rm(list=ls())
#Load needed libraries
library(lme4)
library(dplyr)
library(stargazer)

#Read in the data for both outcome types
error_data<-read.csv("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_ring/out/median_error_data.csv")
stability_data<-read.csv("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_ring/out/gaze_isocontour_data.csv")

#Filter KS's data out
error_data<-filter(error_data,subjid!="KS")
stability_data<-filter(stability_data,subjid!="KS")

#Rename feedback condition variable for the error data
colnames(error_data)[8]<-"condition"

#Fit the error data model
error_model<-lmer(log_median_error~trial_num+condition+(1+trial_num|subjid),error_data)

#Fit the 95% stability data model
stability_model <- lmer(isocontour_area~trial_num+condition+(1+trial_num|subjid),stability_data)

#Create a table for the model fits
stargazer(error_model,stability_model,dep.var.labels=c("Accuracy (Log Pixels)","Stability (Pixels Squared)"),covariate.labels=c("Trial","Feedback Condition"),no.space=TRUE,out="~/Dropbox/masters_document/figures/chapter_3/oculotrain_phase1_ring_performance_model_output.tex")