# *************************************************************************************
#
# Authors: Sumy V. Baby, Tomasz Zielinski
#
# Creates map with geographic locations of sampling sites. 
# It uses virus levels on a selected date to mark the sites.
#
# *************************************************************************************

library(htmlwidgets)
library(leaflet)


data = read.table("../../data/weekly_norm_prevalence_timeseries.csv", header =TRUE, sep = ",", row.names = 1) 

# Creating map frpm Virus levells on 4rth week of July 2021
start_date_pattern = "X2021.07.+"
week_nr = 4

#sites (and data) are split into two groups to manually control the position of the labels
#only the sitesNames are permanently labelled
sitesNames = c("Allanfearn","Helensburgh","Carbarns","Hamilton","Philipshill","Seafield","East Calder","Linlithgow","Shieldhall","Dalmuir","Paisley","Daldowie","Nigg","Peterhead","Kirkwall","Lerwick","Hatton","Forfar","Stirling","Falkirk","Alloa","Meadowhead","Stevenston","Dunfermline","Levenmouth","Kirkcaldy","Troqueer","Lockerbie","Galashiels","Hawick","Stornoway")
rightSitesNames = c("Hatton","Stevenston", "Seafield","Philipshill","Dunfermline","Kirkcaldy","Lockerbie","Hamilton","Shieldhall")
leftSitesNames = unique(sitesNames[! sitesNames %in% rightSitesNames])


# Add a custom function for reversed legend 
# it also keeps the original bins rather than truncate to the data (otherwise the top one bar was missing)
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
      #cuts <- cuts[cuts >= r[1] & cuts <= r[2]] # I remved it so the blue at the max is visible
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

# Creates a custom function for palete that has break point (to match the heatmap one)
# it should be a factory method that returns a closure but I do not know now how to do it
# that is good enough
breakPal = function(val) {
  pal <- colorNumeric(palette = c("orange", "blue"),domain = 0:90,na.color = "black")                         
  
  res <- vector(mode="character", length=length(val))
  
  res = pal(val)
  res[val < 2.9] = "yellow"
  return(res)
}
attr(breakPal, "colorType") = "numeric"



start_date_cols = names(data)
start_date_cols = start_date_cols[grepl(start_date_pattern, start_date_cols)]
data_selected = select(data, Site, Longitude_dd, Latitude_dd, start_date_cols[week_nr])
data_selected = rename(data_selected, Value = start_date_cols[week_nr])

# truncate data to 88 as in the heatmap top breakpoint
# it is need as otherwise the palete converts them to NA
data_selected$Value[data_selected$Value > 88] = 88 


# Filter the selected sites
leftSelected_Sites = data_selected[data_selected$Site %in% leftSitesNames,]                                                  
rightSelected_Sites = data_selected[data_selected$Site %in% rightSitesNames,]                                                  

dotsColor = breakPal
 

# For static screenshot Circle markers only for selected sites  & With opaque text box                         
Map_Virus<- leaflet(data_selected) %>% 
  addTiles() %>% 
  setView(-3.475300, 55.89687, zoom = 8) %>%
  #addPolygons(fillColor = ~pal(area),fillOpacity = .8,color = "#C0C0C0",weight = 1,label = myfile@data$name,labelOptions = labelOptions(noHide = F, textOnly = TRUE, style= list("font-family" = "Helvetica"))) %>% 
  addLegend_decreasing(data= data_selected,"bottomright",pal = dotsColor, values = data_selected$Value,
                       title = "Virus levels", opacity = 1,decreasing = TRUE, bins = c(0,10,20,30,40,50,60,70,80,90)) %>% 
  addCircles(lng = data_selected$Longitude_dd,lat = data_selected$Latitude_dd, label = data_selected$Site,weight =20, color = ~dotsColor(data_selected$Value),opacity = 1) %>% 
  addLabelOnlyMarkers(lng = leftSelected_Sites$Longitude_dd,lat = leftSelected_Sites$Latitude_dd, label = leftSelected_Sites$Site,
                      labelOptions = labelOptions(noHide = T, textOnly = F,opacity = .7,textsize = "25px", direction="left", style = list("font-weight" = "bold","font-family" = "Helvetica",opacity = 1))) %>%                                                   
  addLabelOnlyMarkers(lng = rightSelected_Sites$Longitude_dd,lat = rightSelected_Sites$Latitude_dd, label = rightSelected_Sites$Site,
                      labelOptions = labelOptions(noHide = T, textOnly = F,opacity = .7,textsize = "25px", direction="right", style = list("font-weight" = "bold","font-family" = "Helvetica",opacity = 1)))                                                   
saveWidget(widget = Map_Virus, file = "geo-map-for-figure.html", ) 

# For interactive map, 
Map_Virus<- leaflet(data_selected) %>% 
  addTiles() %>% 
  setView(-3.475300, 55.89687, zoom = 8) %>%
  #addPolygons(fillColor = ~pal(area),fillOpacity = .8,color = "#C0C0C0",weight = 1,label = myfile@data$name,labelOptions = labelOptions(noHide = F, textOnly = TRUE, style= list("font-family" = "Helvetica"))) %>% 
  addLegend_decreasing(data= data_selected,"bottomright",pal = dotsColor, values = data_selected$Value,
                       title = "Virus levels", opacity = 1,decreasing = TRUE, bins = c(0,10,20,30,40,50,60,70,80,90)) %>% 
  addCircles(lng = data_selected$Longitude_dd,lat = data_selected$Latitude_dd, label = data_selected$Site,weight =20, color = ~dotsColor(data_selected$Value),opacity = 1) %>% 
  addLabelOnlyMarkers(lng = leftSelected_Sites$Longitude_dd,lat = leftSelected_Sites$Latitude_dd, label = leftSelected_Sites$Site,
                      labelOptions = labelOptions(noHide = T, textOnly = F,opacity = .7,textsize = "16px", direction="left", style = list("font-weight" = "bold","font-family" = "Helvetica",opacity = 1))) %>%                                                   
  addLabelOnlyMarkers(lng = rightSelected_Sites$Longitude_dd,lat = rightSelected_Sites$Latitude_dd, label = rightSelected_Sites$Site,
                      labelOptions = labelOptions(noHide = T, textOnly = F,opacity = .7,textsize = "16px", direction="right", style = list("font-weight" = "bold","font-family" = "Helvetica",opacity = 1)))                                                   
saveWidget(widget = Map_Virus, file = "geo-map-interactive.html", ) 

