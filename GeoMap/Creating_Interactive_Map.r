library(rgdal)
library(leaflet)
library(htmlwidgets)
Localities <- readOGR("/home/sbaby/Desktop/localities2016boundaries/Localities2016_MHW.shp")
proj4string(Localities) <- CRS("+init=epsg:27700") # tells it to be UK Grid system
myfile <- spTransform(Localities, CRS("+init=epsg:4326"))
myfile@data$area <- sapply(Localities@polygons, function(x) 1000*x@area)
pal <- colorQuantile(palette = "Blues",domain = myfile@data$area)
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
Map_Population <- map %>% setView(-3.475300, 55.89687, zoom = 8) %>% addPolygons(fillColor = ~pal(area),
                     fillOpacity = 0.8,
                     color = "#FF0000",
                     weight = 1,
                     popup = myfile$name) %>% addLegend(data= Data1,"bottomright",pal = pal1, values = Data1$Population,
                                                        title = "Population", opacity = 1)%>% addCircles(lng = Data1$lon,lat = Data1$lat, label = Data1$Site,weight =8,color = ~pal1(Data1$Population),opacity = 1) 
saveWidget(widget = Map_Population, file = "/home/sbaby/Desktop/Map_Population.html")                               
Data1[Data1$Site %in% c("Allanfearn","Helensburgh","Carbarns","Hamilton","Philipshill","Seafield","East Calder","Linlithgow","Shieldhall","Dalmuir","Paisley","Daldowie","Nigg","Peterhead","Kirkwall","Lerwick","Hatton","Forfar","Stirling","Falkirk","Alloa","Meadowhead","Stevenston","Linlithgow","Dunfermline","Levenmouth","Kirkaldy","Troqueer","Lockerbie","Galashiels","Hawick","Stornoway"), ] -> Selected_Sites                              
map <- leaflet(myfile) 
Map_Population1 <- map %>% setView(-3.475300, 55.89687, zoom = 10) %>% addPolygons(fillColor = ~pal(area),fillOpacity = 1,color = "#C0C0C0",weight = 1,label = myfile@data$name,labelOptions = labelOptions(noHide = F, textOnly = TRUE, style= list("font-family" = "Helvetica")))%>% addLegend(data= Data1,"bottomright",pal = pal1, values = Data1$Population,title = "Population", opacity = 1)%>% addCircles(lng = Data1$lon,lat = Data1$lat, label = Data1$Site,weight =8,color = ~pal1(Data1$Population),opacity = 1)%>% addLabelOnlyMarkers(lng = Selected_Sites$lon,lat = Selected_Sites$lat, label = Selected_Sites$Site,labelOptions = labelOptions(noHide = T, textOnly = TRUE,textsize = "12px", style = list("font-weight" = "bold","font-family" = "Helvetica")))                             
saveWidget(widget = Map_Population1, file = "/home/sbaby/Desktop/Map_Population_2.html")
Map_Population2<- map %>% addTiles() %>% setView(-3.475300, 55.89687, zoom = 10) %>% addPolygons(fillColor = ~pal(area),fillOpacity = 1,color = "#C0C0C0",weight = 1,label = myfile@data$name,labelOptions = labelOptions(noHide = F, textOnly = TRUE, style= list("font-family" = "Helvetica")))%>% addLegend(data= Data1,"bottomright",pal = pal1, values = Data1$Population,title = "Population", opacity = 1)%>% addCircles(lng = Data1$lon,lat = Data1$lat, label = Data1$Site,weight =8,color = ~pal1(Data1$Population),opacity = 1)%>% addLabelOnlyMarkers(lng = Selected_Sites$lon,lat = Selected_Sites$lat, label = Selected_Sites$Site,labelOptions = labelOptions(noHide = T, textOnly = TRUE,textsize = "12px", style = list("font-weight" = "bold","font-family" = "Helvetica")))                              
saveWidget(widget = Map_Population1, file = "/home/sbaby/Desktop/Map_Population_3.html")
