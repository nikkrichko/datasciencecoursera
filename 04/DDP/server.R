#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlotly({
    
    # generate bins based on input$bins from ui.R
    #x    <- faithful[, 2] 
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    #hist(x, breaks = bins, col = 'darkgray', border = 'white')
      
      minMPG <- input$sliderMPG[1]
      maxMPG <- input$sliderMPG[2]
      
      minHP <- input$sliderHP[1]
      maxHP <- input$sliderHP[2]
      
      mtcars <- subset(mtcars, mtcars$mpg >= minMPG & mtcars$mpg <= maxMPG+2)
      mtcars <- subset(mtcars, mtcars$hp >= minHP & mtcars$hp <= maxHP+2)
      
      mtcars$am <- as.factor(mtcars$am)
      levels(mtcars$am) <- c("automatic", "manual")
      
      showCarNames <- if(input$carNameCheckBox) rownames(mtcars) else NA
      showCyl <- if(input$cylCheckBox) as.factor(mtcars$cyl) else  "red"
      
      
      plot_ly(mtcars, 
              x = mtcars$mpg,
              y=mtcars$hp, 
              text = showCarNames, 
              size = mtcars$mpg*2, 
              symbol = as.factor(mtcars$am),
              color = showCyl, 
              mode = "markers", 
              type = "scatter" )
  })
  
  output$newGraphTitle <- renderText({
      input$NewGraphName
  })
  
  output$documentation <- renderText({
      paste("hello world",  "other world")
      
  })
  
})
