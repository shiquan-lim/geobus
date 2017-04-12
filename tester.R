library(shiny)
library(rgdal)
library(spatstat)
library(maptools)
library(stplanr)
library(dplyr)
library(ggmap)
library(proj4)
#proj4string <- "+proj=utm +zone=48N +ellps=WGS84 +datum=WGS84 +units=m +no_defs "
proj4string <- "+proj=tmerc +lat_0=1.366666666666667 +lon_0=103.8333333333333 +k=1 +x_0=28001.642 +y_0=38744.572 +datum=WGS84 +units=m +no_defs"

setwd("/Users/limshiquan/Desktop/git projects/geobus")
sgowin <- as.owin(readOGR(dsn = './data/outline', layer = "MP14_PLNG_AREA_WEB_PL"))
busstopscsv <- read.csv("./data/coded_stops.csv")
titosamplecsv <- read.csv("./data/bus_sample.csv")
sgosm <- get_map("singapore", zoom = 11)
sgmap <- ggmap(sgosm, extent = "device", legend = "topleft")

busstopsppp <- ppp(busstopscsv[,1], busstopscsv[,2], window = sgowin)
busstopsppp <- ppp(busstopscsv[,1], busstopscsv[,2], window = sgowin, marks = busstopscsv[,6])
plot(busstopsppp)

fil = filter(titosamplecsv, 230000 < as.numeric(gsub("[: -]", "" , RIDE_START_TIME, perl=TRUE)) & as.numeric(gsub("[: -]", "" , RIDE_START_TIME, perl=TRUE)) < 235910)

#busstopscsv$timeden <- sapply(busstopscsv$BUS_STOP_N, FUN=function(x) length(fil1[fil1$BOARDING_STOP_STN==x, "BOARDING_STOP_STN"]))

fil$x <- busstopscsv$X[match(fil$BOARDING_STOP_STN, busstopscsv$BUS_STOP_N)]
fil$y <- busstopscsv$Y[match(fil$BOARDING_STOP_STN, busstopscsv$BUS_STOP_N)]

#convert to lat long
converted <- project(busstopscsv, proj4string, inverse = TRUE)
busstopscsv$long <- converted$y
busstopscsv$lat <- converted$x

holding <- subset(fil, select = c(9,10))
converted <- project(holding, proj4string, inverse = TRUE)
fil$long <- converted$y
fil$lat <- converted$x

overlay <- stat_density2d(aes(x= lat, y = long, fill = ..level.., alpha = ..level..), bins = 10, geom = "polygon", data = fil)
#overlay <- geom_point(data=busstopscsv, aes(x=lat,y=long,size=timeden), alpha = 0.3, size = 0.1)
sgmap + overlay  + scale_fill_gradient(low = "black", high = "red") + ggtitle("Human density at bus stops")
