library(shiny)
library(shinyTime)

# Define UI for application that plots random distributions 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Geobus analytic application beta 1.0"),
  fluidRow(
    column(12,
           plotOutput("heatPlot")
    )
  ),
  fluidRow(
    column(5, 
           dateInput("date", 
                     label = h3("Date input"), 
                     value = "2016-02-15"),
           timeInput("timewin", "Time:", value = strptime("12:34:56", "%T"))
           )
  )
))