library(tidyverse)
library(lubridate)
library(stats)
library(babynames)
library(dplyr)
library(ggplot2)
rm(list=ls())

EdGraph1 <- function(){
  setwd("C:/Users/ecole/Downloads/Ursinus/Data Sets/U.S. Shootings Including 2018-2022")
  df <- read.csv("US Shootings Including 2018-2022 2.csv")
  
  ## Don't have to define variables with $ if using attach
  attach(df)
  df[,2]<-dmy(Date)
  attach(df)
  
  ## NEED DATES AT BOTTOM TO BE IN QUARTERS/ NOT IN DATES
  library(zoo)
  gfg_date=as.Date(Date)
  gfg_quarters <-as.yearqtr(gfg_date,format = "%Y-%m-%d")
  
  ## Organizing the Injured and the Dates into one set
  library(xts)
  ts<-xts(X..Injured,gfg_quarters)
  ts_m<-apply.monthly(ts,sum)
  ts_q1<-apply.quarterly(ts,sum)
  ts_y<-apply.yearly(ts,sum)
  
  ##Creating Each Quarter
  ts_q<-as.data.frame(ts_q1)
  quarters<-ts_q$V1
  index<-c(2,6,10,14)
  q1=q2=q3=q4=quarters
  q1[-index]<-NA
  q2[-(index+1)]<-NA
  q3[-(index+2)]<-NA
  q4[-(index+3)]<-NA
  rbind(quarters, q1,q2,q3,q4)
  
  #THE GRAPH
  EdFig<-barplot(ts_q1, main="The Number of Injuries Caused by Mass Shootings (Per Quarter/Year)", xlab="Quarter/Year", ylab="Number of Injuries", col="blue", density=20, ylim=c(0,1150))
  points(q1, col="black", type="p", pch=15, cex=1.5, x=EdFig)
  points(q2, col="blue", type="p", pch=16, cex=1.5, x=EdFig)
  points(q3, col="red", type="p", pch=17, cex=1.5, x=EdFig)
  points(q4, col="brown", type="p", pch=18, cex=2, x=EdFig)
  legend("topleft", c("Quarter 1", "Quarter 2", "Quarter 3", "Quarter 4"),
       pch=c(15,16,17,18),
       cex=1.5,
       col = c("black", "blue", "red", "brown"))
}

EdGraph2 <- function(){
  setwd("C:/Users/ecole/Downloads/Ursinus/Data Sets/U.S. Shootings Including 2018-2022")
  df <- read.csv("US Shootings Including 2018-2022 2.csv")
  
  ## Don't have to define variables with $ if using attach
  attach(df)
  df[,2]<-dmy(Date)
  attach(df)
  
  ## NEED DATES AT BOTTOM TO BE IN QUARTERS/ NOT IN DATES
  library(zoo)
  gfg_date=as.Date(Date)
  gfg_quarters <-as.yearqtr(gfg_date,format = "%Y-%m-%d")
  
  ## Organizing the Injured and the Dates into one set
  library(xts)
  ts<-xts(NKilled,gfg_quarters)
  ts_m<-apply.monthly(ts,sum)
  ts_q1<-apply.quarterly(ts,sum)
  ts_y<-apply.yearly(ts,sum)
  
  ##Creating Each Quarter
  ts_q<-as.data.frame(ts_q1)
  quarters<-ts_q$V1
  index<-c(2,6,10,14)
  q1=q2=q3=q4=quarters
  q1[-index]<-NA
  q2[-(index+1)]<-NA
  q3[-(index+2)]<-NA
  q4[-(index+3)]<-NA
  rbind(quarters, q1,q2,q3,q4)
  
  ##THE GRAPH
  EdFig<-barplot(ts_q1, main="The Number of Fatalities Caused by Mass Shootings (Per Quarter/Year)", xlab="Quarter/Year", ylab="Number of Fatalities", col="blue", density=20, ylim=c(0,250))
  points(q1, col="black", type="p", pch=15, cex=1.5, x=EdFig)
  points(q2, col="blue", type="p", pch=16, cex=1.5, x=EdFig)
  points(q3, col="red", type="p", pch=17, cex=1.5, x=EdFig)
  points(q4, col="brown", type="p", pch=18, cex=2, x=EdFig)
  legend("topleft", c("Quarter 1", "Quarter 2", "Quarter 3", "Quarter 4"),
       pch=c(15,16,17,18),
       cex=1.5,
       col = c("black", "blue", "red", "brown"))
}

## Function to Change Between Fatal and Injured Graphs
EdGraph<-function(x_input){
  if(x_input==1 | x_input== "Injured"){
    EdGraph1()
  }else{
    EdGraph2()
  }
}


