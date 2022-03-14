# Data transformation scripts
Scripts used to perform data curation steps and generate secondary output data files.
The original SEPA data downloaded from their dashboard do not adhere completely to the best FAIR practices.

The generated secondary files are saved into `out` folder.  
The intermediate files into `intermediate`

## Usage
R and shell needs to be available from the command line 
(On windows, git bash has been tested to work).

All the commands should be run in the following order

1. Curation of data
Renaming of columns, dates transformations ,adding HB information,adding site and population is done by following commands.

```
# Change the file to user excecutable mode if needed
# chmod u+x Adding_Missing_Information_ForFiles.sh
sh Adding_Missing_Information_ForFiles.sh

# Renaming of columns and date transformations
Rscript RenameColumnsandDateFormat.R    
```

Those commands generate intermediate files which are expected by the operations bellow.

2. Sampling sites
The original data contains geo coordinates in British National Grid units and population size is available in a separate file.

In order to create `sampling_sites.csv` containing sites coordinates in GPS DD unit and joined population call

```
Rscript Generate_Sampling_Sites.R
```

3. Secondary data
We generate the set of files that: 
- joins the sites information with virus level data
- reorganize data tables into timeseries format
- converts daily into weekly averaged data

It assumes that the first two operations were successfull and the required
input files are in the `out` folder.

```
# Generate full data
Rscript Generate_Full_Data.R

# Data Processing
# chmod u+x Data_Processing.sh
sh Data_Processing.sh

# Generate Timeseries data and Virus level data for July 3rd week which is used to generate Geomap points 
Rscript Generate_Timeseries_Files.R
```

