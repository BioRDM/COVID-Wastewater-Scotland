install.packages("sgo")
library(sgo)

Data = read.table("site-location-coordinates-LScorza.csv", header =TRUE, sep = ",")
locs <- sgo_points(Data, coords=c("Long", "Lat"), epsg=27700)
Data_sgo_4326 <- sgo_bng_lonlat(locs, to=4326)
Data_4326 <- as.data.frame(Data_sgo_4326)
colnames(Data_4326) = c("Longitude_dd", "Latitude_dd", "Health_Board","Site")
write.csv(Data_4326,file="sampling_sites.csv")
