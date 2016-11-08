library(shiny)
library(leaflet)
library(reshape)
cityData <- readRDS("fullData.RDS")

shinyUI(fluidPage(
                  headerPanel("Population of US Cities Through History"),
    
                  sidebarPanel(
                      p("Use the slider to select the Year (from 1850 to 2010, in increments of 10)."),
                      p("Use the dropdown menu to choose the State (CA, TX, NY, FL, IL, PA, OH, GA, MI, or NC)."),
                      p("For a given Year and State, the App displays cities on the map*, and color codes them based on the population."),
                      sliderInput(inputId = "year", 
                                  label = "Year:", 
                                  min = 1850, max = 2010, value = 1850, step = 10
                      ),
                      selectInput(inputId = "state",
                                  label = "State:",
                                  choices = unique(cityData$State),
                                 selectize = FALSE,
                                 selected = "CA"
                      ),
                      p(h6("*It takes a few seconds for the map to load."))
                  ),
                  
                  mainPanel(leafletOutput(outputId="mymap"))
                  

))
