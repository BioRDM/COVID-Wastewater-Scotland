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
│   │   ├── prevalence.csv
│   ├── SARS-Cov2_RNA_monitoring_ww_scotland.csv
│   ├── SARS-Cov2_RNA_monitoring_ww_scotland_full.csv
│   ├── prevalence_timeseries.csv
│   ├── norm_prevalence_timeseries.csv
│   ├── weekly_prevalence_timeseries.csv
│   ├── weekly_norm_prevalence_timeseries.csv
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
|Analysis_lab| the laboratory in which the samples were analysed. In most cases the samples were analysed by SEPA, but in some instances, samples were analysed by the The Roslin Institute, University of Edinburgh. The “SEPA-Low Volume” is an identification for a change in laboratory process that occurred in a period of time. This description means that in that particular analysis the volume was reduced, which reflected in changes in the LoD and LoQ values. 
|


----------------------

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.
