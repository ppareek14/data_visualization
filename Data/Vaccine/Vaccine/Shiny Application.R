##Application into Shiny ----------------------------------------------------

library(ggplot2)
library(tidyverse)
library(shiny)


ui <- fluidPage(
  
  titlePanel("COVID-19 Vaccine Statistics Dashboard"),
      
  
 ## State Input
 
 
      sidebarLayout(
        sidebarPanel(
          selectInput(
            inputId = "STA",
            label = "States: Can choose multiple",
            choices = c("Alabama", "Alaska", "Arizona", "Arkansas",
                            "California", "Colorado", "Connecticut", "District of Columbia",
                            "Delaware", "Florida", "Georgia", "Hawaii",
                            "Idaho", "Illinois", "Indiana", "Iowa",
                            "Kansas", "Kentucky", "Louisiana", "Maine",
                            "Maryland","Massachusetts", "Michigan", "Minnesota",
                            "Mississippi","Missouri", "Montana", "Nebraska",
                            "Nevada", "New Hampshire", "New Jersey", "New Mexico",
                            "New York State","North Carolina", "North Dakota", "Ohio",
                            "Oklahoma","Oregon", "Pennsylvania", "Rhode Island",
                            "South Carolina", "South Dakota", "Tennessee", "Texas",
                            "Utah", "Vermont", "Virginia", "Washington",
                            "West Virginia","Wisconsin", "Wyoming", "United States"),
            multiple = TRUE),
        
        
## Vaccine Input 


        sidebarPanel(
          selectInput(
            inputId = "VCC",
            label = "Choose a Metric (totals)",
            choices = list("total_vaccinations", "total_distributed", "people_vaccinated", "people_fully_vaccinated", "daily_vaccinations")),
        
          selectInput(
            inputId = "VCCC",
            label = "Choose a Metric (rates)",
            choices = list("total_vaccinations_per_hundred", "distributed_per_hundred", "people_vaccinated_per_hundred", "people_fully_vaccinated_per_hundred", "daily_vaccinations_per_million"))

)),

mainPanel(
plotOutput(outputId = "vaccinegraph"),

plotOutput(outputId = "vaccinegraphrates")
)

))

## Server


server <- function(input, output) {
 output$vaccinegraph <- renderPlot(
   newfunction2(input$STA, vaccinemetric = (input$VCC)),
   
 )
 (
 output$vaccinegraphrates <- renderPlot(
   newfunction2(input$STA, vaccinemetric = (input$VCCC))
 )
   
 )   
 
}
  

shinyApp(ui = ui, server = server)

