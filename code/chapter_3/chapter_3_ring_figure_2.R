#Clear the workspace
rm(list=ls())

#Load libraries & such
library(R.matlab)
library(gdata)
library(dplyr)
library(NISTunits)
library(ggplot2)
library(data.table)

#Source support functions
source('~/Dropbox/neu_experiments/oculotrain_experiment_phase1_eccentricity/funs/general_support_functions/sourceDir.R') 
sourceDir('~/Dropbox/neu_experiments/oculotrain_experiment_phase1_eccentricity/funs/general_support_functions/')

#Get a list of available .mat data files
data_file_list<-list.files("/Users/dylanrose/Dropbox/neu_experiments/oculotrain_experiment_phase1_ring/data/periphery_feedback_nofeedback/text_data_files/",full.names=TRUE)
#Gaze data bcea data frame
bcea_gaze_position_data<-list()

#Create a variable documenting which subjects were in which condition
feedback_subjects <- c("AK")
nofeedback_subjects <- c("KS","CA","SC")

#Load data from each file in a loop, grab subject metadata, take the median value
for (i in 1:length(data_file_list)){
  file_name<-data_file_list[i]
  file_name_split<-unlist(strsplit(file_name,"_"))
  subjid<-file_name_split[10]
  block_num<-as.numeric(file_name_split[18])
  trial_num<-as.numeric(substr(file_name_split[20],1,2))
  gaze_data<-fread(file_name)
  setnames(gaze_data,c("horizontal.gazeposition","vertical.gazeposition"))
  gaze_data<-filter(gaze_data,horizontal.gazeposition > 0,vertical.gazeposition > 0)
  trial_bcea<-bcea(gaze_data$horizontal.gazeposition,gaze_data$vertical.gazeposition)


  #If statement to label subject's condition
  if (is.element(subjid,feedback_subjects)){
    feedback_no_feedback<-"feedback"
  } else{
    feedback_no_feedback<-"no_feedback"
  }

  output<-cbind.data.frame(subjid,block_num,trial_num,trial_bcea,feedback_no_feedback)
  bcea_gaze_position_data[[i]]<-output
}

#Work with this data table from here forward
processed_bcea_data<-rbindlist(bcea_gaze_position_data)
processed_bcea_data<-as.data.frame(processed_bcea_data)

#Filter KS' data
processed_bcea_data<-filter(processed_bcea_data,subjid!="KS")

#Start assembling the plot
ring_expt_bcea_plot<-ggplot(processed_bcea_data,aes(x=trial_num,y=trial_bcea,color=feedback_no_feedback))+geom_smooth()
last_plot()+scale_x_continuous(breaks=c(1,10,20,30,40,50),limits=c(1,50))
last_plot()+theme_classic()
last_plot()+theme(legend.position=c(.75,.8)
  last_plot()+theme(legend.position=c(.85,.85))
last_plot()+labs(x="Trial",y="Mean BCEA (Pix^2)")
last_plot()+scale_color_discrete(name="Condition",breaks=c("feedback","no_feedback"),labels=c("Feedback","No Feedback"))
last_plot()+theme(legend.position=c(.85,.85))


ggsave(filename="chapter_3_figure_2.png",plot=last_plot(),path="~/Dropbox/masters_document/figures/chapter_3/",width=10.24,height=7.68,dpi=100)


