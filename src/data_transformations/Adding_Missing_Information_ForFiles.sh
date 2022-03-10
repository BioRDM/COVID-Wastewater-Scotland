# -------------------------------------------------------------------------------------
#
# Authors: Sumy V. Baby
#
# Shell scripts for adding missing Health boards and sites and the missing population values
#
# --------------------------------------------------------------------------------------

# Change the mispelled site names. 
sed 's/Invurie/Inverurie/g' ../../data/org_sepa_data/2022_02_14-RNA_Monitoring_Project.csv | sed 's/Langhlm/Langholm/g' | sed 's/Philiphill/Philipshill/g' | sed 's/Sheildhall/Shieldhall/g' | sed 's/Stevenson/Stevenston/g' | sed 's/hatton - Fintry West/Hatton - Fintry West/g' | grep -v "Site" | sort -t, -k2 > intermediate/2022_02_14-RNA_Monitoring_Project_1.csv

# Add the missing Healthboard information
awk 'BEGIN {FS=","; OFS=",";} {if($1 != "(Empty)" ) { myvar=$1; print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18}else { print myvar,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18}}' intermediate/2022_02_14-RNA_Monitoring_Project_1.csv | sed 1i"Health_Board,Site,Date_collected,Date_analysed, SW_sample_number,N1_description, N1_Reported_value-gc_per_L,N1_Repl_1-gc_per_L,N1_Repl_2-gc_per_L,N1_Repl_3-gc_per_L,Calculated_mean,Standard_Deviation,Flow-L_per_day,Ammonia-mg_per_L,pH_value,Modelled_flow-L_per_day,Million_gene_copies_per_person_per_day,Analysis_lab" > intermediate/2022_02_14-RNA_Monitoring_Project_HB_Added.csv 

# Take the list of sites which are missing coordinates
awk 'BEGIN {FS=","; OFS=",";} {print $1,$2}' intermediate/2022_02_14-RNA_Monitoring_Project_HB_Added.csv  | grep "-" | sort | uniq  > intermediate/Sites_Missing_Coordinates.csv 
# Delete the empty sites which are not used and insert the geo coordinates for sites Oban and Dunoon which were missing
grep -v 'Empty' ../../data/org_sepa_data/2022_02_14-Sites_coordinates.csv  |sed 1i"Highland,Oban,730176.21,185987.87\nHighland,Dunoon,676972.15,217390.1"  > intermediate/2022_02_14-Sites_Coordinates_Modified.csv

# Merge it with the existing coordinate file
cat intermediate/2022_02_14-Sites_Coordinates_Modified.csv intermediate/Sites_Missing_Coordinates.csv | grep -v "Site" | sort -t, -k2 > intermediate/Sites_Coordinates.csv 

# Fill out the missing longitude and latitude values
awk 'BEGIN {FS=","; OFS=",";} {if($4 != "" ) { myvar=$3; myvar1=$4;print $1,$2,$3,$4}else { print $1,$2,myvar,myvar1}}' intermediate/Sites_Coordinates.csv|  sed 1i"Health_Board,Site,Latitude_dd, Longitude_dd" >  intermediate/Sites_Coordinates_Full.csv

# Change the mispelled site names in the population file and add the missing Healthboard information
sed 's/Invurie/Inverurie/g' ../../data/org_sepa_data/2022_02_14-Sites_population.csv| sed 's/Langhlm/Langholm/g' | sed 's/Philiphill/Philipshill/g' | sed 's/Sheildhall/Shieldhall/g' | sed 's/Stevenson/Stevenston/g' | sed 's/hatton - Fintry West/Hatton - Fintry West/g' | grep -v "Site" | sort -t, -k2   > intermediate/2022_02_14-Sites_population_1.csv

# Create the unique list with healthboard added for each site
awk 'BEGIN {FS=","; OFS=",";} {if($1 != "(Empty)" ) { myvar=$1; myvar1=$4;myvar2=$5;print $1,$2,$4,$5}else { print myvar,$2,myvar1,myvar2}}' intermediate/2022_02_14-Sites_population_1.csv |  sort -t, -k1| uniq  > intermediate/Population.csv 

# Merge it with the existing coordinate file
cat intermediate/Population.csv intermediate/Sites_Missing_Coordinates.csv | grep -v "Site" | sort -t, -k2 >  intermediate/Population_full.csv  

# Fill out the missing population and population_band values
awk 'BEGIN {FS=","; OFS=",";} {if($3!= "" ) { myvar=$3;myvar1=$4;print $1,$2,$3, $4}else { print $1,$2,myvar,myvar1}}' intermediate/Population_full.csv | sed 1i"Health_Board,Site,Population_band,Population"  > intermediate/Sites_Population_Full.csv
