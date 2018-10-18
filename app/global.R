list.of.packages <- c(
  'rgdal',
  'shiny',
  # 'shinyjs',
  # 'shinyBS',
  # 'shinyAce',
  # 'shinyTime',
  # 'shinyFiles',
  'shinydashboard',
  'shinythemes',
  'lubridate',
  'shape',
  'fields',
  'sp',
  # 'maps',
  'raster'
)

new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

if(length(new.packages)) install.packages(new.packages, repos='http://cran.rstudio.com/')

for(p in list.of.packages) library(p, character.only = T)

source('~/Projects/droughteye/env_vars.R')
source('~/Projects/droughteye/funcs.R')
source('~/Projects/droughteye/colors.R')
