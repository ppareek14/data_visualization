library(readxl)
library(tidyverse)
library(lubridate)
library(stats)
library(babynames)
library(dplyr)
library("Synth")
library("gsynth")
library("devtools")
library("tidysynth")
rm(list=ls())

## 179 mass shooters from 1966 to 2022 coded on over 100 variables
## 9 States Not in Data Set (Does Include D.C.): Delaware, Maine, Montana, New Mexico, 
## North Dakota, South Dakota, Vermont, West Virginia, and Wyoming

## Comparing Number of Shootings in Each State per Million

## Occurrences Divided by Population per State and Then Multiplied by 10^6
setwd("C:/Users/ecole/Downloads/Ursinus/Data Sets/State Shootings")
States <- read.csv("State Shootings.csv")
colnames(States) <-c("State", "MS/POP", "MS/POP PER MIL")
data <- subset(States, `MS/POP PER MIL`>0.75)
data1<-data[order(-data$`MS/POP PER MIL`), ]
par( mai=c(rep(1, 4)) )
StateShoot <- barplot(data1$`MS/POP PER MIL`, names.arg=data1$State, col="blue", ylim=c(0,5), width=0.4, 
                      ylab="Number of Mass Shootings per Million People")

## Describe each of the top 12 states
