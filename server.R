library(shiny)
library(rgdal)
library(spatstat)
library(maptools)
library(stplanr)
library(dplyr)
library(ggmap)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  # Import data into the model
  sgowin <- as.owin(readOGR(dsn = './data/outline', layer = "MP14_PLNG_AREA_WEB_PL"))
  sgosm <- get_map("singapore")
  busstopscsv <- read.csv("./data/coded_stops.csv")
  titosamplecsv <- read.csv("./data/bus_sample.csv")
  
  # Expression that generates a plot of the distribution. The expression
  # is wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically 
  #     re-executed when inputs change
  #  2) Its output type is a plot 
  #
  output$heatPlot <- renderPlot({
    #filter tito rows by time input
    timewin = input$timewin
    fil = filter(titosamplecsv, as.numeric(gsub("[: -]", "" , RIDE_START_TIME, perl=TRUE)) > timewin-120, as.numeric(gsub("[: -]", "" , RIDE_START_TIME, perl=TRUE)) < timewin+120)
    busstopscsv$timeden <- sapply(busstopscsv$BUS_STOP_N, FUN=function(x) length(fil[fil$BOARDING_STOP_STN==x, "BOARDING_STOP_STN"]))
    ggmap(sgosm, zoom = 11, extent = "device", legend = "topleft")
  })
  
  output$serviceden <- renderPlot({
    #busstopsppp <- ppp(busstopscsv[,1], busstopscsv[,2], window = sgowin, marks = busstopscsv[,6])
    busstopsppp <- ppp(busstopscsv[,1], busstopscsv[,2], window = sgowin)
    plot(busstopsppp)
  })
})