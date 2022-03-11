# Install packages. Please put it as comments unless you are running for the first time 
#install.packages("sgo")
#install.packages("lubridate")
#install.packages("tidyverse")

# Loading neccesary libraries
library("lubridate")
library("sgo")
library("tidyverse")

# Converting Geo-Coordinates and making sampling_sites file
Data1 = read.table("intermediate/Sites_Coordinates_Full.csv", header =TRUE, sep = ",")
locs <- sgo_points(Data1, coords=c("Longitude_dd", "Latitude_dd"), epsg=27700)
Data_sgo_4326 <- sgo_bng_lonlat(locs, to=4326)
Data_4326 <- as.data.frame(Data_sgo_4326)
colnames(Data_4326) = c("Longitude_dd", "Latitude_dd", "Health_Board","Site")
Pop_data = read.table("intermediate/Sites_Population_Full.csv", header =TRUE, sep = ",")
Pop_data <- as.data.frame(Pop_data)
full_join(Pop_data, Data_4326, by = "Site") -> DF
select(DF,Site,Health_Board.x,Latitude_dd,Longitude_dd,Population,Population_band) -> DF1
colnames(DF1)[2] <- 'Health_Board'
write.csv(DF1,file="out/sampling_sites.csv",quote =F)


