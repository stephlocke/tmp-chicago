library(dplyr)

iris %>%
  sample_frac(.7) ->
  irisTrain

iris %>%
  anti_join(irisTrain) ->
  irisTest

irisModel<-lm(Sepal.Length~., data=irisTrain)

irisTest %>%
  mutate(prediction=predict(irisModel, irisTest)) ->
  irisPredictions

save(list="irisPredictions", file="irisPredictions.Rdata")

library(ggplot2)
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

library(plotly)
ggplotly(avp)

save(list="irisModel", file="irisModel.Rdata")






