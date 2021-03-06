# -------------------------------------------------------------------------------------
#
# Authors: Sumy V. Baby
#
# Shell scripts for converting data into timeseries like format
#
# --------------------------------------------------------------------------------------

# Extracts Site, Date_collected and N1_Reported or Normalized values column values from the data_full.csv and convert it in to a wider data format with row names as Site column names as Date_collected and N1_Repoted or Normalized values as datapoints.
awk 'BEGIN {FS=",";OFS=","} {print $3,$8,$12}' out/SARS-Cov2_RNA_monitoring_ww_scotland_full.csv | grep -v "Site" | awk -F, -f Preprocessing.awk | sort -t, -k1 > intermediate/Sample1.csv
awk 'BEGIN {FS=",";OFS=","} {print $3,$8,$22}' out/SARS-Cov2_RNA_monitoring_ww_scotland_full.csv | grep -v "Site" | awk -F, -f Preprocessing.awk | sort -t, -k1 > intermediate/Sample2.csv

