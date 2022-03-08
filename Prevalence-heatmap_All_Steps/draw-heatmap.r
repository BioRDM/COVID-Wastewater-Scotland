#Install the required packages
install.packages("circlize")
install.packages("devtools")
install_github("jokergoo/ComplexHeatmap")
install.packages("lubridate")
install.packages("dplyr")
install.packages("tidyverse")

#Load the libraries
library("circlize")
library("devtools")
library("ComplexHeatmap")
library("tidyverse")
library("dplyr")
library("lubridate")
library("dplyr")

#Finding the breakpoints for positive, 3rd quartile value and the median
Data = read.table("data_full.csv", header =TRUE, sep = ",")
as.data.frame(Data) -> Data
Data5 <-( filter(Data, Data$N1_Reported_value.gc_per_L > 11386)) # Filter the values which are greater than 11386(LOQ)

quantile( Data5$Million_gene_copies_per_person_per_day, na.rm=TRUE) # Calculate the quantile values
        0%        25%        50%        75%       100% 
    0.1600    19.9725    44.3200    89.0200 23570.7600 
Data6<-(filter(Data, Data$N1_Reported_value.gc_per_L>=658 & Data$N1_Reported_value.gc_per_L<1316 )) # Filter for weak positive values
quantile(Data6$Million_gene_copies_per_person_per_day,na.rm =T) # Quantile for weak positives
 0%  25%  50%  75% 100%
0.12 0.41 0.56 0.85 7.77  
**[upper whisker end =1.5 [calculated as IQR *1.5 =.66 and the last value comes in the range .85 + .66 = 1.5 )


# ************Binning normalized data on a weekly basis***************

# Extracting the Year month and week information from dates
date =as.Date(Data$Date_collected, by="day")
Data$week = sprintf("%02d", isoweek(date)) # Format week as 2 digit for sorting
Data$Year = year(date)
                           
# Finding the average of normalized data for each week , grouped by Site, Month and Week

aggregate(Data$Million_gene_copies_per_person_per_day, by=list(Site=Data$Site, Year= Data$Year,Week = Data$week), FUN=mean, na.rm=TRUE) ->Meanaggregate
write.csv(Meanaggregate,file="Meanaggregate.csv",quote = FALSE)

# Meanaggregate.csv is processed to Sample.csv as expalined in ReadMe
Data = read.table("Sample.csv", header =TRUE, sep = ",", row.names = 1,check.names=F) 
Data1 = as.matrix(Data)
Data2 = Data1[,order(colnames(Data1))] # Sort columns 
#Filtering by row name and columns
Data2[row.names(Data2) %in% c("Allanfearn","Helensburgh","Carbarns","Hamilton","Philipshill","Seafield","East Calder","Linlithgow","Shieldhall","Dalmuir","Paisley","Daldowie","Nigg","Peterhead","Kirkwall","Lerwick","Hatton","Forfar","Stirling","Falkirk","Alloa","Meadowhead","Stevenston","Linlithgow","Dunfermline","Levenmouth","Kirkcaldy","Troqueer","Lockerbie","Galashiels","Hawick","Stornoway"),29:90] -> DF_new
# Convert the row.names to a column to facilitate the arrange function for custom sort 
DF_new <- as.data.frame(DF_new)
rownames_to_column(DF_new, var = "rowname") -> DF
# Custom sort
DF %>% arrange(factor(rowname, levels = c("Allanfearn","Helensburgh","Carbarns","Hamilton","Philipshill","Seafield","East Calder","Linlithgow","Shieldhall","Dalmuir","Paisley","Daldowie","Nigg","Peterhead","Kirkwall","Lerwick","Hatton","Forfar","Stirling","Falkirk","Alloa","Meadowhead","Stevenston","Dunfermline","Levenmouth","Kirkcaldy","Troqueer","Lockerbie","Galashiels","Hawick","Stornoway"))) -> DF1
# Convert it back to the row.names
column_to_rownames(DF1, var = "rowname") -> DF2
as.matrix(DF2) -> DF2
                           
Dates_full <- c("May-2020", "Jun-2020", "Jul-2020", "Aug-2020", "Sep-2020", "Oct-2020", "Nov-2020","Dec-2020", "Jan-2021" ,"Feb-2021" ,"Mar-2021" ,"Apr-2021" ,"May-2021", "Jun-2021", "Jul-2021", "Aug-2021", "Sep-2021", "Oct-2021", "Nov-2021", "Dec-2021","Jan-2022", "Feb-2022")                           
Dates <- c("Dec-2020", "Jan-2021" ,"Feb-2021" ,"Mar-2021" ,"Apr-2021" ,"May-2021", "Jun-2021", "Jul-2021", "Aug-2021", "Sep-2021", "Oct-2021", "Nov-2021", "Dec-2021","Jan-2022", "Feb-2022")

#Specify the annotation file for the bottom
ha1 = HeatmapAnnotation(foo=anno_mark(at = c(1,2,7,11,16,20,24,29,33,37,41,46,50,55,59,63,68,72,76,81,85,90), labels = Dates_full,  labels_gp = gpar(fontsize=3, fontface = "bold"),which = "column", side = "bottom"))
ha = HeatmapAnnotation(foo=anno_mark(at = c(1,5,9,13,18,22,27,31,35,40,44,48,53,57,62), labels = Dates,  labels_gp = gpar(fontsize=3, fontface = "bold"),which = "column", side = "bottom"))

col_fun1 = colorRamp2(c(0,2.276259,89.0200), c("yellow", "orange","blue")) # 89.0200 is the third quantile value from the set of positivevalues for normalized data and 2.276259 is the 2nd minimum value for the positive range.[Break points are set for the normalized values referring to the N1.Reported.Value range] 
jpeg(filename= "Covid_Heatmap_1.jpeg", width=1000, height = 700, units= "px",res= 300) # Save as jpeg with width 1000 pixels, height = 700 pixels, and res = 300 dpi
Heatmap(DF2, col = col_fun1,row_names_gp = gpar(fontsize = 3, fontfamily = "Helvetica",fontface= "bold") , column_names_rot = 90,column_title = "Covid virus prevelance at different sites along the timeline",column_title_gp = gpar(fontsize = 5,fontface = "bold"),na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , bottom_annotation = ha, show_column_names = FALSE,border = TRUE,border_gp = gpar(col = "grey"), row_names_side = "left", heatmap_legend_param = list(title="Virus levels",title_gp = gpar(fontsize =3, fontfamily = "Helvetica", fontface = "bold" ), at = c(0,2.276259,89.0200), labels = c("Negative", "Positive", "Third-quartile positive"), labels_gp= gpar(fontsize = 3, fontfamily = "Helvetica")))
dev.off()

jpeg(filename= "Covid_Heatmap_full.jpeg", width=1000, height = 1500, units= "px",res= 300) # Save as jpeg with width 1000 pixels, height = 700 pixels, and res = 300 dpi
Heatmap(Data2, col = col_fun1,row_names_gp = gpar(fontsize = 2, fontfamily = "Helvetica",fontface= "bold") , column_names_rot = 90,column_title = "Covid virus prevelance at different sites along the timeline",column_title_gp = gpar(fontsize = 5,fontface = "bold"),na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , bottom_annotation = ha1, show_column_names = FALSE,border = TRUE,border_gp = gpar(col = "grey"), row_names_side = "left", heatmap_legend_param = list(title="Virus levels",title_gp = gpar(fontsize =3, fontfamily = "Helvetica", fontface = "bold" ), at = c(0,2.276259,89.0200), labels = c("Negative", "Positive", "Third-quartile positive"), labels_gp= gpar(fontsize = 3, fontfamily = "Helvetica")))
dev.off()
                           
col_fun1 = colorRamp2(c(0,1.5,89.0200), c("yellow", "orange","blue")) # 89.0200 is the third quantile value from the set of positivevalues for normalized data and 1.5 is the whisker end of the weak positive data as explained above. [Break points are set for the normalized values referring to the N1.Reported.Value range] 
jpeg(filename= "Covid_Heatmap_2.jpeg", width=1000, height = 700, units= "px",res= 300) # Save as jpeg with width 1000 pixels, height = 700 pixels, and res = 300 dpi
Heatmap(DF2, col = col_fun1,row_names_gp = gpar(fontsize = 3, fontfamily = "Helvetica",fontface= "bold") , column_names_rot = 90,column_title = "Covid virus prevelance at different sites along the timeline",column_title_gp = gpar(fontsize = 5,fontface = "bold"),na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , bottom_annotation = ha, show_column_names = FALSE,border = TRUE,border_gp = gpar(col = "grey"), row_names_side = "left", heatmap_legend_param = list(title="Virus levels",title_gp = gpar(fontsize =3, fontfamily = "Helvetica", fontface = "bold" ), at = c(0,1.5,89.0200), labels = c("Negative", "Positive", "Third-quartile positive"), labels_gp= gpar(fontsize = 3, fontfamily = "Helvetica")))
dev.off() 
