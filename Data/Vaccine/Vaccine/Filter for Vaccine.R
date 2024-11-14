setwd("~/Documents/Ursinus REU")

##Filtering for Vaccine Metrics
library(ggplot2)
library(tidyverse)
library(shiny)
library(plotly)
library(ggthemes)

vaccine_data<- read.csv("vaccine_data.csv")

## Function for Vaccine Metrics by State, by Day
newfunction2 <- function(stateinput, vaccinemetric) {
  
  # Converts character date into numeric date
  vaccine_data$date1 <- as.character(vaccine_data$date)
  vaccine_data$date2 <- as.Date(vaccine_data$date1, "%m/%d/%Y")
  
  trimmed_data <- vaccine_data[vaccine_data$location == stateinput,]
  y_max <- max(vaccine_data[[vaccinemetric]])
  graph <- ggplot(data = trimmed_data,
         aes_string(x = "date2", y = vaccinemetric, col = "location"))+
        geom_point()+
         ylim(0,y_max)+
         scale_y_continuous(name= "People Vaccinated Per Hundred", labels = scales::comma)+
        theme_economist()+
         labs(title = "People Vaccinated Per Hundred Over Time", x = "Date")+
        theme(axis.text = element_text(size = 10), 
              axis.title = element_text(size = 15),
              axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
              plot.margin = margin(t = 20,  # Top margin
                                   r = 30,  # Right margin
                                   b = 20,  # Bottom margin
                                   l = 30)) # Left margin)
  graph
}

newfunction2(c("South Dakota", "Utah", "New York State", "New Mexico"), "people_vaccinated_per_hundred")






