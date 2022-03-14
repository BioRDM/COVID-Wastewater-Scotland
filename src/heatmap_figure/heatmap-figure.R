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
library("tidyr")
library("lubridate")

# calculated in scale-breakpoints.R
pos_start = 2.9
pos_end = 88

# read the full data
Data = read.table("../../data/SARS-Cov2_RNA_monitoring_ww_scotland_full.csv", header =TRUE, sep = ",")
as.data.frame(Data) ->Data

# extract the week, month and year from the date collected
date =as.Date(Data$Date_collected, by="day")
Data$Week = sprintf("%02d", isoweek(date)) # Format week as 2 digit for sorting
Data$Month = sprintf("%02d", month(date)) # Format week as 2 digit for sorting
Data$Year = year(date)

# find the mean aggregate by Site, week and year
Data %>% group_by(Site, Week,Year) %>% mutate(mean_size = mean(Million_gene_copies_per_person_per_day, na.rm = TRUE)) -> Meanaggregate

# select the distinct rows
distinct(select(Meanaggregate,Site,Month,Week,Year,mean_size)) -> Meanaggregate
Meanaggregate[order(Meanaggregate$Month),] -> Meanaggregate #Sort by month
# set the month pointing to each week to starting month of that week for easier annotation
Meanaggregate %>% group_by(Week,Year) %>% mutate(Month, Month=first(Month)) -> Meanaggregate
distinct(select(Meanaggregate,Site,Year,Month,Week,mean_size)) -> Meanaggregate
# make the Year-Month-Week column
Meanaggregate$"Year-Month-Week" <- paste(Meanaggregate$Year,Meanaggregate$Month,Meanaggregate$Week,sep = "-")
Meanaggregate <- as.data.frame(Meanaggregate)
Meanaggregate<- select(Meanaggregate, Site,"Year-Month-Week",mean_size)

# convert the data to a wider format having column names from "Year-Month-Week" and values from the column mean_size
Meanaggregate.wide <- pivot_wider(Meanaggregate, names_from = "Year-Month-Week", values_from = mean_size)
column_to_rownames(Meanaggregate.wide, var = "Site") -> Meanaggregate.wide # convert column, Site to row.names for sorting

Data2 = Meanaggregate.wide[,order(colnames(Meanaggregate.wide))] # Sort ascending by column names
Colnames <- colnames(Data2)
as.data.frame(Colnames)-> Colnames
within(Colnames, Colnames<-data.frame(do.call('rbind', strsplit(as.character(Colnames), '-', fixed=TRUE)))) ->Colnames1
paste(month.abb[as.integer(Colnames1$Colnames$X2)],as.integer(Colnames1$Colnames$X1),sep =  "-") -> Dates_Range # get the range of dates
unique(Dates_Range) -> Dates # Find the unique dates
c(1, head(cumsum(rle(Dates_Range)$lengths)+1, -1)) -> anno # find the annotation for the full range of dates
DR = as.data.frame(Dates_Range)
selected_dates_range = DR[c(which(DR$Dates_Range=="Dec-2020")):(which(DR$Dates_Range=="Feb-2022")),] # extract the selected dates range
unique(selected_dates_range) -> selected_dates
c(1, head(cumsum(rle(selected_dates_range)$lengths)+1, -1)) -> anno1 # find the annotation for selected date range

# cut to the range of dates of interests
# First week starting from December 2020
start_date_pattern = "2020-12-50" 
Data2 = as.data.frame(Data2)
rownames_to_column(Data2, var = "Site") -> Data2
start_date_cols = names(Data2)
start_date_cols = start_date_cols[grepl(start_date_pattern, start_date_cols)]
data_selected = select(Data2, Site | start_date_cols[1]:last_col())

# filtering by sites of interests
selected_sites = c("Allanfearn","Helensburgh","Carbarns","Hamilton","Philipshill","Seafield","East Calder","Linlithgow","Shieldhall","Dalmuir","Paisley","Daldowie","Nigg","Peterhead","Kirkwall","Lerwick","Hatton","Forfar","Stirling","Falkirk","Alloa","Meadowhead","Stevenston","Linlithgow","Dunfermline","Levenmouth","Kirkcaldy","Troqueer","Lockerbie","Galashiels","Hawick","Stornoway")
data_selected = filter(data_selected, data_selected$Site %in% selected_sites)

# custom order (by health board)
ordered_sites = c("Allanfearn","Helensburgh","Carbarns","Hamilton","Philipshill","Seafield","East Calder","Linlithgow","Shieldhall","Dalmuir","Paisley","Daldowie","Nigg","Peterhead","Kirkwall","Lerwick","Hatton","Forfar","Stirling","Falkirk","Alloa","Meadowhead","Stevenston","Dunfermline","Levenmouth","Kirkcaldy","Troqueer","Lockerbie","Galashiels","Hawick","Stornoway")
data_selected = arrange(data_selected, factor(Site, levels = ordered_sites))
column_to_rownames(data_selected, var = "Site") -> data_selected
column_to_rownames(Data2, var = "Site") -> Data2
data_selected = as.matrix(data_selected)
Data2 <- as.matrix(Data2)

# specify the annotation marks for the bottom
ha = HeatmapAnnotation(foo=anno_mark(at = anno, labels = Dates_Range,  labels_gp = gpar(fontsize=3, fontface = "bold"),which = "column", side = "bottom"))
ha1 = HeatmapAnnotation(foo=anno_mark(at = anno1, labels = selected_dates,  labels_gp = gpar(fontsize=3, fontface = "bold"),which = "column", side = "bottom"))



# custom scale, positive start and end are used for rainbos range, non positive values are fixed to yellow
col_fun1 = colorRamp2(c(0,pos_start,pos_end), c("yellow", "orange","blue")) 

fName = "figure_prevalence_heatmap.jpeg"
jpeg(filename= fName, width=1000, height = 700, units= "px",res= 300) # Save as jpeg with width 1000 pixels, height = 700 pixels, and res = 300 dpi
hm = Heatmap(data_selected, col = col_fun1, row_names_gp = gpar(fontsize = 3, fontfamily = "Helvetica",fontface= "bold") , 
        column_names_rot = 90, 
        #column_title = "Covid virus prevelance at different sites along the timeline",
        #column_title_gp = gpar(fontsize = 5,fontface = "bold"), 
        na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , 
        bottom_annotation = ha1, show_column_names = FALSE, border = TRUE, border_gp = gpar(col = "grey"), 
        row_names_side = "left", 
        heatmap_legend_param = list(title="Virus levels\n[Mgc/(person*day)]", title_gp = gpar(fontsize =3, fontfamily = "Helvetica", fontface = "bold" ), at = c(0,pos_start,pos_end), 
                                    labels = c(0, "positive", pos_end), labels_gp= gpar(fontsize = 3, fontfamily = "Helvetica")))

draw(hm)
dev.off()

# all sites


fName = "figure_prevalence_heatmap_all.jpeg"
col_fun1 = colorRamp2(c(0,pos_start,pos_end), c("yellow", "orange","blue")) 
jpeg(filename= fName, width=1000, height = 2500, units= "px",res= 300) # Save as jpeg with width 1000 pixels, height = 700 pixels, and res = 300 dpi
hm = Heatmap(Data2, col = col_fun1, row_names_gp = gpar(fontsize = 3, fontfamily = "Helvetica",fontface= "bold") , 
        column_names_rot = 90, 
        na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , 
        bottom_annotation = ha, show_column_names = FALSE, border = TRUE, border_gp = gpar(col = "grey"), 
        row_names_side = "left", row_order = sort(rownames(Data2)),heatmap_legend_param = list(title="Virus levels\n[Mgc/(person*day)]", title_gp = gpar(fontsize =3, fontfamily = "Helvetica", fontface = "bold" ), at = c(0,pos_start,pos_end),labels = c(0, "positive", pos_end), labels_gp= gpar(fontsize = 3, fontfamily = "Helvetica")))
draw(hm)
dev.off()



