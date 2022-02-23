install.packages("circlize")
install.packages("devtools")
library("circlize")
library("devtools")
install_github("jokergoo/ComplexHeatmap")
library("ComplexHeatmap")
library(tidyverse)
library(dplyr)
#Finding the breakpoints for positive, 3rd quartile value and the median
Data = read.table("RNAMonitoring_File_Feb_2022.csv", header =TRUE, sep = ",")
as.data.frame(Data) -> Data
Data5<-( filter(Data, Data$N1.Reported.Value > 11386)) # Filter the values which are greater than 11386(LOQ)
