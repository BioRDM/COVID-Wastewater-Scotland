library(rgdal)
library(leaflet)
library(htmlwidgets)
Localities <- readOGR("/home/sbaby/Desktop/localities2016boundaries/Localities2016_MHW.shp")
proj4string(Localities) <- CRS("+init=epsg:27700") # tells it to be UK Grid system
myfile <- spTransform(Localities, CRS("+init=epsg:4326"))
Localities@data$area <- sapply(Localities@polygons, function(x) 1000*x@area)
pal <- colorQuantile(palette = "YlGnBu",domain = myfile@data$area)
Data = read.table("/home/sbaby/Desktop/Latest_data/Data_4326.csv", header =TRUE, sep = ",")
Data = as.data.frame(Data)
Data1 = read.table("/home/sbaby/Desktop/Virus_Levels.csv", header =TRUE, sep = ",")
Data1 = as.data.frame(Data1)
Data1$lon <- jitter(Data1$lon, factor = 20)
Data1$lat <- jitter(Data1$lat, factor = 20)
Map <- leaflet(data = myfile)%>%
addTiles() %>%
addPolygons(fillColor = ~pal(area),
fillOpacity = 0.8,
color = "#FF0000",
weight = 1,
popup = myfile$name)%>%
addLabelOnlyMarkers(data =Data,label = Data$Site.Name,labelOptions = labelOptions(noHide = T, textsize = "10px"))%>%
addLegend(data= Data1,"bottomright",pal = pal1, values = Data1$Viruslevels,
title = "Virus levels", opacity = 1)%>% addCircles(data =Data1,lng = Data1$lon,lat = Data1$lat,weight = 2, color = pal1(Data1$Viruslevels))
saveWidget(widget = Map, file = "/home/sbaby/Desktop/Map.html")
****************************Using Population**********************************
Data1 = read.table("/home/sbaby/Desktop/Latest_data/Map/MapPop.csv", header =TRUE, sep = ",")
Data1 = as.data.frame(Data1) 
pal1 <- colorQuantile(palette = "Dark2",domain = Data1$Population)
map <- leaflet(countries) %>% addTiles()                             
Map_Population <- map %>% addPolygons(fillColor = ~pal(area),
                     fillOpacity = 0.8,
                     color = "#FF0000",
                     weight = 1,
                     popup = myfile$name) %>% addLegend(data= Data1,"bottomright",pal = pal1, values = Data1$Population,
                                                        title = "Population", opacity = 1)%>% addCircles(lng = Data1$lon,lat = Data1$lat, label = Data1$Site,weight =10,color = ~pal1(Data1$Population),opacity = 1) 
saveWidget(widget = Map_Population, file = "/home/sbaby/Desktop/Map_Population.html")                               
                               
                               
