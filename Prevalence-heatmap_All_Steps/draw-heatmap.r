install.packages("circlize")
install.packages("devtools")
install_github("jokergoo/ComplexHeatmap")

library("circlize")
library("devtools")
library("ComplexHeatmap")
library("tidyverse")
library("dplyr")
#Finding the breakpoints for positive, 3rd quartile value and the median
Data = read.table("RNAMonitoring_File_Feb_2022.csv", header =TRUE, sep = ",")
as.data.frame(Data) -> Data
Data5<-( filter(Data, Data$N1.Reported.Value > 11386)) # Filter the values which are greater than 11386(LOQ)

quantile( Data5$Million.Gene.Copies.Per.Person.per.Day, na.rm=TRUE) # Calculate the quantile values
        0%        25%        50%        75%       100% 
    0.1600    19.9725    44.3200    89.0200 23570.7600 
 
