options(scipen = 123)
library(shiny)
library(shinydashboard)
library(dplyr)
library(glue)
library(ggplot2)
library(tidyr)
library(plotly)
library(lubridate)
library(DT)

steam_games <- read.csv("data_set/steam_player.csv")

steam <- 
  steam_games %>% 
  select(Game, Review.summary, Current.players, Peak.players.today, Release.date, Total.reviews) %>% 
  mutate(Game=as.factor(Game),
         Review.summary=as.factor(Review.summary),
         Release.date=dmy(Release.date)) %>% 
  drop_na(Release.date) 

