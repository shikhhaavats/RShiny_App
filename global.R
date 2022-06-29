library(shiny)
library(shiny.semantic)
library(dplyr)
library(tidyverse)
library(leaflet)
library(geosphere)
library(DT)
library(lubridate)
library(readr)
library(semantic.dashboard)
library(leaflet)
library(scales)


options(semantic.themes = TRUE)


shipdt <- read_csv("data/ships.csv")
shipdt$status <- ifelse(shipdt$is_parked == "1","Moving","Parked")
shipdt <- shipdt[order(ymd_hms(shipdt$DATETIME)),] 


add_comma <- scales::label_comma(big.mark = ",")
