library(shiny)
library(leaflet)
library(reshape)


# cityData <- read.csv("fullData.csv",header = FALSE,skip=1,stringsAsFactors = FALSE)
# cityData <- cityData[,c(2:27,31,32)]
# names(cityData) <- c("State", "City", "CityState",as.character(seq(1790,2010,10)),"Lat","Long")
# cityData <- melt(cityData, id = c("State","City","CityState","Lat","Long"))
# names(cityData)[c(6,7)] <- c("Year","Population")
# cityData$Year <- as.numeric(as.character(cityData$Year))
# cityData <- na.omit(cityData)
# 
# # Remove Cities with LatLong=0,0
# cityData <- cityData[which(cityData$Lat!=0 | cityData$Long!=0),]
# # Extract Only Data with Particular States
# cityData <- cityData[which(cityData$State %in% c('CA','TX','NY','FL','IL',
#                                                  'PA','OH','GA','MI','NC')),]
# # Extract Only Data with Year>=1850
# cityData <- cityData[which(cityData$Year>=1850),]
# # Extract Only Data with Population > 100
# cityData <- cityData[which(cityData$Population>100),]
# saveRDS(cityData,"fullData.RDS")

cityData <- readRDS("fullData.RDS")

binValues <- c(0,10^3,10^4,10^5,10^6,10^7)
uniqueValues <- unique(cityData$Population)
pal <- colorBin(palette = c("blue", "yellow", "red"), domain = uniqueValues, 
                bins = binValues , pretty = FALSE, 
                na.color = "transparent")


shinyServer(function(input, output, session){
    
    mymap <- leaflet() %>%
        addProviderTiles(provider="Esri.NatGeoWorldMap") %>%
        addCircleMarkers(lng = cityData$Long,
                         lat = cityData$Lat,
                         fillColor = pal(cityData$Population),
                         fillOpacity = 1,
                         radius = 3,
                         color = pal(cityData$Population)) %>%
        addLegend("bottomleft", pal = pal, values = uniqueValues, opacity = 1)
    
    observe({
        cityDataPlot <- cityData[which(cityData$Year==input$year & cityData$State==input$state),]
        
        
        if (nrow(cityDataPlot)==0){
            leafletProxy("mymap") %>% clearMarkers()
        }
        
        else {
            
            leafletProxy("mymap") %>% clearMarkers() %>% 
                addCircleMarkers(lng = cityDataPlot$Long,
                                 lat = cityDataPlot$Lat,
                                 fillColor =  pal(cityDataPlot$Population),
                                 fillOpacity = 1,
                                 radius = 3,
                                 color = pal(cityDataPlot$Population))
                
        }
    })
    
    output$mymap <- renderLeaflet(mymap)
    
    
})