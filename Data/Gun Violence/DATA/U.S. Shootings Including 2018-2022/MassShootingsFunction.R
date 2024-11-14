library(tidyverse)
library(lubridate)
library(stats)
library(babynames)
library(dplyr)
library(ggplot2)
rm(list=ls())

## INJURIES
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
  index<-c(4,8,12,16)
  q1=q2=q3=q4=quarters
  q1[-(index+2)]<-NA
  q2[-(index+3)]<-NA
  q3[-(index)]<-NA
  q4[-(index+1)]<-NA
  rbind(quarters, q1,q2,q3,q4)
  
  ##GGPlot
  Injuries <- tibble::rownames_to_column(ts_q,'Quarters')
  Injured <-(Injuries)[-(1:3),]%>% separate(Quarters, c("Year", "Quarters"))
  Injured <-tibble::rownames_to_column(Injured,'Index')
  ggplot(data=Injured, aes(x=Year, y=V1, fill=Quarters))+
    geom_col(
      position="dodge"
    )

## FATALITIES
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
  
  ## Organizing NKilled and the Dates into one set
  library(xts)
  ts_k<-xts(NKilled,gfg_quarters)
  ts_km<-apply.monthly(ts_k,sum)
  ts_kq1<-apply.quarterly(ts_k,sum)
  ts_ky<-apply.yearly(ts_k,sum)
  
  ##Creating Each Quarter
  ts_kq<-as.data.frame(ts_kq1)
  quarters<-ts_kq$V1
  index<-c(4,8,12,16)
  q1=q2=q3=q4=quarters
  q1[-(index+2)]<-NA
  q2[-(index+3)]<-NA
  q3[-(index)]<-NA
  q4[-(index+1)]<-NA
  rbind(quarters, q1,q2,q3,q4)
  
  ##GGPlot
  Killed <- tibble::rownames_to_column(ts_kq,'Quarters')
  Fatal <- (Killed)[-(1:3),] %>% separate(Quarters, c("Year", "Quarters"))
  Fatal <-tibble::rownames_to_column(Fatal,'Index')
  ggplot(data=Fatal[], aes(x=Year, y=V1, fill=Quarters))+
    geom_col(
      position="dodge"
    )

## Function
injuredq1 <- function(graphinput=Injured,quarters="Q1"){
  ggplot(data=graphinput[graphinput$Quarters %in% quarters,], aes(x=Year,y=V1,fill=Quarters))+
    geom_col(position="dodge")
}

