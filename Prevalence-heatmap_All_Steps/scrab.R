#Finding the breakpoints for positive, 3rd quartile value and the median
allData = read.table("RNAMonitoring_File_Feb_2022.csv", header =TRUE, sep = ",")
allData = as.data.frame(allData)

summary(allData)

allPositive <-( filter(allData, allData$N1.Description == "Positive")) 
summary(allPositive)

gC = allData$Million.Gene.Copies.Per.Person.per.Day

allPositive <- filter(allData, allData$N1.Description == "Positive")$Million.Gene.Copies.Per.Person.per.Day
weak <- filter(allData, allData$N1.Description == "Weak Positive")$Million.Gene.Copies.Per.Person.per.Day
dQ <- filter(allData, allData$N1.Description == "Positive (DNQ)")$Million.Gene.Copies.Per.Person.per.Day
nG <- filter(allData, allData$N1.Description == "Negative")$Million.Gene.Copies.Per.Person.per.Day

summary(nG)
summary(weak)
summary(dQ)
summary(allPositive)

wdQ = c(weak, dQ)
nP = c(nG,weak,dQ)

summary(wdQ)
summary(nP)

