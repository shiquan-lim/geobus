library(shiny)
library(rgdal)
library(spatstat)
library(maptools)
library(stplanr)

setwd("/Users/limshiquan/Desktop/git projects/geobus")
sgowin <- as.owin(readOGR(dsn = './data/outline', layer = "MP14_PLNG_AREA_WEB_PL"))
busstopscsv <- read.csv("./data/coded_stops.csv")

busstopssdf <- SpatialPointsDataFrame(busstopscsv[,1:2], busstopscsv)
busstopspts <- coordinates(busstopssdf)
busstopsppp <- ppp(busstopspts[,1], busstopspts[,2], window = sgowin)
plot(busstopsppp)
