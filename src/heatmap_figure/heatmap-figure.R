# *************************************************************************************
#
# Authors: Sumy V. Baby, Tomasz Zielinski
#
# Creates heatmap with virus levels. It assumes weekly data as the input.
# It contains hardcoded scale for better visibility as the data have long tails in values
#
# *************************************************************************************


library("tidyverse")
library("ComplexHeatmap")
library("circlize")

# calculated in scale-breakpoints.R
pos_start = 2.9
pos_end = 88


data = read.table("../../data/weekly_norm_prevalence_timeseries.csv", header =TRUE, sep = ",", row.names = 1) 

# remove sites information
data = subset(data,select = -c(Health_Board, Longitude_dd, Latitude_dd))

data = data[,order(colnames(data))] # Sort columns, the format is YYYY.MM.WW ww is week number 

# cut to the range of dates of interests
start_date_pattern = "X2020.12.+"
start_date_cols = names(data)
start_date_cols = start_date_cols[grepl(start_date_pattern, start_date_cols)]

data_selected = select(data, Site | start_date_cols[1]:last_col())

# filtering by sites of interests
selected_sites = c("Allanfearn","Helensburgh","Carbarns","Hamilton","Philipshill","Seafield","East Calder","Linlithgow","Shieldhall","Dalmuir","Paisley","Daldowie","Nigg","Peterhead","Kirkwall","Lerwick","Hatton","Forfar","Stirling","Falkirk","Alloa","Meadowhead","Stevenston","Linlithgow","Dunfermline","Levenmouth","Kirkcaldy","Troqueer","Lockerbie","Galashiels","Hawick","Stornoway")
data_selected = filter(data_selected, data_selected$Site %in% selected_sites)

# custom order (by health board)
ordered_sites = c("Allanfearn","Helensburgh","Carbarns","Hamilton","Philipshill","Seafield","East Calder","Linlithgow","Shieldhall","Dalmuir","Paisley","Daldowie","Nigg","Peterhead","Kirkwall","Lerwick","Hatton","Forfar","Stirling","Falkirk","Alloa","Meadowhead","Stevenston","Dunfermline","Levenmouth","Kirkcaldy","Troqueer","Lockerbie","Galashiels","Hawick","Stornoway")
data_selected = arrange(data_selected, factor(Site, levels = ordered_sites))

column_to_rownames(data_selected, var = "Site") -> data_selected
data_selected = as.matrix(data_selected)

#Specify the annotation marks for the bottom
#That is ugly, should be generated from the dates
Dates <- c("Dec-2020", "Jan-2021" ,"Feb-2021" ,"Mar-2021" ,"Apr-2021" ,"May-2021", "Jun-2021", "Jul-2021", "Aug-2021", "Sep-2021", "Oct-2021", "Nov-2021", "Dec-2021","Jan-2022", "Feb-2022")
ha = HeatmapAnnotation(foo=anno_mark(at = c(1,6,10,14,19,24,29,34,39,44,49,54,59,64,69), labels = Dates,  labels_gp = gpar(fontsize=3, fontface = "bold"),which = "column", side = "bottom"))

# custom scale, positive start and end are used for rainbos range, non positive values are fixed to yellow
col_fun1 = colorRamp2(c(0,pos_start,pos_end), c("yellow", "orange","blue")) 

fName = "figure_prevalence_heatmap.jpeg"
jpeg(filename= fName, width=1000, height = 700, units= "px",res= 300) # Save as jpeg with width 1000 pixels, height = 700 pixels, and res = 300 dpi
hm = Heatmap(data_selected, col = col_fun1, row_names_gp = gpar(fontsize = 3, fontfamily = "Helvetica",fontface= "bold") , 
        column_names_rot = 90, 
        #column_title = "Covid virus prevelance at different sites along the timeline",
        #column_title_gp = gpar(fontsize = 5,fontface = "bold"), 
        na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , 
        bottom_annotation = ha, show_column_names = FALSE, border = TRUE, border_gp = gpar(col = "grey"), 
        row_names_side = "left", 
        heatmap_legend_param = list(title="Virus levels\n[Mgc/(person*day)]", title_gp = gpar(fontsize =3, fontfamily = "Helvetica", fontface = "bold" ), at = c(0,2.276259,89.0200), 
                                    labels = c(0, "positive", pos_end), labels_gp= gpar(fontsize = 3, fontfamily = "Helvetica")))

draw(hm)
dev.off()


# all sites
data_selected = select(data, Site | start_date_cols[1]:last_col())
column_to_rownames(data_selected, var = "Site") -> data_selected
data_selected = as.matrix(data_selected)

fName = "figure_prevalence_heatmap_all.jpeg"
col_fun1 = colorRamp2(c(0,pos_start,pos_end), c("yellow", "orange","blue")) 
jpeg(filename= fName, width=1000, height = 2500, units= "px",res= 300) # Save as jpeg with width 1000 pixels, height = 700 pixels, and res = 300 dpi
hm = Heatmap(data_selected, col = col_fun1, row_names_gp = gpar(fontsize = 3, fontfamily = "Helvetica",fontface= "bold") , 
        column_names_rot = 90, 
        na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , 
        bottom_annotation = ha, show_column_names = FALSE, border = TRUE, border_gp = gpar(col = "grey"), 
        row_names_side = "left", 
        heatmap_legend_param = list(title="Virus levels\n[Mgc/(person*day)]", title_gp = gpar(fontsize =3, fontfamily = "Helvetica", fontface = "bold" ), at = c(0,2.276259,89.0200), 
                                    labels = c(0, "positive", pos_end), labels_gp= gpar(fontsize = 3, fontfamily = "Helvetica")))
draw(hm)
dev.off()

