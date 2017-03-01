
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(plotly)
load("irisModel.Rdata")
load("irisPredictions.Rdata")
shinyServer(function(input, output) {

  newData <- reactive({
    data.frame(
      Sepal.Width = input$sepalwidth,
      Petal.Width = input$petalwidth,
      Petal.Length = input$petallength,
      Species = input$species
    )
  })
  predictedData<-reactive({
    Sepal.Length <- predict(irisModel, newData())
    cbind(newData() ,
          Sepal.Length
          )
  })
  
  output$predictedval<-renderTable({predictedData()})
    
  output$modelsummary<-renderPrint({
    summary(irisModel)
  })
  output$modelcoefficients<-renderTable({
    data.frame( Attribute = gsub("Species","",names(coef(irisModel))), 
                Coefficient = coef(irisModel) )
  })
  output$predvsact<-renderPlotly({
    avp<- ggplot(irisPredictions, aes(x=Sepal.Length, y=prediction))+
      geom_point(size = 2) +
      geom_abline(aes(intercept =0, slope=1), colour="red",
                  linetype="dashed")+
      theme_minimal()+
      labs(title = "Actual vs Predicted Sepal Lengths",
           x= "Actual Sepal Length (cm)",
           y= "Predicted Sepal Length (cm)")+
      scale_x_continuous(breaks=5:7, labels=5:7, 
                         minor_breaks = NULL)+
      scale_y_continuous(breaks=5:7, labels=5:7, 
                         minor_breaks = NULL)
    
    ggplotly(avp)
  })
    
  output$sepalwidthDistPlot <- renderPlot({
    ggplot(data=iris, aes(x=Sepal.Width))+
      geom_density(fill="blue", colour="blue",alpha=.2)+
      geom_vline(aes(xintercept=input$sepalwidth),
                 colour="red", linetype="dashed",
                 size=2)+
      theme_minimal()
  })
  output$petalwidthDistPlot <- renderPlot({
    ggplot(data=iris, aes(x=Petal.Width))+
      geom_density(fill="blue", colour="blue",alpha=.2)+
      geom_vline(aes(xintercept=input$petalwidth),
                 colour="red", linetype="dashed",
                 size=2)+
      theme_minimal()
  })
  output$petallengthDistPlot <- renderPlot({
    ggplot(data=iris, aes(x=Petal.Length))+
      geom_density(fill="blue", colour="blue",alpha=.2)+
      geom_vline(aes(xintercept=input$petallength),
                 colour="red", linetype="dashed",
                 size=2)+
      theme_minimal()
  })
  output$speciesDistPlot<-renderPlot({
    ggplot(data=iris, aes(x=Species))+
      geom_bar(fill="blue", colour="blue",alpha=.2)+
      geom_bar(data=iris[iris$Species==input$species,],
               fill="red", colour="red",alpha=.2)+
      theme_minimal()
  })
  
  output$sepalwidthimpact<-renderPlot({
    ggplot(iris, aes(x=Sepal.Width, y=Sepal.Length,
                     group=Species, colour=Species))+
      geom_point()+
      geom_point(data=predictedData(), 
                 colour="red", size=5)+
      theme_minimal()+
      theme(legend.position = "none")
  })
  output$petalwidthimpact<-renderPlot({
    ggplot(iris, aes(x=Petal.Width, y=Sepal.Length,
                     group=Species, colour=Species))+
      geom_point()+
      geom_point(data=predictedData(), 
                 colour="red", size=5)+
      theme_minimal()+
      theme(legend.position = "none")
  })  
  output$petallengthimpact<-renderPlot({
    ggplot(iris, aes(x=Petal.Length, y=Sepal.Length,
                     group=Species, colour=Species))+
      geom_point()+
      geom_point(data=predictedData(), 
                 colour="red", size=5)+
      theme_minimal()+
      theme(legend.position = "none")
  })
  output$speciesimpact<-renderPlot({
    ggplot(iris, aes(x=Sepal.Length, group=Species,
                     colour=Species, fill=Species))+
      geom_density(alpha=.2)+
      geom_vline(data=predictedData(),
                 aes(xintercept=Sepal.Length),
                 colour="red", size=2, 
                 linetype="dashed")+
      facet_wrap(~Species, ncol=2)+
      theme_minimal()+
      theme(legend.position = "none")
  })

})
