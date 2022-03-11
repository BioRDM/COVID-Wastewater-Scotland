# Install packages and load necessary libraries. Please put it as comments unless running for the first time
install.packages("tidyr")
install.packages("lubridate")
install.packages("tidyverse")

# Load libraries
library(lubridate)
library(tidyverse)
library(tidyr)

#*********** Making Prevelance time series and normalized prevelance time series data files**********

Data1 = read.table("out/sampling_sites.csv", header =TRUE, sep = ",",check.names = F)
as.data.frame(Data1) -> Data1
Data2 = read.table("intermediate/Sample1.csv", header =TRUE, sep = ",", row.names = 1,check.names = F) # Refer to ReadMe file for details generation of Sample1.csv
Data3 = read.table("intermediate/Sample2.csv", header =TRUE, sep = ",", row.names = 1,check.names = F) # Refer to ReadMe file for details generation of Sample2.csv
Data2 <- as.data.frame(Data2)
Data3 <- as.data.frame(Data3)
Data2 = Data2[,order(colnames(Data2))] # Sorting by column names
Data3 = Data3[,order(colnames(Data3))]
rownames_to_column(Data2, var = "Site") -> Data2
rownames_to_column(Data3, var = "Site") -> Data3
full_join(select(Data1, Health_Board, Site, Latitude_dd,Longitude_dd,Population,Population_band),Data2, by = "Site") -> DF3
full_join(select(Data1, Health_Board, Site, Latitude_dd,Longitude_dd,Population,Population_band),Data3, by = "Site") -> DF4
write.csv(DF3,file="out/prevalence_timeseries.csv",quote = FALSE)
write.csv(DF4,file="out/norm_prevalence_timeseries.csv",quote = FALSE)

#*********** Making Weekly Prevelance time series and Weekly normalized prevelance time series data files**********

Data5 = read.table("out/SARS-Cov2_RNA_monitoring_ww_scotland_full.csv", header =TRUE, sep = ",")
# Extracting the Year month and week information from dates
date =as.Date(Data5$Date_collected, by="day")
Data5$week = sprintf("%02d", isoweek(date))
Data5$Year = year(date)

# Finding the average of normalized data for each week , grouped by Site, Year and Week
aggregate(Data5$N1_Reported_value.gc_per_L, by=list(Site=Data5$Site, Year= Data5$Year,Week = Data5$week), FUN=mean, na.rm=TRUE) ->MeanaggregateReported
aggregate(Data5$Million_gene_copies_per_person_per_day, by=list(Site=Data5$Site, Year= Data5$Year,Week = Data5$week), FUN=mean, na.rm=TRUE) ->Meanaggregatenormalized
MeanaggregateReported$"Year-Week" <- paste(MeanaggregateReported$Year,MeanaggregateReported$Week,sep = "-")
MeanaggregateReported<- select(MeanaggregateReported, Site,"Year-Week",x)

# Converting to wider table format 
MeanaggregateReported.wide <- pivot_wider(MeanaggregateReported, names_from = "Year-Week", values_from = x)              
column_to_rownames(MeanaggregateReported.wide, var = "Site") -> MeanaggregateReported.wide
Data6 = MeanaggregateReported.wide[,order(colnames(MeanaggregateReported.wide))]
Meanaggregatenormalized$"Year-Week" <- paste(Meanaggregatenormalized$Year,Meanaggregatenormalized$Week,sep = "-")
Meanaggregatenormalized<- select(Meanaggregatenormalized, Site,"Year-Week",x)
# Converting to wider table format 
Meanaggregatenormalized.wide <- pivot_wider(Meanaggregatenormalized, names_from = "Year-Week", values_from = x)              
column_to_rownames(Meanaggregatenormalized.wide, var = "Site") -> Meanaggregatenormalized.wide
Data7 = Meanaggregatenormalized.wide[,order(colnames(Meanaggregatenormalized.wide))]
rownames_to_column(Data6, var = "Site") -> Data6
rownames_to_column(Data7, var = "Site") -> Data7
full_join(select(Data1, Health_Board, Site, Latitude_dd,Longitude_dd,Population,Population_band),Data6, by = "Site") -> DF6
full_join(select(Data1, Health_Board, Site, Latitude_dd,Longitude_dd,Population,Population_band),Data7, by = "Site") -> DF7
write.csv(DF6,file="out/weekly_prevalence_timeseries.csv",quote = FALSE)
write.csv(DF7,file="out/weekly_norm_prevalence_timeseries.csv",quote = FALSE)

select(DF7,Site,"2021-29") -> VirusLevel #Extract Virus levels for 3rd week of July
full_join(select(Data1,Site, Latitude_dd,Longitude_dd),VirusLevel, by = "Site") -> DF8
colnames(DF8)[4]<- 'VirusLevels'
write.csv(DF8,file="out/Viruslevels.csv",quote = FALSE)

