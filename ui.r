library(shiny)
library(leaflet)
library(reshape)
cityData <- readRDS("fullData.RDS")

shinyUI(fluidPage(
    
                  sidebarPanel(
                      sliderInput(inputId = "year", 
                                  label = "Year:", 
                                  min = 1790, max = 2010, value = 1790, step = 10
                      ),
                      selectInput(inputId = "state",
                                  label = "State:",
                                  choices = unique(cityData$State),
                                 selectize = FALSE,
                                 selected = "CA"
                      )
                  ),
                  
                  mainPanel(leafletOutput(outputId="mymap"))
                  

))