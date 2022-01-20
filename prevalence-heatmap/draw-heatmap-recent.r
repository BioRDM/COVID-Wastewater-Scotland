install.packages("circlize")
install.packages("devtools")
library("circlize")
library("devtools")
install_github("jokergoo/ComplexHeatmap")
library("ComplexHeatmap")
Data = read.table("/home/sbaby/Desktop/Latest_data/Sample.csv", header =TRUE, sep = ",", row.names = 1)  # Read the data file as a table. Sample.csv is the datafile after preprocessing
Data1 = as.matrix(Data) #Converts the Data table in to matrix
Data2 = Data1[,order(colnames(Data1))] # Sorts matrix in an ascending order according to the column labels
write.table(Data2,file="/home/sbaby/Desktop/Latest_data/Columnsorted.csv")
# Create a string matrix of dates ranging from 2020 to 2022
Dates <- c("May-2020", "Jun-2020", "Jul-2020", "Aug-2020", "Sep-2020", "Oct-2020", "Nov-2020", "Dec-2020", "Jan-2021", "Feb-2021","Mar-2021", "Apr-2021","May-2021", "Jun-2021", "Jul-2021", "Aug-2021", "Sep-2021", "Oct-2021", "Nov-2021", "Dec-2021", "Jan-2022")
col_fun = colorRamp2(c(0,658,1316,11386), c("yellow", "purple","orange", "blue")) # Set breakpoints and assigns color to those 
# Set annotation for column at the specified column marks
ha = HeatmapAnnotation(foo=anno_mark(at = c(1,3,21,34,55,79,101,121,140,161,186,212,235,257,280,301,323,345,366,389,405), labels = Dates,  labels_gp = gpar(fontsize=9),which = "column", side = "bottom"))
pdf("Covid_Virus-2.pdf", width = 16, height = 15) #Save the Heatmap to pdf file
Heatmap(Data2, name = "virus levels", col = col_fun,width = unit(30, "cm"),row_names_gp = gpar(fontsize = 7) , column_names_rot = 90, height = unit(33, "cm"),column_title = "Covid Virus concentrations at different sites along the timeline",column_title_gp = gpar(fontsize = 13,fontface = "bold"),na_col = "white", cluster_rows = FALSE, cluster_columns = FALSE , bottom_annotation = ha, show_column_names = FALSE,border = TRUE,border_gp = gpar(col = "grey"), row_names_side = "left", heatmap_legend_param = list( at = c(0,658,1316,11386), labels = c("Negative", "Weak Positive","Positive (DNQ)", "Positive")))
dev.off()
