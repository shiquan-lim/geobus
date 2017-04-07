library(shiny)
library(rgdal)
library(spatstat)
library(maptools)
library(stplanr)
library(dplyr)

setwd("/Users/limshiquan/Desktop/git projects/geobus")
sgowin <- as.owin(readOGR(dsn = './data/outline', layer = "MP14_PLNG_AREA_WEB_PL"))
busstopscsv <- read.csv("./data/coded_stops.csv")
titosamplecsv <- read.csv("./data/bus_sample.csv")

busstopsppp <- ppp(busstopscsv[,1], busstopscsv[,2], window = sgowin)
busstopsppp <- ppp(busstopscsv[,1], busstopscsv[,2], window = sgowin, marks = busstopscsv[,6])
plot(busstopsppp)

fil1 = filter(titosamplecsv, 230000 < as.numeric(gsub("[: -]", "" , RIDE_START_TIME, perl=TRUE)) & as.numeric(gsub("[: -]", "" , RIDE_START_TIME, perl=TRUE)) < 235910)

busstopscsv$timeden <- sapply(busstopscsv$BUS_STOP_N, FUN=function(x) length(fil1[fil1$BOARDING_STOP_STN==x, "BOARDING_STOP_STN"]))