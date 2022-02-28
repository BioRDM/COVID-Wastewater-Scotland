library(lubridate)
Data = read.table("2022_02_14-RNA_Monitoring_Project_File.tsv", header =TRUE, sep = "\t")
as.data.frame(Data) -> Data
Data[,1:18] -> Data1 # Avoid the last column
colnames(Data1) <- c("Health_Board","Site","Date_collected","Date_analysed", "SW_sample_number","N1_description", "N1_Reported_value-gc_per_L","N1_Repl_1-gc_per_L","N1_Repl_2-gc_per_L","N1_Repl_3-gc_per_L","Calculated_mean","Standard_Deviation","Flow-L_per_day","Ammonia-mg_per_L","pH_value","Modelled_flow-L_per_day","Million_gene_copies_per_person_per_day","Analysis_lab")
Data1$Date_collected<- dmy(Data1$Date_collected) #Change the date format to YYYY-MM-DD
Data1$Date_analysed<- dmy(Data1$Date_analysed)   #Change the date format to YYYY-MM-DD
write.csv(Data1,file="2022_02_14-RNA_Monitoring_Project_File_renamed.csv",quote = FALSE)
