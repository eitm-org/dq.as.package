library(tidyverse)
library(readxl)

#the purpose of this script is to make dummy replicate groups for d3 formatted data
#this is something we had to do on 2.11.2025, because the connection between samples and replicates was broken in lims

#download dropbox folder to local
dropbox_link <- "https://www.dropbox.com/scl/fo/cpe30c13afjyc7n8p59iv/AGWgm1eXv4BNtDiBCAJyQu0?rlkey=wsepne126byuhkbz1fj6gepiu&dl=1"
local_path <- dropbox_downloader(dropbox_link)

#read in d3 formatted data
d3_data_path <- here("input_data", "unzipped", "D3 Formatted Data", "D3_extract_2025-02-11.csv")
d3df <- read_csv(d3_data_path) %>%
  clean_names()

#read in helen's beautiful tracker
tracker_path <- here("input_data", "unzipped", "SandboxAQ_LIMS_Plate_Tracking_key_Reference.xlsx")
#the relevant sheet is the first one, so I'm not inputting sheet name
tracker <- read_excel(tracker_path) %>%
  clean_names()

exp_merger <- tracker %>%
  dplyr::select(exp_id, plate_id_for_each_replicate, lims_short_name)

d3df2 <- merge(d3df, exp_merger, by.x = "sample_batch_barcode", by.y = "plate_id_for_each_replicate", all.x = TRUE) %>%
  mutate(assay_type_by_sn = case_when(grepl("DRC", lims_short_name, ignore.case = TRUE) ~ "DRC",
                                      TRUE ~ "Screen"))

#now use that dataframe to make replicate groups!
output_df <- dummy_rep(d3df2)

if (!dir.exists(here("output_data"))) {
  dir.create(here("output_data"))
}

write_csv(output_df, here("output_data", "df_w_dummy_reps.csv"))
