#Load the libraries
library(dplyr)
library(ggplot2)

Data = read.table("RNAMonitoring_File_Feb_2022.csv", header =TRUE, sep = ",") # Read the data file
Data5<-(filter(Data, Data$N1.Description == "Positive")) # Filter for Positive values
Data6<-(filter(Data, Data$N1.Description != "Positive")) # Filter for all values that are not positive
Positive = data.frame(group = "Positive", value = Data5$Million.Gene.Copies.Per.Person.per.Day)
Negative = data.frame(group = "Negative", value =Data6$Million.Gene.Copies.Per.Person.per.Day)

plot.data = rbind(Positive, Negative) # Make data frame for plotting
pdf("Positive_NegativeBoxplots.pdf") # Save the file
ggplot(na.omit(plot.data), aes(x=group, y=value, fill=group))   geom_boxplot(notch=FALSE,outlier.colour = "red", outlier.shape = 1)  scale_y_continuous(limits=c(0,400), breaks=seq(0,400,50), expand = c(0, 0))
dev.off()
