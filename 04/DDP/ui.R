#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Some info about mtcars"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
        textInput("NewGraphName", "Enter new plot name", "Horse power versus miles per galon"),
        sliderInput("sliderHP", "Pick Minimum and Maximum horse power",
                    min = min(mtcars$hp)-10, 
                    max = max(mtcars$hp)+10, 
                    value = c(min(mtcars$hp), 
                              max(mtcars$hp)),
                    step = 1
                    ),
        sliderInput("sliderMPG", "Pick Minimum and Maximum mpg value",
                    min = round(min(mtcars$mpg),1),
                    max = round(max(mtcars$mpg),1),
                    value = c(round(min(mtcars$mpg),1),
                              round(max(mtcars$mpg),1)),
                    step = 1),
        checkboxInput("cylCheckBox","Display numbers cylinders", TRUE),
        checkboxInput("carNameCheckBox","Display name of cars on dots", TRUE)
        
    ),
    
    # Show a plot of the generated distribution
    
    mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("Documentation", 
                             br(), "Hi friend",
                             br(), "this simple shiny app was do for data product development of Coursera",
                             br(), "You can see several elements.",
                             br(), "Now you read documentation tab.",
                             br(), "Also this app contains \"plot\" tab with plot shows some info about mtcars dataset",
                             br(), "on side panel you can se several control elements",
                             br(), "1. With text input you can change text on plot tab",
                             br(), "2. Using sliders you can limit plot by X and Y axis",
                             br(), "3. Using checkbox you can disable//enable showing numbers of cylinders on plot",
                             br(), "4. Using last checkbox you can disable//enable showing car names when you point mouse on dots on plot",
                             br(), br(), "Thank you for your attentions. Hope you will use my app easely"),
                    tabPanel("Plot", br(), textOutput("newGraphTitle"), br(),plotlyOutput("distPlot"))
                    )
              )
    
  )
))
