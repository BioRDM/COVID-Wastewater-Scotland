# COVID Wastewater Scotland

SARS-CoV-2 RNA levels in Scotland’s wastewater

Nationwide, wastewater based monitoring was newly established in Scotland to track the levels of SARS-CoV-2 viral RNA shed into the sewage network, during the COVID-19 pandemic. We present a curated, reference data set produced by this national programme, from May 2020. 

Viral levels were analysed by RT-qPCR assays of the N1 gene, on RNA extracted from wastewater sampled at 122 locations. Locations were sampled up to four times per week, typically once or twice per week, and in response to local needs. We report sampling site locations with geographical coordinates, the total population in the catchmentfor each site, and the information necessary for data normalisation, such as the incoming wastewater flow values and ammonia concentration, when these were available. 

These wastewater data are contributing to estimates of disease prevalence and the viral reproduction number (R) in Scotland and in the UK.

The detailes of methodology for viral quantification and data analysis can be found at 
[COVID Wastewater Scotland](https://biordm.github.io/COVID-Wastewater-Scotland/). 

This dataset has been described in a data paper [XXX](XXX)

## Files organization

```
│
├── data/
│   ├── org_sepa_data/
│   │   ├── YYYY-MM-DD-RNA_Monitoring_Project.csv
│   │   ├── YYYY-MM-DD-Sites_coordinates.csv
│   │   ├── YYYY-MM-DD-Sites_population.csv
│   ├── SARS-Cov2_RNA_monitoring_ww_scotland.csv
│   ├── SARS-Cov2_RNA_monitoring_ww_scotland_full.csv
│   ├── prevalence_timeseries.csv
│   ├── norm_prevalence_timeseries.csv
│   ├── norm_prevalence_timeseries.csv
│   ├── weekly_prevalence_timeseries.csv
│   ├── weekly_norm_prevalence_timeseries.csv
│   ├── sampling_sites.csv
│   ├── classification_thresholds.csv
├── src/
│   ├── heatmap_figure/
│   ├── geomap_figure/
│   ├── data_tranformations/
```

## Files description

**SARS-Cov2_RNA_monitoring_ww_scotland.csv** - the main dataset represents data obtained from the quantification of the N1 gene of SARS-Cov-2 in wastewater in all 14 NHS Scotland Health Board areas, comprising a total of 122 sampling sites. It is a curated file with corrected sites names and completed health board information.
A description of each column within is provided below:

| Column | Description | Format|
|---|---|---|
|Health_Board | name of the NHS Scotland health board for that particular site and sample || 
|Site| name of the site where the sample was collected, which corresponds to the name of the wastewater treatment centre|| 
|Date_collected| date at which the wastewater sample was collected. | YYYY-MM-DD
|Date_analysed| date at which the sample was analysed. In some instances, cells in this column contain NA because the exact date of the analysis was not available. | YYYY-MM-DD
|SW_sample_number| Scottish Water (SW) sample number. The majority of the samples collected by SW have a sample number assigned. The numbers were assigned in parallel with shipment to the SEPA lab, hence in rare instances the sample arrived but its number did not.
|N1_description| category assigned to the result from analysis of the sample by RT-qPCR. This value can be “Negative”, “Weak Positive”, “Positive (DNQ)”, “Positive” or “Analysis Failed”. See categories_thresholds.csv for more details. ||
|N1_Reported_value-gc_per_L| the gc/L value reported on SEPA’s public dashboard. These reported values are normally the calculated mean of all replicates. In some cases, the reported value excluded an outlier replicate. The value is set to zero when the replicates did not produce a Ct value or the mean was below the LoD. ||
|N1_Repl_1-gc_per_L| the gc/L of replicate 1. Blank fields (null values) mean that a technical issue occurred, and a result was not produced for that sample. The value was set to zero when the replicate did not produce a Ct value.||
|N1_Repl_2-gc_per_L| the gc/L of replicate 2. Blank fields (null values) mean that a technical issue occurred, and a result was not produced for that sample. The value was set to zero when the replicate did not produce a Ct value.||
|N1_Repl_3-gc_per_L| the gc/L of replicate 3. Blank fields (null values) mean that a technical issue occurred, and a result was not produced for that sample. Blank fields (null values) in this case might also mean that a third replicate was not included for that sample. The value was set to zero when the replicate did not produce a Ct value.||
|Calculated_mean| the simple mean of the values obtained for all replicates. 
|Standard_Deviation| the standard deviation of the values obtained for all replicates.
|Flow-L_per_day| the measured flow in litres per day for that particular site and sample collection date. As described in the methodology, not all samples have a flow measurement associated. 
|Ammonia-mg_per_L| the measured ammonia content in milligrams per litre for that particular site and sample collection date. As described in the methodology, not all samples have an ammonia measurement associated.
|pH_value| the pH of the sample, when available. 
|Modelled_flow-L_per_day| the modelled flow in litre per day produced according to the methodology described in the normalisation process. This was particularly used when flow measurements were not available for a specific site and date. 
|Million_gene_copies_per_person_per_day| the normalized gene copies values that account for differences in the flow and populations size. To produce these values, the raw gc/L measurements were multiplied by the daily flow total (or modelled flow), and divided by the population served at each site, to produce a daily value of RNA copies per person. The detailed methodology is described in the on protocols.io [dx.doi.org/10.17504/protocols.io.b4eqqtdw](https://dx.doi.org/10.17504/protocols.io.b4eqqtdw). 
|Analysis_lab| the laboratory in which the samples were analysed. In most cases the samples were analysed by SEPA, but in some instances, samples were analysed by the The Roslin Institute, University of Edinburgh. The “SEPA-Low Volume” is an identification for a change in laboratory process that occurred in a period of time. This description means that in that particular analysis the volume was reduced, which reflected in changes in the LoD and LoQ values. |


**SARS-Cov2_RNA_monitoring_ww_scotland_full.csv** - it contrains the ***de-normalised*** data with the additional
information about the collection sites inserted, like their geographic locations and population in the capture area.
The file contains the same columns as SARS-Cov2_RNA_monitoring_ww_scotland.csv plus:

| Column | Description | Format|
|---|---|---|
| |The same columns as in SARS-Cov2_RNA_monitoring_ww_scotland.csv| |
|	Latitude_dd | geographic position of the sample collection sites (north/south of the equator) in decimal degrees.| |
|	Longitude_dd | geographic position of the sample collection site (east/west of the meridian) in decimal degrees.| |
|Population | number of people in the sewage catchment upstream of the sampling site. |
|Population_band | size of the population in one of the following bands| 0-2K, 2K-4K, 4K-10K, 10K-100K, 100K+.|


**prevalence_timeseries.csv** - contains data in the traditional timeseries format, i.e., each row corresponds to one sample and collection site, 
the first few columns provide information about the site, 
and the subsequent columns store SARS-CoV-2 virus levels measurements for each particular sampling date. 
For example, the column “2020-05-28” contains gene copies per litre from sample collection on 2020-05-28. 
NA means that a sample was not collected for that site at that date or that the analysis failed.

| Column | Description | Format|
|---|---|---|
|Health_Board | name of the NHS Scotland health board for that particular site and sample || 
|Site| name of the site where the sample was collected, which corresponds to the name of the wastewater treatment centre|| 
|	Latitude_dd | geographic position of the sample collection sites (north/south of the equator) in decimal degrees.| |
|	Longitude_dd | geographic position of the sample collection site (east/west of the meridian) in decimal degrees.| |
|Population | number of people in the sewage catchment upstream of the sampling site. |
|Population_band | size of the population in one of the following bands| 0-2K, 2K-4K, 4K-10K, 10K-100K, 100K+.|
|YYYY-MM-DD| virus level in the gc/L value on the particular data. NA denotes both technical failures for the sample or more commonly that the sample was not aquired on the particular data for that site | |

**norm_prevalence_timeseries.csv** is equivalent to the “prevalence_timeseries.csv” but the “date” columns contain the normalised virus levels in million gene copiers per person per day.

**weekly_prevalence_timeseries.csv** contains weekly averaged data of virus levels in the timeseries format, i.e.,
each row corresponds to one sample and collection site, 
the first few columns provide information about the site, 
and the subsequent columns store averaged SARS-CoV-2 virus levels recorded for a given week. 
For example, 2022-6 contains averaged gene copies per litre from samples collected on the week starting at 2022-02-7 
(sixth week of the year, 2nd week of February). 
NA means that no samples were collected in that week for a site or that all the analysis of that week failed.

| Column | Description | Format|
|---|---|---|
|Health_Board | name of the NHS Scotland health board for that particular site and sample || 
|Site| name of the site where the sample was collected, which corresponds to the name of the wastewater treatment centre|| 
|	Latitude_dd | geographic position of the sample collection sites (north/south of the equator) in decimal degrees.| |
|	Longitude_dd | geographic position of the sample collection site (east/west of the meridian) in decimal degrees.| |
|Population | number of people in the sewage catchment upstream of the sampling site. |
|Population_band | size of the population in one of the following bands| 0-2K, 2K-4K, 4K-10K, 10K-100K, 100K+.|
|YYYY-WW| averaged weekly virus level in the gc/L value on that particular week of the year, the column name is year with a week number in that year. NA denotes both technical failures for the sample or more commonly that the sample was not aquired on the particular data for that site | |

**weekly_norm_prevalence_timeseries.csv** is equivalent to the “weekly_ prevalence_timeseries.csv” but the “week” columns (YYYY_WW) contain the averaged normalized virus levels in million gene copies per person per day for that week.

**smapling_sites.csv** contains information about the sampling locations like their geocoordinates or populations size.

| Column | Description | Format|
|---|---|---|
|Site| name of the site where the sample was collected, which corresponds to the name of the wastewater treatment centre|| 
|Health_Board | name of the NHS Scotland health board for that particular site and sample || 
|	Latitude_dd | geographic position of the sample collection sites (north/south of the equator) in decimal degrees.| |
|	Longitude_dd | geographic position of the sample collection site (east/west of the meridian) in decimal degrees.| |
|Population | number of people in the sewage catchment upstream of the sampling site. |
|Population_band | size of the population in one of the following bands| 0-2K, 2K-4K, 4K-10K, 10K-100K, 100K+.|

**classification_thresholds.csv** - information about the limits of detection and limits of quantification that were used to classify the samples as negative, weak positive, positive DNQ and positive.

**data/org_sepa_data/** is a folder that contains the data files in the original format after downloading from the SEPA dashboard.
Generally they should not be used, as the files contain the curated data that follows the best practices.

**src/heatmap_figure** contains the R script that can be used to generated heatmap figure from the weekly data.

**src/geomap_figure** contains the R script that generates the interactive map with the sites locations

**src/data_tranformations** contains scripts that were used to perform automatic data curation and gneration of the secondary data files which are included in the data folder.

## How to cite
Livia C. T. Scorza, Graeme J. Cameron, Roisin Murray-Williams, David Findlay, Julie Bolland, 
Brindusa Cerghizan, Kirsty Campbell, David Thomson, Alexander Corbishley, David Gally, Stephen Fitzgerald,
Alison Low, Sean McAteer, Adrian M. I. Roberts, Zhou Fang, Claus-Dieter Mayer, Anastasia Frantsuzova,
Sumy V. Baby, Tomasz Zieliński, Andrew J. Millar
"SARS-CoV-2 RNA levels in Scotland’s wastewater"


----------------------

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.
