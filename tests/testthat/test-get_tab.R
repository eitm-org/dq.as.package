library(rstudioapi)
library(bslib)
library(RMariaDB)

uid <<- "root"
  #TODO: figure out how to use rstudioapi in a test file
  # rstudioapi::askForPassword('Database Username')
pwd <<- "N0tnarwhals!"
  #rstudioapi::askForPassword('Database Password')
host <<- "127.0.0.1"


test_that("error", {
  expect_no_error(get_tab(uid = uid, password = pwd, host = host, dbname = "Sample", tabname = "Sample"))
})

test_that("warning", {
  expect_no_error(get_tab(uid = uid, password = pwd, host = host, dbname = "Sample", tabname = "Sample"))
})

test_that("df output", {
  sample_df <- get_tab(uid = uid, password = pwd, host = host, dbname = "Sample", tabname = "Sample")
  col_names_from_d3 <- names(sample_df)
  expected_col_names <- c("RID", "RCT", "RMT", "RCB", "RMB", "Sample_Number", "Sample_Batch_Barcode", "Label", "Sample_Type",
                          "Treatment_Date", "Matrix", "Straining_Method", "Notes", "Curation_Status", "Release_Date",
                          "Record_Status", "Record_Status_Detail", "3D_Matrix_Supplements", "Sample_Batch",
                          "Source", "Source_ID", "Source_Delete_Time", "Source_Record_ID",)
  expect_equal(col_names_from_d3, expected_col_names)
})
