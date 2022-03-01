library(rgdal)
library(leaflet)
library(htmlwidgets)
Localities <- readOGR("localities2016boundaries/Localities2016_MHW.shp") # Read the shape file 
proj4string(Localities) <- CRS("+init=epsg:27700") # tells it to be UK Grid system
myfile <- spTransform(Localities, CRS("+init=epsg:4326"))
myfile@data$area <- sapply(myfile@polygons, function(x) 1000*x@area) # generarate a column area by using function. You can also use Shape_Area attribute in creating addPolygons
pal <- colorQuantile(palette = "Blues",domain = myfile@data$area) # Select the color for the polygon area
map <- leaflet(data = myfile) # Define the  map file and polygon areas from the shape file

********************Creating map frpm Virus levells on 4rth week of July 2021 **************************
                           
 Data1 = read.table("MapVirus.csv", header =TRUE, sep = ",") #Read a file with virus levels ,locations and Site name
 Data1 = as.data.frame(Data1)
                           
 # Filter the selected sites
 Data1[Data1$Site %in% c("Allanfearn","Helensburgh","Carbarns","Hamilton","Philipshill","Seafield","East Calder","Linlithgow","Shieldhall","Dalmuir","Paisley","Daldowie","Nigg","Peterhead","Kirkwall","Lerwick","Hatton","Forfar","Stirling","Falkirk","Alloa","Meadowhead","Stevenston","Linlithgow","Dunfermline","Levenmouth","Kirkcaldy","Troqueer","Lockerbie","Galashiels","Hawick","Stornoway", "Kirkcaldy"),] -> Selected_Sites                                                 
 
                           
                           
 # Add a function for decreasing legend 
  addLegend_decreasing <- function (map, position = c("topright", "bottomright", "bottomleft","topleft"),
                                  pal, values, na.label = "NA", bins = 7, colors, 
                                  opacity = 0.5, labels = NULL, labFormat = labelFormat(), 
                                  title = NULL, className = "info legend", layerId = NULL, 
                                  group = NULL, data = getMapData(map), decreasing = FALSE) {
  
        position <- match.arg(position)
        type <- "unknown"
        na.color <- NULL
        extra <- NULL
        if (!missing(pal)) {
            if (!missing(colors)) 
                stop("You must provide either 'pal' or 'colors' (not both)")
            if (missing(title) && inherits(values, "formula")) 
                title <- deparse(values[[2]])
            values <- evalFormula(values, data)
            type <- attr(pal, "colorType", exact = TRUE)
            args <- attr(pal, "colorArgs", exact = TRUE)
            na.color <- args$na.color
            if (!is.null(na.color) && col2rgb(na.color, alpha = TRUE)[[4]] == 
                    0) {
                na.color <- NULL
            }
            if (type != "numeric" && !missing(bins)) 
                warning("'bins' is ignored because the palette type is not numeric")
            if (type == "numeric") {
                cuts <- if (length(bins) == 1) 
                    pretty(values, bins)
                else bins   
                if (length(bins) > 2) 
                    if (!all(abs(diff(bins, differences = 2)) <= 
                                     sqrt(.Machine$double.eps))) 
                        stop("The vector of breaks 'bins' must be equally spaced")
                n <- length(cuts)
                r <- range(values, na.rm = TRUE)
                cuts <- cuts[cuts >= r[1] & cuts <= r[2]]
                n <- length(cuts)
                p <- (cuts - r[1])/(r[2] - r[1])
                extra <- list(p_1 = p[1], p_n = p[n])
                p <- c("", paste0(100 * p, "%"), "")
                if (decreasing == TRUE){
                    colors <- pal(rev(c(r[1], cuts, r[2])))
                    labels <- rev(labFormat(type = "numeric", cuts))
                }else{
                    colors <- pal(c(r[1], cuts, r[2]))
                    labels <- rev(labFormat(type = "numeric", cuts))
                }
                colors <- paste(colors, p, sep = " ", collapse = ", ")
            }
            else if (type == "bin") {
                cuts <- args$bins
                n <- length(cuts)
                mids <- (cuts[-1] + cuts[-n])/2
                if (decreasing == TRUE){
                    colors <- pal(rev(mids))
                    labels <- rev(labFormat(type = "bin", cuts))
                }else{
                    colors <- pal(mids)
                    labels <- labFormat(type = "bin", cuts)
                }
            }
            else if (type == "quantile") {
                p <- args$probs
                n <- length(p)
                cuts <- quantile(values, probs = p, na.rm = TRUE)
                mids <- quantile(values, probs = (p[-1] + p[-n])/2, na.rm = TRUE)
                if (decreasing == TRUE){
                    colors <- pal(rev(mids))
                    labels <- rev(labFormat(type = "quantile", cuts, p))
                }else{
                    colors <- pal(mids)
                    labels <- labFormat(type = "quantile", cuts, p)
                }
            }
            else if (type == "factor") {
                v <- sort(unique(na.omit(values)))
                colors <- pal(v)
                labels <- labFormat(type = "factor", v)
                if (decreasing == TRUE){
                    colors <- pal(rev(v))
                    labels <- rev(labFormat(type = "factor", v))
                }else{
                    colors <- pal(v)
                    labels <- labFormat(type = "factor", v)
                }
            }
            else stop("Palette function not supported")
            if (!any(is.na(values))) 
                na.color <- NULL
        }
        else {
            if (length(colors) != length(labels)) 
                stop("'colors' and 'labels' must be of the same length")
        }
        legend <- list(colors = I(unname(colors)), labels = I(unname(labels)), 
                                     na_color = na.color, na_label = na.label, opacity = opacity, 
                                     position = position, type = type, title = title, extra = extra, 
                                     layerId = layerId, className = className, group = group)
        invokeMethod(map, data, "addLegend", legend)
        } 
                           
                        
  # Circle markers only for selected sites 
 labels=c("Negative", "Positive") # Assign labels
 pal1 <- colorNumeric(palette = c("yellow","dark orange","blue"),domain = Selected_Sites$Virus.levels)                          
 Map_Virus<- map %>% addTiles() %>% setView(-3.475300, 55.89687, zoom = 10) %>% addPolygons(fillColor = ~pal(area),fillOpacity = .8,color = "#C0C0C0",weight = 1,label = myfile@data$name,labelOptions = labelOptions(noHide = F, textOnly = TRUE, style= list("font-family" = "Helvetica")))%>% addLegend_decreasing(data= Selected_Sites,"bottomright",pal = pal1,values = Selected_Sites$Virus.levels,title = "Virus levels", opacity = 1,decreasing = TRUE,labFormat = function(type, cuts, p) {paste0(labels)})%>% addCircles(lng = Selected_Sites$lon,lat = Selected_Sites$lat, label = Selected_Sites$Site,weight =20, color = ~pal1(Selected_Sites$Virus.levels),opacity = 1)%>% addLabelOnlyMarkers(lng = Selected_Sites$lon,lat = Selected_Sites$lat, label = Selected_Sites$Site,labelOptions = labelOptions(noHide = T, textOnly = T,opacity = 1,textsize = "19px", style = list("font-weight" = "bold","font-family" = "Helvetica",opacity = 1)))                                             
 saveWidget(widget = Map_Virus, file = "/home/sbaby/Desktop/Map_Virus-1.html")
 
 # Map without any Colored polygons
 Map_Virus<- map %>% addTiles() %>% setView(-3.475300, 55.89687, zoom = 10) %>% addLegend_decreasing(data= Selected_Sites,"bottomright",pal = pal1,values = Selected_Sites$Virus.levels,title = "Virus levels", opacity = 1,decreasing = TRUE,labFormat = function(type, cuts, p) {paste0(labels)})%>% addCircles(lng = Selected_Sites$lon,lat = Selected_Sites$lat, label = Selected_Sites$Site,weight =20, color = ~pal1(Selected_Sites$Virus.levels),opacity = 1)%>% addLabelOnlyMarkers(lng = Selected_Sites$lon,lat = Selected_Sites$lat, label = Selected_Sites$Site,labelOptions = labelOptions(noHide = T, textOnly = T,opacity = 1,textsize = "19px", style = list("font-weight" = "bold","font-family" = "Helvetica",opacity = 1)))                                 
 saveWidget(widget = Map_Virus, file = "/home/sbaby/Desktop/Map_Virus-1-1.html")
                          
  # Circle markers only for selected sites & With opaque text box in the labels                         
 Map_Virus<- map %>% addTiles() %>% setView(-3.475300, 55.89687, zoom = 10) %>% addPolygons(fillColor = ~pal(area),fillOpacity = .8,color = "#C0C0C0",weight = 1,label = myfile@data$name,labelOptions = labelOptions(noHide = F, textOnly = TRUE, style= list("font-family" = "Helvetica")))%>% addLegend_decreasing(data= Selected_Sites,"bottomright",pal = pal1,values = Selected_Sites$Virus.levels,title = "Virus levels", opacity = 1,decreasing = TRUE,labFormat = function(type, cuts, p) {paste0(labels)})%>% addCircles(lng = Selected_Sites$lon,lat = Selected_Sites$lat, label = Selected_Sites$Site,weight =20, color = ~pal1(Selected_Sites$Virus.levels),opacity = 1)%>% addLabelOnlyMarkers(lng = Selected_Sites$lon,lat = Selected_Sites$lat, label = Selected_Sites$Site,labelOptions = labelOptions(noHide = T, textOnly = F,opacity = .6,textsize = "19px", style = list("font-weight" = "bold","font-family" = "Helvetica",opacity = 1)))                                             
 saveWidget(widget = Map_Virus, file = "/home/sbaby/Desktop/Map_Virus-2.html")                          
 # With out any defined labels for legends
 Map_Virus<- map %>% addTiles() %>% setView(-3.475300, 55.89687, zoom = 10) %>% addPolygons(fillColor = ~pal(area),fillOpacity = .8,color = "#C0C0C0",weight = 1,label = myfile@data$name,labelOptions = labelOptions(noHide = F, textOnly = TRUE, style= list("font-family" = "Helvetica")))%>% addLegend_decreasing(data= Selected_Sites,"bottomright",pal = pal1,values = Selected_Sites$Virus.levels,title = "Virus levels", opacity = 1,decreasing = TRUE)%>% addCircles(lng = Selected_Sites$lon,lat = Selected_Sites$lat, label = Selected_Sites$Site,weight =20, color = ~pal1(Selected_Sites$Virus.levels),opacity = 1)%>% addLabelOnlyMarkers(lng = Selected_Sites$lon,lat = Selected_Sites$lat, label = Selected_Sites$Site,labelOptions = labelOptions(noHide = T, textOnly = T,opacity = 1,textsize = "19px", style = list("font-weight" = "bold","font-family" = "Helvetica",opacity = 1)))                         
 saveWidget(widget = Map_Virus, file = "/home/sbaby/Desktop/Map_Virus-3.html")
 
 # Circle markers only for all sites
 pal1 <- colorNumeric(palette = c("yellow","purple","dark orange", "green", "blue"),domain =Data1$Virus.levels,na.color = NA)                         
 Map_Virus<- map %>% addTiles() %>% setView(-3.475300, 55.89687, zoom = 10) %>% addPolygons(fillColor = ~pal(area),fillOpacity = .8,color = "#C0C0C0",weight = 1,label = myfile@data$name,labelOptions = labelOptions(noHide = F, textOnly = TRUE, style= list("font-family" = "Helvetica")))%>% addLegend_decreasing(data= Data1,"bottomright",pal = pal1,values = Data1$Virus.levels,title = "Virus levels", opacity = 1,decreasing = TRUE)%>% addCircles(lng = Data1$lon,lat = Data1$lat, label = Data1$Site,weight =20, color = ~pal1(Data1$Virus.levels),opacity = 1)%>% addLabelOnlyMarkers(lng = Selected_Sites$lon,lat = Selected_Sites$lat, label = Selected_Sites$Site,labelOptions = labelOptions(noHide = T, textOnly = T,opacity = 1,textsize = "19px", style = list("font-weight" = "bold","font-family" = "Helvetica",opacity = 1)))                          
 saveWidget(widget = Map_Virus, file = "/home/sbaby/Desktop/Map_Virus-4.html")
 # Circle markers only for all sites  & With opaque text box                         
 Map_Virus<- map %>% addTiles() %>% setView(-3.475300, 55.89687, zoom = 10) %>% addPolygons(fillColor = ~pal(area),fillOpacity = .8,color = "#C0C0C0",weight = 1,label = myfile@data$name,labelOptions = labelOptions(noHide = F, textOnly = TRUE, style= list("font-family" = "Helvetica")))%>% addLegend_decreasing(data= Data1,"bottomright",pal = pal1,values = Data1$Virus.levels,title = "Virus levels", opacity = 1,decreasing = TRUE)%>% addCircles(lng = Data1$lon,lat = Data1$lat, label = Data1$Site,weight =20, color = ~pal1(Data1$Virus.levels),opacity = 1)%>% addLabelOnlyMarkers(lng = Selected_Sites$lon,lat = Selected_Sites$lat, label = Selected_Sites$Site,labelOptions = labelOptions(noHide = T, textOnly = F,opacity = .6,textsize = "19px", style = list("font-weight" = "bold","font-family" = "Helvetica",opacity = 1)))                                                   
 saveWidget(widget = Map_Virus, file = "/home/sbaby/Desktop/Map_Virus-5.html") 
                           
 # Using ColorQuantile function and Circle markers only for all sites
pal1 <- colorQuantile(palette = c("Dark2"),domain =Data1$Virus.levels,na.color = NA)     
Map_Virus<- map %>% addTiles() %>% setView(-3.475300, 55.89687, zoom = 10) %>% addPolygons(fillColor = ~pal(area),fillOpacity = .8,color = "#C0C0C0",weight = 1,label = myfile@data$name,labelOptions = labelOptions(noHide = F, textOnly = TRUE, style= list("font-family" = "Helvetica")))%>% addLegend_decreasing(data= Data1,"bottomright",pal = pal1,values = Data1$Virus.levels,title = "Virus levels", opacity = 1,decreasing = TRUE)%>% addCircles(lng = Data1$lon,lat = Data1$lat, label = Data1$Site,weight =20, color = ~pal1(Data1$Virus.levels),opacity = 1)%>% addLabelOnlyMarkers(lng = Selected_Sites$lon,lat = Selected_Sites$lat, label = Selected_Sites$Site,labelOptions = labelOptions(noHide = T, textOnly = T,opacity = 1,textsize = "19px", style = list("font-weight" = "bold","font-family" = "Helvetica",opacity = 1)))                             
saveWidget(widget = Map_Virus, file = "/home/sbaby/Desktop/Map_Virus-6.html")
# Using ColorQuantile function and Circle markers only for all sites and opaque text boxes                          
Map_Virus<- map %>% addTiles() %>% setView(-3.475300, 55.89687, zoom = 10) %>% addPolygons(fillColor = ~pal(area),fillOpacity = .8,color = "#C0C0C0",weight = 1,label = myfile@data$name,labelOptions = labelOptions(noHide = F, textOnly = TRUE, style= list("font-family" = "Helvetica")))%>% addLegend_decreasing(data= Data1,"bottomright",pal = pal1,values = Data1$Virus.levels,title = "Virus levels", opacity = 1,decreasing = TRUE)%>% addCircles(lng = Data1$lon,lat = Data1$lat, label = Data1$Site,weight =20, color = ~pal1(Data1$Virus.levels),opacity = 1)%>% addLabelOnlyMarkers(lng = Selected_Sites$lon,lat = Selected_Sites$lat, label = Selected_Sites$Site,labelOptions = labelOptions(noHide = T, textOnly = F,opacity = .6,textsize = "19px", style = list("font-weight" = "bold","font-family" = "Helvetica",opacity = 1)))                            
saveWidget(widget = Map_Virus, file = "/home/sbaby/Desktop/Map_Virus-7.html")

#**********Save the Localities[For reference only]************
Localities_names <- myfile@data$name
Localities_names <- as.data.frame(Localities_names)
write.csv(Localities_names,file="Localities_names.csv",quote = FALSE) 
                        
