install.packages("jqr")
install.packages("geojson")
install.packages("geojsonio")
library("jqr")
library("geojson")
library(geojsonio)
spdf <- geojson_read("https://sphere.waterpathogens.org/sites/default/files/uploaded_resources/sepa_samples_202201.geojson",  what = "sp")
Data <- spdf@data
coords <- as.dataframe(spdf@coords)
Data$Longitude <- coords$coords.x1
Data$Latitude <- coords$coords.x2
(Data1<- st_as_sf(Data, coords = c("Longitude", "Latitude"),crs = 4326, agr = "constant"))
Data2 <- cbind(Data1, st_coordinates(st_centroid(Data1)))
plot <- ggplot(data = world) + geom_sf(aes(fill = pop_est)) + geom_text(data = Data2, aes(X, Y, label = location_name), size = .5) + coord_sf(xlim = c(-6.38848, -1.14524), ylim = c(54.93339, 60.15180), expand = TRUE) + theme(panel.grid.major = element_line(color = gray(0.5), linetype = "dashed",size = 0.5), panel.background = element_rect(fill = "aliceblue")) + xlab("Longitude") + ylab("Latitude")
plot + ggtitle("Map of Sites") + theme(plot.title = element_text(color="black", size=10,hjust = .5, face="bold"))
