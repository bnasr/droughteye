list.of.packages <- c(
  'data.table',
  'gdalUtils',
  'lubridate',
  'prism',
  'raster',
  'rgdal',
  'rvest',
  'xml2'
)

new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos='http://cran.rstudio.com/')

mapply(FUN = library, list.of.packages, character.only = T)
