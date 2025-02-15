#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(DT)

# Define UI for application that draws a histogram
ui <- fluidPage(navbarPage(
  "DQ: Data Querier",
  tabPanel(
    "Connect to D3",
    sidebarPanel(
      textInput("uid", "D3 Username:"),
      passwordInput("password", "Password:"),
      fileInput("keyfile", "D3 Keyfile"),
      actionButton("connect", "Connect"),
      #TODO: insert "successful connection" message
    ),
    mainPanel(DT::dataTableOutput(outputId = "test_tab"))
  )
))
