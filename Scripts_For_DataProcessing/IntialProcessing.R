# Install packages and load necessary libraries
install.packages("sgo")
install.packages("lubridate")
install.packages("tidyverse")
library(lubridate)
library(sgo)
library("tidyverse")

Data = read.table("2022_02_14-RNA_Monitoring_Project_HB_Added.csv", header =TRUE, sep = ",")
as.data.frame(Data) -> Data
colnames(Data) <- c("Health_Board","Site","Date_collected","Date_analysed", "SW_sample_number","N1_description", "N1_Reported_value-gc_per_L","N1_Repl_1-gc_per_L","N1_Repl_2-gc_per_L","N1_Repl_3-gc_per_L","Calculated_mean","Standard_Deviation","Flow-L_per_day","Ammonia-mg_per_L","pH_value","Modelled_flow-L_per_day","Million_gene_copies_per_person_per_day","Analysis_lab")
Data$Date_collected<- dmy(Data$Date_collected) #Change the date format to YYYY-MM-DD
Data$Date_analysed<- dmy(Data$Date_analysed)   #Change the date format to YYYY-MM-DD
write.csv(Data,file="data_renamed.csv",quote = FALSE)

#Converting Coordinates
Data1 = read.table("Sites_coordinates_full.csv", header =TRUE, sep = ",")
locs <- sgo_points(Data1, coords=c("Longitude_dd", "Latitude_dd"), epsg=27700)
Data_sgo_4326 <- sgo_bng_lonlat(locs, to=4326)
Data_4326 <- as.data.frame(Data_sgo_4326)
colnames(Data_4326) = c("Longitude_dd", "Latitude_dd", "Health_Board","Site")
write.csv(Data_4326,file="sampling_sites.csv")


# Making Full data file
full_join(Data, Data_4326, by = "Site") -> Df
select(Df, Health_Board.x,Site,Longitude_dd,Latitude_dd,Date_collected,Date_analysed, SW_sample_number,N1_description,"N1_Reported_value-gc_per_L","N1_Repl_1-gc_per_L","N1_Repl_2-gc_per_L","N1_Repl_3-gc_per_L","Calculated_mean","Standard_Deviation","Flow-L_per_day","Ammonia-mg_per_L","pH_value","Modelled_flow-L_per_day","Million_gene_copies_per_person_per_day","Analysis_lab") -> data_full
colnames(data_full)[1] <- 'Health_Board'
write.csv(data_full,file="data_full.csv",quote = FALSE)

# Making Prevelance data files
 Data2 = read.table("Sample1.csv", header =TRUE, sep = ",", row.names = 1) # Refer to ReadMe file
 Data3 = read.table("Sample2.csv", header =TRUE, sep = ",", row.names = 1)
 Data2 = as.matrix(Data2)
 Data3 = as.matrix(Data3)
 Data2 = Data2[,order(colnames(Data2))] # Sorting by column names
 Data3 = Data3[,order(colnames(Data3))]
 Data2 <- as.data.frame(Data2)
 Data3 <- as.data.frame(Data3)
rownames_to_column(Data2, var = "Site") -> Data2
rownames_to_column(Data3, var = "Site") -> Data3
inner_join(select(Data_4326, Health_Board, Site, Longitude_dd, Latitude_dd), Data2, by = "Site") -> DF1
inner_join(select(Data_4326, Health_Board, Site, Longitude_dd, Latitude_dd), Data3, by = "Site") -> DF2
write.csv(DF1,file="prevalence_timeseries.csv",quote = FALSE)
write.csv(DF2,file="norm_prevalence_timeseries.csv",quote = FALSE)
