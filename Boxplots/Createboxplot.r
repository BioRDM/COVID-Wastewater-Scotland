#Load the libraries
library(dplyr)
library(ggplot2)

Data = read.table("RNAMonitoring_File_Feb_2022.csv", header =TRUE, sep = ",") # Read the data file
Data2<-(filter(Data, Data$N1.Reported.Value>11386)) # Filter for Positive values
Data3<-(filter(Data, Data$N1.Reported.Value<1316)) # Filter for Weak Positive values and negatives
Data4<-(filter(Data, Data$N1.Reported.Value<11386)) # Filter Negative, weakpositives,positive DNQ
Positive = data.frame(group = "Positive", value = Data2$Million.Gene.Copies.Per.Person.per.Day)
NegativeandWeakPos = data.frame(group = "NegativeandWeakPos", value = Data3$Million.Gene.Copies.Per.Person.per.Day)
NegativeWeakPosandPosDNQ = data.frame(group = "NegativeWeakPosandPosDNQ", value = Data4$Million.Gene.Copies.Per.Person.per.Day)

plot.data = rbind(Positive,NegativeandWeakPos,NegativeWeakPosandPosDNQ ) # Make data frame for plotting
pdf("Boxplot.pdf",width =10, height = 10) # Save the file
# Plot the data
ggplot(na.omit(plot.data), aes(x=group, y=value, fill=group))  + geom_boxplot(notch=FALSE,outlier.colour = "red", outlier.shape = 1) + scale_y_continuous(limits=c(0,700), breaks=seq(0,700,10), expand = c(0, 0)) + theme(plot.title = element_text(hjust = 0.5),
    panel.background = element_rect(fill = "lightblue",
                                    colour = "lightblue",
                                    size = 0.5, linetype = "solid"),
    panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                    colour = "white"), 
    panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                    colour = "white")
) + ggtitle("Boxplots for different groups of normalized data")
dev.off()
