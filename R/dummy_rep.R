require(tidyverse)
require(readxl)

#the purpose of this function is to take in d3 formatted data (with experiment merged in from helen's beautiful tracker)
  # and make dummy replicate groups
#on 2/11/2025, the replicate groups weren't linking to the samples in lims, so we had to make our own

dummy_rep <- function(d3df) {
  d3df2 <- d3df %>%
    mutate(assay_type_by_sn = case_when(grepl("DRC", lims_short_name, ignore.case = TRUE) ~ "DRC",
                                      TRUE ~ "Screen")) %>%
    group_by(sample_batch_barcode) %>%
    mutate(n_drugs = n_distinct(drug)) %>%
    ungroup() %>%
    mutate(assay_type_by_drugn = case_when(n_drugs > 5 ~ "Screen",
                                           TRUE ~ "DRC"),
           #using experiment to separate replicate groups
           #so for drcs (all rep groups on one plate) the "experiment" is the plate
           #for screens, the "experiment" is the experiment
           fake_experiment_NOT_REAL_DONT_LOOK = case_when(assay_type_by_sn == "DRC" ~ sample_batch_barcode,
                                                          assay_type_by_sn == "Screen" ~ exp_id)) %>%
    #first, nest all replicates (samples)
    group_by(fake_experiment_NOT_REAL_DONT_LOOK, sample_batch_barcode, sample_number, sample) %>%
    nest() %>%
    #the sample (id) will serve as the replicate
    #now it's time to connect those to replicate groups
    #within each "experiment", we want to find the samples that have the same drugs, doses, reagents etc
    mutate(drugs = map(data, function(data) paste(sort(unique(data$drug)), collapse = ".")),
           drug_names = map(data, function(data) paste(sort(unique(data$drug_name)), collapse = ".")),
           reagents = map(data, function(data) paste(sort(unique(data$reagent)), collapse = ".")),
           reagent_names = map(data, function(data) paste(sort(unique(data$reagent_name)), collapse = ".")),
           cell_line_rids = map(data, function(data) paste(sort(unique(data$cell_line_rid)), collapse = ".")),
           concentrations = map(data, function(data) paste(sort(unique(data$concentration)), collapse = ".")),
           concentration_units = map(data, function(data) paste(sort(unique(data$concentration_unit)), collapse = ".")),
           drug_aliquots = map(data, function(data) paste(sort(unique(data$drug_aliquot)), collapse = ".")),
           cultures = map(data, function(data) paste(sort(unique(data$culture)), collapse = ".")),
           culture_names = map(data, function(data) paste(sort(unique(data$culture_name)), collapse = "."))) %>%
    group_by(fake_experiment_NOT_REAL_DONT_LOOK,
             drugs, drug_names, reagents, reagent_names, cell_line_rids,
             concentrations, concentration_units, drug_aliquots, cultures, culture_names) %>%
    nest() %>%
    group_by(fake_experiment_NOT_REAL_DONT_LOOK) %>%
    mutate(dummy_replicate_group = paste(fake_experiment_NOT_REAL_DONT_LOOK, drugs, reagents, str_pad(row_number(), 3, pad = "0"), sep = "_"),
           #format it a little nicer
           dummy_replicate_group = str_replace_all(dummy_replicate_group, "__|___", "_"),
           dummy_replicate_group = str_remove_all(dummy_replicate_group, "_$")) %>%
    ungroup()

  output <- d3df2 %>%
    unnest(data) %>%
    unnest(data) %>%
    ungroup() %>%
    dplyr::select(-c(drugs, drug_names, reagents, reagent_names, cell_line_rids,
                     concentrations, concentration_units, drug_aliquots, cultures,
                     culture_names, n_drugs, assay_type_by_drugn))

  return(output)
}
