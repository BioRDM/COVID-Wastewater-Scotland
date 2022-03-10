# Data transformation scripts
Scripts used to perform data curation steps and generate secondary output data files.
The original SEPA data downloaded from their dashboard do not adhere completely to the best FAIR practices.

The generated secondary files are saved into `out` folder.  
The intermediate files into `intermediate`

## Usage
R and bash shell need to be available from the command line.

1. Sampling sites
The original data contains geo coordinates in British National Grid units 
and population size is available in a separete file.

In order to create `sampling_sites.csv` containing sites coordinates in GPS DD unit and joined population call
```
$ Rscript Generate_Sampling_Sites.R
```

2. Curation of data
Renaming of columns, dates transformations and adding HB inforamtion is done by follwing commands
```
# Shell scripts to change the mispelled site names and to add the missing Healthboard information
$sed 's/Invurie/Inverurie/g' ../../data/org_sepa_data/2022_02_14-RNA_Monitoring_Project.csv | sed 's/Langhlm/Langholm/g' | sed 's/Philiphill/Philipshill/g' | sed 's/Sheildhall/Shieldhall/g' | sed 's/Stevenson/Stevenston/g' | sed 's/hatton - Fintry West/Hatton - Fintry West/g' | grep -v "Site" | sort -t, -k2 > intermediate/2022_02_14-RNA_Monitoring_Project_1.csv

$awk 'BEGIN {FS=","; OFS=",";} {if($1 != "(Empty)" ) { myvar=$1; print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18}else { print myvar,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18}}' intermediate/2022_02_14-RNA_Monitoring_Project_1.csv | sed 1i"Health_Board,Site,Date_collected,Date_analysed, SW_sample_number,N1_description, N1_Reported_value-gc_per_L,N1_Repl_1-gc_per_L,N1_Repl_2-gc_per_L,N1_Repl_3-gc_per_L,Calculated_mean,Standard_Deviation,Flow-L_per_day,Ammonia-mg_per_L,pH_value,Modelled_flow-L_per_day,Million_gene_copies_per_person_per_day,Analysis_lab" > intermediate/2022_02_14-RNA_Monitoring_Project_HB_Added.csv 
$ first_comand_or_script ../../data/org_sepa_data/2022_02_14-RNA_Monitoring_Project.csv
$ next_commands
``` 

3. Secondary data
We generate the set of files that: 
- joins the sites information with virus level data
- reorganize data tables into timeseries format
- converts into weekly data

It assumes that the first two operations were successfull and the required
input files are in the `out` folder.
```
CALL ....
```


## Output Data Files for Covid waster project:
Ouput data files are stored in the folder: OutPut_Data_Files

## Files used in data processing:
Files used in data processing are stored in tha folder : Files_used_in_data_processing

## Rcode used for the generation of data files
Refer to : Creating_Data_Files.r

## Shell script for data processing 
Refer to: Data_processing.sh

## Shell script for adding empty Health_Board and location for missing sites
Refer to : Adding_missing_HbandSites.sh
