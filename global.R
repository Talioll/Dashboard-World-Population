#------------------------------ import library
library(tidyverse)
library(glue)
library(ggpubr)
library(scales)
library(choroplethrMaps)
library(reshape2)
library(plotly)
library(ggthemes)
library(shiny)
library(shinydashboard)

library(dashboardthemes)
library(DT)
library(bslib)
library(shinythemes)
options(scipen = 100)

#----------------------------- read data 

population <- read.csv("Data/world_population.csv")


#----------------------------- data wrangling

population <- population %>% 
  select(-c(Rank, Capital, World.Population.Percentage)) %>% 
  rename(
    `2022` = X2022.Population,
    `2020` = X2020.Population,
    `2015` = X2015.Population,
    `2010` = X2010.Population,
    `2000` = X2000.Population,
    `1990` = X1990.Population,
    `1980` = X1980.Population,
    `1970` = X1970.Population,
    Area   = Area..km..,
    Density = Density..per.km..,
    growthRate = Growth.Rate) %>% 
  mutate(Continent = as.factor(Continent))

selisih <- round(((sum(population$`2022`) - sum(population$`1970`))/sum(population$`1970`))*100,2)

densityFunc <- function(cnt){
  cntdensity <- cnt %>% 
    mutate(`2022` = round(cnt$`2022`/Area,2),
           `2020` = round(cnt$`2020`/Area,2),
           `2015` = round(cnt$`2015`/Area,2),
           `2010` = round(cnt$`2010`/Area,2),
           `2000` = round(cnt$`2000`/Area,2),
           `1990` = round(cnt$`1990`/Area,2),
           `1980` = round(cnt$`1980`/Area,2),
           `1970` = round(cnt$`1970`/Area,2)) %>%
    select(Country,Continent, CCA3, `2022`,`2020`, `2015`, `2010`, `2000`,`1990`, `1980`, `1970`) %>% 
    return(cntdensity)

}
worldDensity <- densityFunc(population)
worldDensity <-  pivot_longer(data = worldDensity,
                              cols = -c(Country, CCA3, Continent),
                              names_to = "Year",
                              values_to = "Density")

medianwgr <- round(median(population$growthRate),2)
yearList <- unique(worldDensity$Year)

