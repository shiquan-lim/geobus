library(rgdal)
library(spatstat)
library(maptools)
library(stplanr)

setwd("/Users/limshiquan/Desktop/git projects/geobus")
sgowin <- as.owin(readOGR(dsn = './data/outline', layer = "MP14_PLNG_AREA_WEB_PL"))
busstopscsv <- read.csv("./data/coded_stops.csv")
titosamplecsv <- read.csv("./data/City_Nation_Ride_Data.csv")

fil2 = filter(titosamplecsv, titosamplecsv$ACTUAL_SRVC_NUMBER == "166")
fil2$bwin <- substring(fil2$RIDE_START_TIME, 1, 5)
fil2 <- fil2[!duplicated(fil2$bwin),]

fil2$x <- busstopscsv$X[match(fil2$BOARDING_STOP_STN, busstopscsv$BUS_STOP_N)]
fil2$y <- busstopscsv$Y[match(fil2$BOARDING_STOP_STN, busstopscsv$BUS_STOP_N)]

stopfreqppp <- ppp(fil2[,10], fil2[,11], window = sgowin)

plot(quadratcount(stopfreqppp))
fitx = kppm(stopfreqppp)
plot(quadrat.test(stopfreqppp, fit=fitx))

sgosm <- get_map("singapore", source = "osm", zoom = 11)
sgmap <- ggmap(sgosm) + scale_y_continuous(limits=c(1.24, 1.465)) + scale_x_continuous(limits = c(103.6, 104.05))
print(sgmap)
