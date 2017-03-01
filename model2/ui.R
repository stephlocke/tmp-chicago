

# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(plotly)

shinyUI(fluidPage(
  # Application title
  titlePanel("Predicting Iris Sepal Lengths")  ,
  
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "sepalwidth",
        "Sepal Width (cm)",
        min = pmax(0, min(iris$Sepal.Width) - 1),
        max = max(iris$Sepal.Width) + 1,
        value = mean(iris$Sepal.Width)
      ),
      sliderInput(
        "petalwidth",
        "Petal Width (cm)",
        min = pmax(0, min(iris$Petal.Width) - 1),
        max = max(iris$Petal.Width) + 1,
        value = mean(iris$Petal.Width)
      ),
      sliderInput(
        "petallength",
        "Petal Length (cm)",
        min = pmax(0, min(iris$Petal.Length) - 1),
        max = max(iris$Petal.Length) + 1,
        value = mean(iris$Petal.Length)
      ),
      radioButtons(
        "species",
        "Iris species",
        choices = unique(iris$Species),
        selected = "setosa"
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(tabsetPanel(
      tabPanel(
        "High level info",
        h2("Predicted Sepal Length"),
        tableOutput("predictedval"),
        h2("Overall variable distributions"),
        fluidRow(
          column(3, plotOutput("sepalwidthDistPlot")),
          column(3, plotOutput("petalwidthDistPlot")),
          column(3, plotOutput("petallengthDistPlot")),
          column(3, plotOutput("speciesDistPlot"))
        ),
        h2("Sepal Length vs each factor in model"),
        fluidRow(column(6, plotOutput("sepalwidthimpact")),
                 column(6, plotOutput("petalwidthimpact"))),
        fluidRow(column(6, plotOutput(
          "petallengthimpact"
        )),
        column(6, plotOutput("speciesimpact")))
      ),
      tabPanel("Model details",
               h2("Model summary"),
               verbatimTextOutput("modelsummary"),
               h2("Coefficients"),
               tableOutput("modelcoefficients"),
               h2("Actuals vs Predicted"),
               plotlyOutput("predvsact"))
    ))
  )
))
