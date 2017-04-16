library(shiny)
library(shinyTime)

# Define UI for application that plots random distributions 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Geobus analytic application beta 2.0"),
  fluidRow(
    column(8,
           plotOutput("heatPlot")
    ),
    column(4,
           plotOutput("serviceDen"))
  ),
  fluidRow(
    column(5, 
           textInput("svcnum", label = h3("Select bus number"), 
                     value = "166"),
           timeInput("timewin", "Time:", value = strptime("18:30:00", "%T"))
           ),
    column(4,
           sliderInput("obswindow", label = h3("Observation Window (minutes)"),
                       min = 1, max = 60, value = 60))
  )
))