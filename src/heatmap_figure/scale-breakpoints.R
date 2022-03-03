# *************************************************************************************
#
# Authors: Sumy V. Baby, Tomasz Zielinski
#
# Calculates break points to be used in the heatmap color scale. 
# Although the raw gene copies per L data has clear technical thresholds for positive data,
# normalization creates overlap between "Weak positive", "Positive DNQ" and "Positives". 
# The results in each group have long tails so min/max was not an option. For that reason 3rd
# quartiles are used to mark start of the positive data and to truncate the color scale for better
# visibility
#
# *************************************************************************************

library("tidyverse")

# calculate thresholds
allData = as.data.frame(read.table("../../data/SARS-Cov2_RNA_monitoring_ww_scotland.csv", header =TRUE, sep = ","))

allPositive <- filter(allData, allData$N1_description == "Positive")$Million_gene_copies_per_person_per_day
nonPositive <- filter(allData, allData$N1_description %in% c("Weak Positive","Positive (DNQ)","Negative"))$Million_gene_copies_per_person_per_day

pos_start = round(quantile(nonPositive, 0.75, na.rm=TRUE), digits = 1)
pos_end = round(quantile(allPositive, 0.75, na.rm=TRUE), digits = 1)

print(pos_start)
print(pos_end)

