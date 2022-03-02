# Change the mispelled site names. 'Carbarn' is already changed to 'Carbarns' so not included here
sed 's/Invurie/Inverurie/g' 2022_02_14-RNA_Monitoring_Project.csv | sed 's/Langhlm/Langholm/g' | sed 's/Philiphill/Philipshill/g' | sed 's/Sheildhall/Shieldhall/g' | sed 's/Stevenson/Stevenston/g' | sed 's/hatton - Fintry West/Hatton - Fintry West/g' | grep -v "Site" | sort -t, -k2 > 2022_02_14-RNA_Monitoring_Project_1.csv
awk 'BEGIN {FS=","; OFS=",";} {if($1 != "(Empty)" ) { myvar=$1; print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18}else { print myvar,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18}}' 2022_02_14-RNA_Monitoring_Project_1.csv | sed 1i"Health_Board,Site,Date_collected,Date_analysed, SW_sample_number,N1_description, N1_Reported_value-gc_per_L,N1_Repl_1-gc_per_L,N1_Repl_2-gc_per_L,N1_Repl_3-gc_per_L,Calculated_mean,Standard_Deviation,Flow-L_per_day,Ammonia-mg_per_L,pH_value,Modelled_flow-L_per_day,Million_gene_copies_per_person_per_day,Analysis_lab" > 2022_02_14-RNA_Monitoring_Project_HB_Added.csv 

#*******Adding the missing Sites in to Coordinate file*************#
awk 'BEGIN {FS=","; OFS=",";} {print $1,$2}' 2022_02_14-RNA_Monitoring_Project_HB_Added.csv  | grep "-" | sort | uniq  > Sites_Missing_Coordinates.csv # Take the list of sites missing coordinates
cat site-location-coordinates-LScorza.csv Sites_Missing_Coordinates.csv | grep -v "Site" | sort -t, -k2 > Sites_coordinates.csv # merge it with the existing coordinate file

# Fill out the missing longitude and latitude values
awk 'BEGIN {FS=","; OFS=",";} {if($4 != "" ) { myvar=$3; myvar1=$4;print $1,$2,$3,$4}else { print $1,$2,myvar,myvar1}}' Sites_coordinates.csv|  sed 1i"Health_Board,Site,Latitude_dd, Longitude_dd" >  Sites_coordinates_full.csv
