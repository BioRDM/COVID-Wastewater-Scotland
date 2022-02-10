install.packages("circlize")
install.packages("devtools")
library("circlize")
library("devtools")
install_github("jokergoo/ComplexHeatmap")
library("ComplexHeatmap")
library(tidyverse)
library(dplyr)
#Finding the breakpoints for positive, 3rd quartile value and the median
Data = read.table("/home/sbaby/Desktop/Latest_data/prevalence-data-per-site-LScorza.csv", header =TRUE, sep = ",")
as.data.frame(Data) -> Data
Data5<-( filter(Data, Data$N1.Reported.Value > 11386)) # Filter the values which are greater than 11386(LOQ)
quantile( Data5$Million.Gene.Copies.Per.Person.per.Day, na.rm=TRUE)
#        0%          25%          50%          75%         100% 
#   2.276259    19.511840    44.360206    91.317799 23570.757432   3rd quartile positive = 91.317799
min( Data5$Million.Gene.Copies.Per.Person.per.Day, na.rm=TRUE)
# [1] 2.276259  Positive breakpoint

Data = read.table("/home/sbaby/Desktop/Latest_data/Gaps_Closing1/Sample.csv", header =TRUE, sep = ",", row.names = 1) # Read the Preprocessed file (Normalized data arranged as mean value for each week)
Data1 = as.matrix(Data)
Data2 = Data1[,order(colnames(Data1))] # Sort columns 
#Filtering by row name and columns
Data2[row.names(Data2) %in% c("Allanfearn","Helensburgh","Carbarns","Hamilton","Philipshill","Seafield","East Calder","Linlithgow","Shieldhall","Dalmuir","Paisley","Daldowie","Nigg","Peterhead","Kirkwall","Lerwick","Hatton","Forfar","Stirling","Falkirk","Alloa","Meadowhead","Stevenston","Linlithgow","Dunfermline","Levenmouth","Kirkcaldy","Troqueer","Lockerbie","Galashiels","Hawick","Stornoway"),32:95] -> DF_new
# Convert the row.names to a column to facilitate the arrange function for custom sort 
rownames_to_column(DF_new, var = "rowname") -> DF
# Custom sort
DF %>% arrange(factor(rowname, levels = c("Allanfearn","Helensburgh","Carbarns","Hamilton","Philipshill","Seafield","East Calder","Linlithgow","Shieldhall","Dalmuir","Paisley","Daldowie","Nigg","Peterhead","Kirkwall","Lerwick","Hatton","Forfar","Stirling","Falkirk","Alloa","Meadowhead","Stevenston","Dunfermline","Levenmouth","Kirkcaldy","Troqueer","Lockerbie","Galashiels","Hawick","Stornoway"))) -> DF1
# Convert it back to the row.names
column_to_rownames(DF1, var = "rowname") -> DF2
as.matrix(DF2) -> DF2
#Specify the annotation file for the bottom
ha = HeatmapAnnotation(foo=anno_mark(at = c(1,6,10,14,19,24,29,34,39,44,49,54,59,64), labels = Dates,  labels_gp = gpar(fontsize=3, fontface = "bold"),which = "column", side = "bottom"))
col_fun1 = colorRamp2(c(0,2.276259,91.317799), c("yellow", "orange","blue")) # 91.317799 is the third quantile value from the set of positivevalues for normalized data.Break points are set for the normalized values referring to the N1.Reported.Value range
jpeg(filename= "Covid_Heatmap.jpeg", width=1000, height = 700, units= "px",res= 300) # Save as jpeg with width 1000 pixels, height = 700 pixels, and res = 300 dpi
Heatmap(DF2, col = col_fun1,row_names_gp = gpar(fontsize = 3, fontfamily = "Helvetica",fontface= "bold") , column_names_rot = 90,column_title = "Covid virus prevelance at different sites along the timeline",column_title_gp = gpar(fontsize = 5,fontface = "bold"),na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , bottom_annotation = ha, show_column_names = FALSE,border = TRUE,border_gp = gpar(col = "grey"), row_names_side = "left", heatmap_legend_param = list(title="Virus levels",title_gp = gpar(fontsize =3, fontfamily = "Helvetica", fontface = "bold" ), at = c(0,2.276259,91.317799), labels = c("Negative", "Positive", "Third-quartile positive"), labels_gp= gpar(fontsize = 3, fontfamily = "Helvetica")))
dev.off()
