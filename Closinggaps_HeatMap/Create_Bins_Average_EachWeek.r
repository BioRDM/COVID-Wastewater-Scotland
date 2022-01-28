#Install the required packages and load the libraries
install.packages("lubridate")
install.packages("dplyr")
library(lubridate)
library(dplr)

Data = read.table("/home/sbaby/Desktop/Latest_data/Data.csv", header =TRUE, sep = ",")
Data1 = as.data.frame(Data)
 # Extracting the Year month and week information from dates
date =as.Date(Data1$Date, by="day")
Data1$week = sprintf("%02d", isoweek(date)) # Format week as 2 digit for sorting
Data1$month = sprintf("%02d", month(date)) # Format month as 2 digit for sorting
Data1$month= format.Date(date, "%m")
Data1$Year = year(date)

# Find average of normalized data for each week , grouped by Site, Month and Week

aggregate(Data1$Million.Gene.Copies.Per.Person.per.Day, by=list(Site=Data1$Site, Year= Data1$Year,Month = Data1$month, Week = Data1$week), FUN=mean, na.rm=TRUE) ->Meanaggregate
View(Meanaggregate)
write.csv(Meanaggregate,file="/home/sbaby/Desktop/Latest_data/Meanaggregate.csv")
