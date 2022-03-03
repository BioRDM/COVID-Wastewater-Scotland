# Install packages and load necessary libraries
install.packages("sgo")
install.packages("lubridate")
install.packages("tidyverse")
library(lubridate)
library(sgo)
library("tidyverse")

#************Making data_renamed.csv***************
Data = read.table("2022_02_14-RNA_Monitoring_Project_HB_Added.csv", header =TRUE, sep = ",")
as.data.frame(Data) -> Data
colnames(Data) <- c("Health_Board","Site","Date_collected","Date_analysed", "SW_sample_number","N1_description", "N1_Reported_value-gc_per_L","N1_Repl_1-gc_per_L","N1_Repl_2-gc_per_L","N1_Repl_3-gc_per_L","Calculated_mean","Standard_Deviation","Flow-L_per_day","Ammonia-mg_per_L","pH_value","Modelled_flow-L_per_day","Million_gene_copies_per_person_per_day","Analysis_lab")
Data$Date_collected<- dmy(Data$Date_collected) #Change the date format to YYYY-MM-DD
Data$Date_analysed<- dmy(Data$Date_analysed)   #Change the date format to YYYY-MM-DD
write.csv(Data,file="data_renamed.csv",quote = FALSE)


#************Converting Geo-Coordinates and making sampling_sites file************
Data1 = read.table("Sites_coordinates_full.csv", header =TRUE, sep = ",")
locs <- sgo_points(Data1, coords=c("Longitude_dd", "Latitude_dd"), epsg=27700)
Data_sgo_4326 <- sgo_bng_lonlat(locs, to=4326)
Data_4326 <- as.data.frame(Data_sgo_4326)
colnames(Data_4326) = c("Longitude_dd", "Latitude_dd", "Health_Board","Site")
Pop_data = read.table("Sites_Population.csv", header =TRUE, sep = ",")
Pop_data <- as.data.frame(Pop_data)
full_join(Pop_data, Data_4326, by = "Site") -> DF
select(DF,Site,Health_Board.x,Latitude_dd,Longitude_dd,Population,Population_band) -> DF1
colnames(DF1)[2] <- 'Health_Board'
write.csv(DF1,file="sampling_sites.csv")


#*************************Making data_full file********************
full_join(select(DF, Health_Board.x, Site, Longitude_dd, Latitude_dd,Population,Population_band), Data, by = "Site") -> DF2
select(DF2, Health_Board,Site,Latitude_dd,Longitude_dd,Population,Population_band,Date_collected,Date_analysed, SW_sample_number,N1_description,"N1_Reported_value-gc_per_L","N1_Repl_1-gc_per_L","N1_Repl_2-gc_per_L","N1_Repl_3-gc_per_L","Calculated_mean","Standard_Deviation","Flow-L_per_day","Ammonia-mg_per_L","pH_value","Modelled_flow-L_per_day","Million_gene_copies_per_person_per_day","Analysis_lab") -> data_full
write.csv(data_full,file="data_full.csv",quote = FALSE)


#********** Making Prevelance time series and normalized prevelance time series data files***********
Data2 = read.table("Sample1.csv", header =TRUE, sep = ",", row.names = 1,check.names = F) # Refer to ReadMe file for details generation of Sample1.csv
Data3 = read.table("Sample2.csv", header =TRUE, sep = ",", row.names = 1,check.names = F) # Refer to ReadMe file for details generation of Sample2.csv
Data2 <- as.data.frame(Data2)
Data3 <- as.data.frame(Data3)
Data2 = Data2[,order(colnames(Data2))] # Sorting by column names
Data3 = Data3[,order(colnames(Data3))] 
rownames_to_column(Data2, var = "Site") -> Data2
rownames_to_column(Data3, var = "Site") -> Data3
full_join(select(DF1, Health_Board, Site, Latitude_dd,Longitude_dd,Population,Population_band), Data2, by = "Site") -> DF3
full_join(select(DF1, Health_Board, Site, Latitude_dd,Longitude_dd,Population,Population_band), Data3, by = "Site") -> DF4
write.csv(DF3,file="prevalence_timeseries.csv",quote = FALSE)
write.csv(DF4,file="norm_prevalence_timeseries.csv",quote = FALSE)


#*********** Making Weekly Prevelance time series and Weekly normalized prevelance time series data files**********
Data5 = read.table("data_full.csv", header =TRUE, sep = ",")
# Extracting the Year month and week information from dates
date =as.Date(Data5$Date_collected, by="day")
Data5$week = sprintf("%02d", isoweek(date))
Data5$Year = year(date)
#Finding the average of normalized data for each week , grouped by Site, Year and Week
aggregate(Data5$N1_Reported_value.gc_per_L, by=list(Site=Data5$Site, Year= Data5$Year,Week = Data5$week), FUN=mean, na.rm=TRUE) ->MeanaggregateReported
aggregate(Data5$Million_gene_copies_per_person_per_day, by=list(Site=Data5$Site, Year= Data5$Year,Week = Data5$week), FUN=mean, na.rm=TRUE) ->Meanaggregatenormalized
write.csv(MeanaggregateReported,file="MeanaggregateReported.csv",quote = FALSE)
write.csv(Meanaggregatenormalized,file="Meanaggregatenormalized.csv",quote = FALSE)
Data6 = read.table("Sample3.csv", header =TRUE, sep = ",", row.names = 1, check.names = F) # Refer to ReadMe file for details generation of Sample3.csv
Data7 = read.table("Sample4.csv", header =TRUE, sep = ",", row.names = 1, check.names = F) # Refer to ReadMe file for details generation of Sample4.csv
Data6 <- as.data.frame(Data6)
Data7 <- as.data.frame(Data7)
Data6 = Data6[,order(colnames(Data6))] # Sorting by column names
Data7 = Data7[,order(colnames(Data7))]
rownames_to_column(Data6, var = "Site") -> Data6
rownames_to_column(Data7, var = "Site") -> Data7
full_join(select(DF1, Health_Board, Site, Latitude_dd,Longitude_dd,Population,Population_band), Data6, by = "Site") -> DF5
full_join(select(DF1, Health_Board, Site, Latitude_dd,Longitude_dd,Population,Population_band), Data7, by = "Site") -> DF6
write.csv(DF5,file="weekly_prevalence_timeseries.csv",quote = FALSE)
write.csv(DF6,file="weekly_norm_prevalence_timeseries.csv",quote = FALSE)
