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

## Comparing Number of Shootings in Each State
setwd("C:/Users/ecole/Downloads/Ursinus/Data Sets/Mass Shooters")
States <- read.csv("States.csv")
colnames(States) <-c("State")
barplot(table(States$State), main = "Comparing Number of Shootings in Each State", col="blue", ylim=c(0,30))
table(States$State)

