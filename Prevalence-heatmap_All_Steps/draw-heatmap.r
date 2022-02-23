# Install the required packages
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
Data = read.table("RNAMonitoring_File_Feb_2022.csv", header =TRUE, sep = ",")
as.data.frame(Data) -> Data
Data5<-( filter(Data, Data$N1.Reported.Value > 11386)) # Filter the values which are greater than 11386(LOQ)

quantile( Data5$Million.Gene.Copies.Per.Person.per.Day, na.rm=TRUE) # Calculate the quantile values
        0%        25%        50%        75%       100% 
    0.1600    19.9725    44.3200    89.0200 23570.7600 


Data = read.table("/home/sbaby/Desktop/Latest_data/Data.csv", header =TRUE, sep = ",")
Data1 = as.data.frame(Data)
 # Extracting the Year month and week information from dates
date =as.Date(Data1$Date, by="day")
Data1$week = sprintf("%02d", isoweek(date)) # Format week as 2 digit for sorting
Data1$month = sprintf("%02d", month(date)) # Format month as 2 digit for sorting
Data1$Year = year(date)

# Find average of normalized data for each week , grouped by Site, Month and Week

aggregate(Data1$Million.Gene.Copies.Per.Person.per.Day, by=list(Site=Data1$Site, Year= Data1$Year,Month = Data1$month, Week = Data1$week), FUN=mean, na.rm=TRUE) ->Meanaggregate

write.csv(Meanaggregate,file="/home/sbaby/Desktop/Latest_data/Meanaggregate.csv")
 
