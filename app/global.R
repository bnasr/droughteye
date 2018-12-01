list.of.packages <- c(
  'rgdal',
  'shiny',
  'plotly',
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

source('/home/bijan/Projects/droughteye/env_vars.R')
source('/home/bijan/Projects/droughteye/funcs.R')
source('/home/bijan/Projects/droughteye/colors.R')

data_repo <- '/home/bijan/Projects/droughteye/data/'
