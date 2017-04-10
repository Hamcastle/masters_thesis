rm(list=ls())
#Libraries
library(dplyr)
set.seed(25)
#Load the data
error_t_test_data<-data.frame(read.csv("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_eccentricity/out/median_error_data.csv"))
stability_t_test_data<-data.frame(read.csv("~/Dropbox/neu_experiments/oculotrain_experiment_phase1_eccentricity/out/gaze_isocontour_data.csv"))

#Select out the data for the last block in the first training session and the first block in the second
error_abs_block_1_data<-filter(error_t_test_data,abs_block_num==1)
error_abs_block_3_data<-filter(error_t_test_data,abs_block_num==3)
#Now for the stability data
stability_abs_block_1_data<-filter(stability_t_test_data,abs_blocknum==1)
stability_abs_block_3_data<-filter(stability_t_test_data,abs_blocknum==3)

#Run the t-test
t.test(error_abs_block_1_data$log_median_error,error_abs_block_3_data$log_median_error,paired=TRUE)
t.test(stability_abs_block_1_data$isocontour_area,stability_abs_block_3_data$isocontour_area,paired=TRUE)