#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(here)
library(readxl)
library(tidyverse)
library(janitor)
library(rhandsontable)
library(readxl)
library(bslib)
library(R.utils)
library(zip)
library(curl)
library(readr)
library(plater)
library(lubridate)
library(stringr)
library(DT)

reactiveConsole(TRUE)

host <<- "127.0.0.1"

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  reactive_values <- reactiveValues()
  #########################################################################################################
  # grab tables from d3 to use later on
  #########################################################################################################

  ###################################
  #Step 1: connect to D3 and extract all relevant tables as reactive values
  ###################################
  #
  #1a: connect to sample
  #
  #get plate and well level metadata (sample_batch, sample)
  reactive_values$sample_batch <- eventReactive(input$connect, {
    get_tab(input$uid,
            input$password,
            host,
            dbname = "Sample",
            tabname = "Sample_Batch")
  })

  #render data table
  output$sample_batch <- DT::renderDataTable({
    return(reactive_values$sample_batch())
  })
}
