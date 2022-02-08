# Load the required libraries

library("circlize")
library(devtools)
library("ComplexHeatmap")

# Read the normalized data
Data = read.table("/home/sbaby/Desktop/Latest_data/Gaps_Closing1/Sample.csv", header =TRUE, sep = ",", row.names = 1)
Data1 = as.matrix(Data)
Data2 = Data1[,order(colnames(Data1))]
Dates <- c("May-2020", "Jun-2020", "Jul-2020", "Aug-2020", "Sep-2020", "Oct-2020", "Nov-2020", "Dec-2020", "Jan-2021", "Feb-2021","Mar-2021", "Apr-2021","May-2021", "Jun-2021", "Jul-2021", "Aug-2021", "Sep-2021", "Oct-2021", "Nov-2021", "Dec-2021", "Jan-2022")
ha = HeatmapAnnotation(foo=anno_mark(at = c(1,2,7,12,17,22,27,32,37,41,45,50,55,60,65,70,75,80,85,90,95), labels = Dates,  labels_gp = gpar(fontsize=9),which = "column", side = "bottom"))

# Read the log of normalized data

Data3 = read.table("/home/sbaby/Desktop/Latest_data/Gaps_Closing1/LogNormalized/Sample.csv", header =TRUE, sep = ",", row.names = 1)
Data4 = as.matrix(Data3)
Data5 = Data4[,order(colnames(Data4))]

col_fun1 = colorRamp2(c(0,6.737538401,91.31779), c("yellow", "orange","blue")) # 91.31779 is the third quantile from the set of positivevalues for normalized data.Break points are set for the normalized values referring to the N1.Reported.Value range
col_fun2 = colorRamp2(c(0,6.737538401,44.36021), c("yellow", "orange","blue"))# 44.36021 is the median from the set of positive values for normalized data.
col_fun3 = colorRamp2(c(-5,1.907695,4.5143454), c("yellow","orange","blue"))  # -Inf corresponding to log(0) is substituted with -5 ( a value outside the range of whole values). 4.5143454 is the third quantile from the set of positive values for log normalized data
col_fun4 = colorRamp2(c(-5,1.907695,3.792343), c("yellow", "orange","blue"))# 3.792343 is the median from the the set of positives for log normalized data

my_data<- as.data.frame(my_data)
my_data<- as.data.frame(Data2)
my_data <- as.matrix(my_data[1:30,]) # Select only first thirty rows
my_data1<- as.data.frame(Data5)
my_data1 <- as.matrix(my_data1[1:30,])

pdf("Covid_Virus_HeatMap_ReducedGapFirst30.pdf", width = 10, height = 10)

Heatmap(my_data, name = "virus levels", col = col_fun1,row_names_gp = gpar(fontsize = 7) , column_names_rot = 90,column_title = "Normalizeddata-Thereshold at ThirdQuantile-Positive",column_title_gp = gpar(fontsize = 13,fontface = "bold"),na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , bottom_annotation = ha, show_column_names = FALSE,border = TRUE,border_gp = gpar(col = "grey"), row_names_side = "left", heatmap_legend_param = list( at = c(0,6.737538401,91.31779), labels = c("Negative", "Positive", "Thirdquantile-Pos")))

Heatmap(my_data1, name = "virus levels", col = col_fun3, column_names_rot = 90,column_title = "Log of Normalizeddata-Thereshold at ThirdQuantile-Positive",row_names_gp = gpar(fontsize = 7),column_title_gp = gpar(fontsize = 13,fontface = "bold"),na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , bottom_annotation = ha, show_column_names = FALSE,border = TRUE,border_gp = gpar(col = "grey"), row_names_side = "left", heatmap_legend_param = list( at = c(-5,1.907695, 4.5143454), labels = c("Negative","Positive", "Thirdquantile-Pos")))

Heatmap(my_data, name = "virus levels", col = col_fun2,row_names_gp = gpar(fontsize = 7) , column_names_rot = 90,column_title = "Normalizeddata-Thereshold at Mediam-Positive",column_title_gp = gpar(fontsize = 13,fontface = "bold"),na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , bottom_annotation = ha, show_column_names = FALSE,border = TRUE,border_gp = gpar(col = "grey"), row_names_side = "left", heatmap_legend_param = list( at = c(0,6.737538401,44.36021), labels = c("Negative", "Positive", "Median-Pos")))

Heatmap(my_data1, name = "virus levels", col = col_fun4, column_names_rot = 90,column_title = "Log of Normalizeddata-Thereshold at Median-Positive",row_names_gp = gpar(fontsize = 7),column_title_gp = gpar(fontsize = 13,fontface = "bold"),na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , bottom_annotation = ha, show_column_names = FALSE,border = TRUE,border_gp = gpar(col = "grey"), row_names_side = "left", heatmap_legend_param = list( at = c(-5,1.907695, 3.792343), labels = c("Negative", "Positive", "Median-Pos")))

dev.off()

pdf("Covid_Virus_HeatMap_ReducedGap.pdf", width = 14, height = 16)

Heatmap(Data2, name = "virus levels", col = col_fun1,width = unit(25, "cm"),row_names_gp = gpar(fontsize = 7) , column_names_rot = 90, height = unit(33, "cm"),column_title = "Normalizeddata-Thereshold at ThirdQuantile-Positive",column_title_gp = gpar(fontsize = 13,fontface = "bold"),na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , bottom_annotation = ha, show_column_names = FALSE,border = TRUE,border_gp = gpar(col = "grey"), row_names_side = "left", heatmap_legend_param = list( at = c(0,6.737538401,91.31779), labels = c("Negative", "Positive", "Thirdquantile-Pos")))

Heatmap(Data5, name = "virus levels", col = col_fun3,width = unit(25, "cm"),row_names_gp = gpar(fontsize = 7) , column_names_rot = 90, height = unit(33, "cm"),column_title = "Log of Normalizeddata-Thereshold at ThirdQuantile-Positive",column_title_gp = gpar(fontsize = 13,fontface = "bold"),na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , bottom_annotation = ha, show_column_names = FALSE,border = TRUE,border_gp = gpar(col = "grey"), row_names_side = "left", heatmap_legend_param = list( at = c(-5,1.907695, 4.5143454), labels = c("Negative", "Positive", "Thirdquantile-Pos")))

Heatmap(Data2, name = "virus levels", col = col_fun2,width = unit(25, "cm"),row_names_gp = gpar(fontsize = 7) , column_names_rot = 90, height = unit(33, "cm"),column_title = "Normalizeddata-Thereshold at Mediam-Positive",column_title_gp = gpar(fontsize = 13,fontface = "bold"),na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , bottom_annotation = ha, show_column_names = FALSE,border = TRUE,border_gp = gpar(col = "grey"), row_names_side = "left", heatmap_legend_param = list( at = c(0,6.737538401,44.36021), labels = c("Negative", "Positive", "Median-Pos")))

Heatmap(Data5, name = "virus levels", col = col_fun4,width = unit(25, "cm"),row_names_gp = gpar(fontsize = 7) , column_names_rot = 90, height = unit(33, "cm"),column_title = "Log of Normalizeddata-Thereshold at Median-Positive",column_title_gp = gpar(fontsize = 13,fontface = "bold"),na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , bottom_annotation = ha, show_column_names = FALSE,border = TRUE,border_gp = gpar(col = "grey"), row_names_side = "left", heatmap_legend_param = list( at = c(-5,1.907695, 3.792343), labels = c("Negative", "Positive", "Median-Pos")))

dev.off()
