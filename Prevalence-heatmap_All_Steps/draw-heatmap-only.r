#Load the libraries
#library("circlize")
#library("devtools")
#library("lubridate")

library("tidyverse")
library("ComplexHeatmap")
library("circlize")

Data = read.table("Sample.csv", header =TRUE, sep = ",", row.names = 1) 
Data1 = as.matrix(Data)
Data2 = Data1[,order(colnames(Data1))] # Sort columns 
#Filtering by row name and columns
Data2[row.names(Data2) %in% c("Allanfearn","Helensburgh","Carbarns","Hamilton","Philipshill","Seafield","East Calder","Linlithgow","Shieldhall","Dalmuir","Paisley","Daldowie","Nigg","Peterhead","Kirkwall","Lerwick","Hatton","Forfar","Stirling","Falkirk","Alloa","Meadowhead","Stevenston","Linlithgow","Dunfermline","Levenmouth","Kirkcaldy","Troqueer","Lockerbie","Galashiels","Hawick","Stornoway"),32:100] -> DF_new
# Convert the row.names to a column to facilitate the arrange function for custom sort 
DF_new <- as.data.frame(DF_new)
rownames_to_column(DF_new, var = "rowname") -> DF
# Custom sort
DF %>% arrange(factor(rowname, levels = c("Allanfearn","Helensburgh","Carbarns","Hamilton","Philipshill","Seafield","East Calder","Linlithgow","Shieldhall","Dalmuir","Paisley","Daldowie","Nigg","Peterhead","Kirkwall","Lerwick","Hatton","Forfar","Stirling","Falkirk","Alloa","Meadowhead","Stevenston","Dunfermline","Levenmouth","Kirkcaldy","Troqueer","Lockerbie","Galashiels","Hawick","Stornoway"))) -> DF1
# Convert it back to the row.names
column_to_rownames(DF1, var = "rowname") -> DF2
as.matrix(DF2) -> DF2
Dates <- c("Dec-2020", "Jan-2021" ,"Feb-2021" ,"Mar-2021" ,"Apr-2021" ,"May-2021", "Jun-2021", "Jul-2021", "Aug-2021", "Sep-2021", "Oct-2021", "Nov-2021", "Dec-2021","Jan-2022", "Feb-2022")

#Specify the annotation file for the bottom
ha = HeatmapAnnotation(foo=anno_mark(at = c(1,6,10,14,19,24,29,34,39,44,49,54,59,64,69), labels = Dates,  labels_gp = gpar(fontsize=3, fontface = "bold"),which = "column", side = "bottom"))

#2.276259
pos_start = 0.15
pos_end = 89
fName = paste("prevalence_heatmap_",pos_start,".jpeg", sep = "")

col_fun1 = colorRamp2(c(0,pos_start,pos_end), c("yellow", "orange","blue")) # 89.0200 is the third quantile value from the set of positivevalues for normalized data and 2.276259 is the 2nd minimum value for the positive range.[Break points are set for the normalized values referring to the N1.Reported.Value range] 
jpeg(filename= fName, width=1000, height = 700, units= "px",res= 300) # Save as jpeg with width 1000 pixels, height = 700 pixels, and res = 300 dpi
Heatmap(DF2, col = col_fun1, row_names_gp = gpar(fontsize = 3, fontfamily = "Helvetica",fontface= "bold") , 
        column_names_rot = 90, column_title = "Covid virus prevelance at different sites along the timeline",
        column_title_gp = gpar(fontsize = 5,fontface = "bold"), na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , 
        bottom_annotation = ha, show_column_names = FALSE, border = TRUE, border_gp = gpar(col = "grey"), 
        row_names_side = "left", 
        heatmap_legend_param = list(title="Virus levels [gC/pP]", title_gp = gpar(fontsize =3, fontfamily = "Helvetica", fontface = "bold" ), at = c(0,2.276259,89.0200), 
                                    labels = c("0", pos_start, pos_end), labels_gp= gpar(fontsize = 3, fontfamily = "Helvetica")))

dev.off()

pos_start = 0.75
pos_end = 89
fName = paste("prevalence_heatmap2_",pos_start,".jpeg", sep = "")

col_fun1 = colorRamp2(c(0,pos_end), c("yellow", "blue")) # 89.0200 is the third quantile value from the set of positivevalues for normalized data and 2.276259 is the 2nd minimum value for the positive range.[Break points are set for the normalized values referring to the N1.Reported.Value range] 
jpeg(filename= fName, width=1000, height = 700, units= "px",res= 300) # Save as jpeg with width 1000 pixels, height = 700 pixels, and res = 300 dpi
Heatmap(DF2, col = col_fun1, row_names_gp = gpar(fontsize = 3, fontfamily = "Helvetica",fontface= "bold") , 
        column_names_rot = 90, column_title = "Covid virus prevelance at different sites along the timeline",
        column_title_gp = gpar(fontsize = 5,fontface = "bold"), na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , 
        bottom_annotation = ha, show_column_names = FALSE, border = TRUE, border_gp = gpar(col = "grey"), 
        row_names_side = "left", 
        heatmap_legend_param = list(title="Virus levels [gC/pP]", title_gp = gpar(fontsize =3, fontfamily = "Helvetica", fontface = "bold" ), 
                                    at = c(0,pos_start,89.0200), 
                                    labels = c("0", "positive", pos_end), labels_gp= gpar(fontsize = 3, fontfamily = "Helvetica")))

dev.off()

