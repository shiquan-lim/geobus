library(shiny)
library(rgdal)
library(spatstat)
library(maptools)
library(stplanr)
library(dplyr)
library(ggmap)
library(proj4)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  # Import data into the model
  sgowin <- as.owin(readOGR(dsn = './data/outline', layer = "MP14_PLNG_AREA_WEB_PL"))
  sgosm <- get_map("singapore", zoom = 11)
  sgmap <- ggmap(sgosm, extent = "device")
  busstopscsv <- read.csv("./data/coded_stops.csv")
  titosamplecsv <- read.csv("./data/City_Nation_Ride_Data.csv")
  
  #set xy -> latlong conversion string
  proj4string <- "+proj=tmerc +lat_0=1.366666666666667 +lon_0=103.8333333333333 +k=1 +x_0=28001.642 +y_0=38744.572 +datum=WGS84 +units=m +no_defs"
  
  # Expression that generates a plot of the distribution. The expression
  # is wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically 
  #     re-executed when inputs change
  #  2) Its output type is a plot 
  #
  output$heatPlot <- renderPlot({
    #filter tito rows by time input
    timewin = strftime(input$timewin, format="%H:%M:%OS")
    fil = filter(titosamplecsv, as.numeric(gsub("[: -]", "" , timewin, perl=TRUE))-(input$obswindow*60) < as.numeric(gsub("[: -]", "" , RIDE_START_TIME, perl=TRUE)) & as.numeric(gsub("[: -]", "" , RIDE_START_TIME, perl=TRUE)) < as.numeric(gsub("[: -]", "" , timewin, perl=TRUE)))
    fil = filter(fil, ACTUAL_SRVC_NUMBER == input$svcnum)
    #assosciate each bus stop to a density value at the particular time window
    #busstopscsv$timeden <- sapply(busstopscsv$BUS_STOP_N, FUN=function(x) length(fil[fil$BOARDING_STOP_STN==x, "BOARDING_STOP_STN"]))
    fil$x <- busstopscsv$X[match(fil$BOARDING_STOP_STN, busstopscsv$BUS_STOP_N)]
    fil$y <- busstopscsv$Y[match(fil$BOARDING_STOP_STN, busstopscsv$BUS_STOP_N)]
    
    #convert xy to latlong
    holding <- subset(fil, select = c(9,10))
    converted <- project(holding, proj4string, inverse = TRUE)
    fil$long <- converted$y
    fil$lat <- converted$x
    
    #create overlay layer
    overlay <- stat_density2d(aes(x= lat, y = long, fill = ..level.., alpha = ..level..), bins = 10, geom = "polygon", data = fil)
    sgmap + overlay  + scale_fill_gradient(low = "black", high = "red") + ggtitle("Human density at bus stops")
  })
  
  output$serviceDen <- renderPlot({
    timewin = strftime(input$timewin, format="%H:%M:%OS")
    fil2 = filter(titosamplecsv, as.numeric(gsub("[: -]", "" , timewin, perl=TRUE))-(input$obswindow*60) < as.numeric(gsub("[: -]", "" , RIDE_START_TIME, perl=TRUE)) & as.numeric(gsub("[: -]", "" , RIDE_START_TIME, perl=TRUE)) < as.numeric(gsub("[: -]", "" , timewin, perl=TRUE)))
    fil2 = filter(fil2, ACTUAL_SRVC_NUMBER == input$svcnum)
    fil2$bwin <- substring(fil2$RIDE_START_TIME, 1, 5)
    fil2 <- fil2[!duplicated(fil2$bwin),]
    
    fil2$x <- busstopscsv$X[match(fil2$BOARDING_STOP_STN, busstopscsv$BUS_STOP_N)]
    fil2$y <- busstopscsv$Y[match(fil2$BOARDING_STOP_STN, busstopscsv$BUS_STOP_N)]
    
    stopfreqppp <- ppp(fil2[,10], fil2[,11], window = sgowin)
    
    plot(quadratcount(stopfreqppp, 12))
  })
})