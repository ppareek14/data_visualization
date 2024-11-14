library(shiny)

setwd("C:/Users/ecole/Downloads/Ursinus/Data Sets/U.S. Shootings Including 2018-2022")
df <- read.csv("US Shootings Including 2018-2022 2.csv")

source("MassShootingsFunction.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Mass Shootings Before, During, and After the Pandemic"),
  
  # Sidebar with a slider input for numbers
  sidebarLayout(
    sidebarPanel(selectInput(inputId="Total", 
                             label = "Fatalities or Injuries",
                             choices= c("Injured", "Fatal"),
                             selected="Injured"),
                 
                 selectInput(inputId="Quarters",
                                    label= "Select a Quarter", 
                                    choices=c("Q1", "Q2", "Q3", "Q4"),
                             multiple = TRUE)),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
))

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    h <- get(input$Total)
    injuredq1(graphinput= h , quarters=input$Quarters )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

