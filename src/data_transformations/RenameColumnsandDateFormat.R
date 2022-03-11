# Install packages and load necessary libraries. Please put in comments unless running for the intial time
install.packages("lubridate")
install.packages("tidyverse")
library("lubridate")
library("tidyverse")

#Making data_renamed.csv
Data = read.table("intermediate/2022_02_14-RNA_Monitoring_Project_HB_Added.csv", header =TRUE, sep = ",")
as.data.frame(Data) -> Data
colnames(Data) <- c("Health_Board","Site","Date_collected","Date_analysed", "SW_sample_number","N1_description", "N1_Reported_value-gc_per_L","N1_Repl_1-gc_per_L","N1_Repl_2-gc_per_L","N1_Repl_3-gc_per_L","Calculated_mean","Standard_Deviation","Flow-L_per_day","Ammonia-mg_per_L","pH_value","Modelled_flow-L_per_day","Million_gene_copies_per_person_per_day","Analysis_lab")
Data$Date_collected<- dmy(Data$Date_collected) #Change the date format to YYYY-MM-DD
Data$Date_analysed<- dmy(Data$Date_analysed)   #Change the date format to YYYY-MM-DD
write.csv(Data,file="out/SARS-Cov2_RNA_monitoring_ww_scotland_renamed.csv",quote = FALSE)
