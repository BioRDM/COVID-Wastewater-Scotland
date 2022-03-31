# -------------------------------------------------------------------------------------
#
# Authors: Sumy V. Baby
#
# Scripts that adds detailed sites information into the data entries
#
# --------------------------------------------------------------------------------------


# Install packages and load necessary libraries. Please put it as comments unless running for the first time
#install.packages("lubridate")
#install.packages("tidyverse")

# Load the libraries
library("lubridate")
library("tidyverse")
Data = read.table("out/SARS-Cov2_RNA_monitoring_ww_scotland_renamed.csv", header =TRUE, sep = ",",check.names = F)
as.data.frame(Data) -> Data
Data1 = read.table("out/sampling_sites.csv", header =TRUE, sep = ",",check.names = F)
as.data.frame(Data1) -> Data1
full_join(select(Data1, Health_Board, Site,Latitude_dd,Longitude_dd,Population,Population_band), Data, by = "Site") -> DF2
select(DF2, Health_Board.x,Site,Latitude_dd,Longitude_dd,Population,Population_band,Date_collected,Date_analysed, SW_sample_number,N1_description,"N1_Reported_value-gc_per_L","N1_Repl_1-gc_per_L","N1_Repl_2-gc_per_L","N1_Repl_3-gc_per_L","Calculated_mean","Standard_Deviation","Flow-L_per_day","Ammonia-mg_per_L","pH_value","Modelled_flow-L_per_day","Million_gene_copies_per_person_per_day","Analysis_lab") -> data_full
colnames(data_full)[1] <- 'Health_Board'
write.csv(data_full,file="out/SARS-Cov2_RNA_monitoring_ww_scotland_full.csv",quote = F,row.names = FALSE)

