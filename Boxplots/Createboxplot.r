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
quantile(Data2$Million.Gene.Copies.Per.Person.per.Day,na.rm =T) # checking the quantile values for positive data
        0%        25%        50%        75%       100% 
    0.1600    19.9725    44.3200    89.0200 23570.7600 
**[upper whisker end= 192.41[calculated as:  (IQR)*1.5 = 103.3713 and the last value comes in range 89.02(third quartile)+103.3713 = 192.59125]
 
quantile(Data3$Million.Gene.Copies.Per.Person.per.Day,na.rm =T) # checking the quantile value for weak positives and negatives
  0%  25%  50%  75% 100% 
0.00 0.00 0.00 0.31 7.77 
**[ upper whisker end =.78[ calculated as (IQR*1.5 =.465 and the last value comes in the range .31(third quartile) +.465 = .78]  

quantile(Data4$Million.Gene.Copies.Per.Person.per.Day,na.rm =T) # checking the quantile value for weak positives, negatives and positive(DNQ)
   0%   25%   50%   75%  100% 
 0.00  0.00  1.01  3.14 49.31 
**[upper whisker end = 7.85[ calculated as (IQR*1.5=4.17 and the last value comes in the range 3.14+ 4.17 = 7.85)] 
 
Data5<-(filter(Data, Data$N1.Reported.Value>=658 & Data$N1.Reported.Value<1316 )) # Filter for weak positive values
quantile(Data5$Million.Gene.Copies.Per.Person.per.Day,na.rm =T)
 0%  25%  50%  75% 100%
0.12 0.41 0.56 0.85 7.77  
**[upper whisker end =1.5 [calculated as IQR *1.5 =.66 and the last value comes in the range .85 + .66 = 1.5 )

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
