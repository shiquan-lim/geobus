library(shiny)
library(rgdal)
library(spatstat)
library(maptools)
library(stplanr)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  # Import data into the model
  sgowin <- as.owin(readOGR(dsn = './data/outline', layer = "MP14_PLNG_AREA_WEB_PL"))
  busstopscsv <- read.csv("./data/coded_stops.csv")
  
  # Expression that generates a plot of the distribution. The expression
  # is wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically 
  #     re-executed when inputs change
  #  2) Its output type is a plot 
  #
  output$heatPlot <- renderPlot({
    
    # generate an rnorm distribution and plot it
    busstopssdf <- SpatialPointsDataFrame(busstopscsv[,1:2], busstopscsv)
    busstopspts <- coordinates(busstopssdf)
    busstopsppp <- ppp(busstopspts[,1], busstopspts[,2], window = sgowin)
    plot(busstopsppp)
  })
})