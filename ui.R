library(shiny)
library(shinyTime)

# Define UI for application that plots random distributions 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Geobus analytic application beta 1.0"),
  fluidRow(
    column(2,
           radioButtons("analtype", label = h3("Select Analysis"), choices = list("Human density at bus stops" = 1, "Under-serviced bus stops" = 2), selected = 1)),
    column(10,
           plotOutput("heatPlot")
    )
  ),
  fluidRow(
    column(5, 
           dateInput("date", 
                     label = h3("Date input"), 
                     value = "2016-02-15"),
           timeInput("timewin", "Time:", value = strptime("13:34:56", "%T"))
           ),
    column(4,
           sliderInput("obswindow", label = h3("Obervsation Window (minutes)"),
                       min = 1, max = 60, value = 10))
  )
))