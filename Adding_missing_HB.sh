cut -d"," -f2 RNAMonitoring_File_Feb_2022.csv |grep -v "Site" | awk 'BEGIN {FS="-";OFS=","} {print $1,$2}' | sort -k1 > RNAMonitoring_File_Feb_2022_sep.csv

grep -v "Site"  RNAMonitoring_File_Feb_2022.csv | sort -t, -k2 > RNAMonitoring_File_Feb_2022_sorted.csv 

paste RNAMonitoring_File_Feb_2022_sep.csv  RNAMonitoring_File_Feb_2022_sorted.csv -d "," > paste.csv

sed -i 's/Invurie/Inverurie/g' paste.csv
sed -i 's/Langhlm/Langholm/g' paste.csv
sed -i 's/Philiphill/Philipshill/g' paste.csv
sed -i 's/Sheildhall/Shieldhall/g' paste.csv
sed -i 's/Stevenson/Stevenston/g' paste.csv
sort -t , -k4 paste.csv > Paste1.csv

awk 'BEGIN {FS=","; OFS=",";} {if($3 != "(Empty)" ) { myvar=$3; print $1,$2,myvar,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20}else { print $1, $2,myvar,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20}}' Paste1.csv | sed 1i"Site_1,Site_2,Health_Board,Site,Date_collected,Date_analysed, SW_sample_number,N1_description, N1_Reported_value-gc_per_L,N1_Repl_1-gc_per_L,N1_Repl_2-gc_per_L,N1_Repl_3-gc_per_L,Calculated_mean,Standard_Deviation,Flow-L_per_day,Ammonia-mg_per_L,pH_value,Modelled_flow-L_per_day,Million_gene_copies_per_person_per_day,Analysis_lab" > File_HBAdded.csv
