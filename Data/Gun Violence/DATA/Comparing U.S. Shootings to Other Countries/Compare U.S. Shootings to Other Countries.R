library(readxl)
library(tidyverse)
library(lubridate)
library(stats)
library(babynames)
library(dplyr)
library("ggplot2") 
library("gridExtra")
rm(list=ls())

## Reading In the Data
## U.S. (n=78) 
## Twenty-Four other developed countries (n=41)
## Collected between 1998 and 2019
setwd("C:/Users/ecole/Downloads/Ursinus/Data Sets/Comparing U.S. Shootings to Other Countries")

## Shooter Outcomes and Locations
layout(matrix(c(1,2,3,4,5,5), ncol=2, nrow=3, byrow=TRUE) , height=c(4,4,1) )
par( mai=c(rep(0.7, 4)) )
Results <- read.csv("Results.csv")
colnames(Results) <-c('Results',"Mean", "Std", "Mean1", "Std1", "X2 T-test")
Motive <- read.csv("Motive.csv")
colnames(Motive) <-c('Motive',"Mean", "Std", "Mean1", "Std1", "X2 T-test")
ShooterUS <- barplot(Results$Mean, names.arg=Results$Results, main = "USA", col="blue", ylim=c(0,0.5), ylab="Percent of Shootings")
mtext(side=3, line=0.1, adj=0.5, "Shooter Outcomes", cex=1)
Shooter1 <- barplot(Results$Mean1, names.arg=Results$Results, main = "24 Developed Countries", col="red", ylim=c(0,0.5), ylab="Percent of Shootings")
mtext(side=3, line=0.1, adj=0.5, "Shooter Outcomes", cex=1)
MotiveUS <- barplot(Motive$Mean, names.arg=Motive$Motive,main = "US", col="blue", ylab="Percent of Shootings")
mtext(side=3, line=0.1, adj=0.5, "Motive", cex=1)
Motvie1 <- barplot(Motive$Mean1, names.arg=Motive$Motive, main = "24 Developed Countries", col="red", ylab="Percent of Shootings")
mtext(side=3, line=0.1, adj=0.5, "Motive", cex=1)
par(mai=c(0,0,0,0))
plot.new()
legend(x="center", ncol=2,legend=c("USA","24 Other Developed Countries"),
       fill=c("blue","red"), bty="n", cex=2)

## SHOOTER OUTCOMES
# The shooter outcomes in the U.S. versus the rest of the world are significantly different in the 
# Survived and Suicide categories with t-values 
# of 3.01 and 2.79 respectively. 

## MOTIVES
# The motives for mass shooters in the U.S. and the rest of the world are significantly different in the 
# employment/financial, fame-seeking, relationship problems, and ideological categories with t-values
# of 16.06, 8.15, 7.02, and 4.30 respectively.

## Location and Perpetrators
layout(matrix(c(1,2,3,4,5,5), ncol=2, nrow=3, byrow=TRUE), heights=c(4,4,1)  )
par( mai=c(rep(0.7, 4)) )
Perp <- read.csv("Perpetrator.csv")
colnames(Perp) <-c('Perpetrator',"Mean", "Std", "Mean1", "Std1", "X2 T-test")
Location <- read.csv("Location.csv")
colnames(Location) <-c('Location',"Mean", "Std", "Mean1", "Std1", "X2 T-test")
PerpUS <- barplot(Perp$Mean, names.arg=Perp$Perpetrator, main = "US", col="blue", ylim=c(0,0.3), ylab="Percent of Shootings")
mtext(side=3, line=0.1, adj=0.5, "Perpetrator", cex=0.8)
Perp1 <- barplot(Perp$Mean1, names.arg=Perp$Perpetrator, main = "24 Developed Countries", col="red", ylim=c(0,0.5), ylab="Percent of Shootings")
mtext(side=3, line=0.1, adj=0.5, "Perpetrator", cex=0.8)
LocationUS <- barplot(Location$Mean, names.arg=Location$Location, main = "US", col="blue", ylab="Percent of Shootings")
mtext(side=3, line=0.1, adj=0.5, "Location", cex=0.8)
Location1 <- barplot(Location$Mean1, names.arg=Location$Location, main = "24 Developed Countries", col="red", ylab="Percent of Shootings")
mtext(side=3, line=0.1, adj=0.5, "Location", cex=0.8)
par(mai=c(0,0,0,0))
plot.new()
legend(x="center", ncol=2,legend=c("USA","24 Other Developed Countries"),
       fill=c("blue","red"), bty="n", cex=1.5)

## LOCATIONS
# The types of locations where mass shootings took place in the U.S. and the rest of the world
# are significantly different in the 
# military/police, workplace, open-space, school, and outside categories with t-values
# of 29.73, 16.99, 14.59, 5.51, and 4 respectively. 

## PERPETRATORS
# The type of perpetrator descriptions in the U.S. and the rest of the world are significantly different in the 
# Law enforcement history, military history, foreign-born, and female categories with t-values
# of 10.20, 9.25, 8.56, and 6.87 respectively. 

