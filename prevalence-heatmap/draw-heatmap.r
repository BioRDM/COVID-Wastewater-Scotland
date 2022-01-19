# Rcode to generate heatmap from data file containing reported covid virus values 

install.packages("devtools")
install.packages("circlize")
library("circlize")
library("devtools")
install_github("jokergoo/ComplexHeatmap")
library("ComplexHeatmap")

Data = read.table("/home/sbaby/Desktop/NewData/sample.csv", header =TRUE, sep = ",", row.names = 1) #Read the data fiile  as a table. sample.csv is the datafile after preprocessing
Data1 = as.matrix(Data) #Converts the Data table in to matrix
Data2 = Data1[,order(colnames(Data1))] # Sorts matrix in an ascending order according to the column labels
col_fun = colorRamp2(c(0,658,1316,11386), c("green", "purple","pink", "red")) # Set breakpoints and assigns color to those 
Dates <- c(paste0(month.name[1:12], "2020"), paste0(month.name[1:12], "2021")) # Create a string matrix of dates ranging from 2020 to 2021 

# Set annotaion for column at the specified column marks
ha = HeatmapAnnotation(foo=anno_mark(at = c(1, 6,11,17,21,25,41,53,71,91,112,128,140,164,182,205,227,250,273,294,316,338,360,378), labels = Dates,  labels_gp = gpar(fontsize=9),which = "column", side = "bottom"))

#Save the Heatmap to pdf file
pdf("Covid_Virus.pdf", width = 16, height = 15)
Heatmap(Data2, name = "virus levels", col = col_fun,width = unit(30, "cm"),row_names_gp = gpar(fontsize = 7) , column_names_rot = 90, height = unit(33, "cm"),column_title = "Covid Virus concentrations", cluster_rows = FALSE, cluster_columns = FALSE , bottom_annotation = ha, show_column_names = FALSE, heatmap_legend_param = list( at = c(0,658,1316,11386), labels = c("Negative", "Weak Positive","Positive (DNQ)", "Positive")))
dev.off()
