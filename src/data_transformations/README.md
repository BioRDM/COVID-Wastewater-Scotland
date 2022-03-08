# Data transformation scripts
Scripts used to perform data curation steps and generate secondary output data files.
The original SEPA data downloaded from their dashboard do not adhere completely to the best FAIR practices.

The generated secondary files are saved into ```out``` folder.  
The intermediate files into ```intermediate```

## Usage
R and bash shell need to be available from the command line.

1. Sampling sites
The original data contains geo coordinates in British National Grid units 
and population size is available in a separete file.

In order to create `sampling_sites.csv` containing sites coordinates in GPS DD unit and joined population call
```
SUMY WRITES WHAT TO DO FOR EXAMPLE IF IT IS ONE COMMAND OR FILE THAT TAKES BOTH files inputs
$ a_script ../../data/org_sepa_data/2022_02_14-Sites_coordinates.csv ../../data/org_sepa_data/2022_02_14-Sites_population.csv
```

2. Curation of data
Renaming of columns, dates transformations and adding HB inforamtion is done by follwing commands
```
SUMY ...
$ first_comand_or_script ../../data/org_sepa_data/2022_02_14-RNA_Monitoring_Project.csv
$ followign_commands
``` 

3. Secondary data
We generate the set of files than 
- joins the sites information with virus level data
- reorganize data tables into timeseries format
- converts into weekly data

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