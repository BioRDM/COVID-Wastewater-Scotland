# -------------------------------------------------------------------------------------
#
# Authors: Sumy V. Baby
#
# Shell scripts for processing the datafiles
#
# --------------------------------------------------------------------------------------

# Extracts Site, Date_collected and N1_Reported or Normalized values column values from the data_full.csv and convert it in to a wider data format with row names as Site column names as Date_collected and N1_Repoted or Normalized values as datapoints.
awk 'BEGIN {FS=",";OFS=","} {print $3,$8,$12}' data_full.csv | grep -v "Site" | awk -F, -f foo.awk | sort -t, -k1 > Sample1.csv
awk 'BEGIN {FS=",";OFS=","} {print $3,$8,$22}' data_full.csv | grep -v "Site" | awk -F, -f foo.awk | sort -t, -k1 > Sample2.csv

# Concatenates the third and fourth column values with hypen to print it in YYYY-WW format 
awk 'BEGIN {FS=",";OFS=","} {print $2,$3"-"$4,$5}' MeanaggregateReported.csv|grep -v "Site" | sort -k1  > MeanaggregateReported_1.csv # Print the Site,Year-Week(respective of year) and averaged normalized data for each week. Sort by column 1 
# Preprocess the resultant file: 
awk -F, -f Preprocessing.awk MeanaggregateReported_1.csv | sort -k1  > Sample3.csv 

# Concatenates the third and fourth column values with hypen to print it in YYYY-WW format 
awk 'BEGIN {FS=",";OFS=","} {print $2,$3"-"$4,$5}' Meanaggregatenormalized.csv|grep -v "Site" | sort -k1  > Meanaggregatenormalized_1.csv # Print the Site,Year-Week(respective of year) and averaged normalized data for each week. Sort by column 1 
# Preprocess the resultant file: 
awk -F, -f Preprocessing.awk Meanaggregatenormalized_1.csv| sort -k1  > Sample4.csv 
