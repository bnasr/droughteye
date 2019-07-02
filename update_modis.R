cat('\n\n=============================================================================================\n')

cat(Sys.time(), '\t updating MODIS ...\n')

source('required_libs.R')
source('env_vars.R')
source('app/funcs.R')


this_month <- month(Sys.Date())
this_year <- year(Sys.Date())

y1 <- ifelse(LST_SOURCE=='TERRA', 2001, 2002)

for(y in y1:this_year){
  
  m1 <- ifelse(LST_SOURCE=='AQUA'&y==2002, 7, 1)
  for(m in m1:12){
    if(y==this_year&m>=this_month) next()
    cat('getting MODIS for', y, m, '\n')
    try(get_LST(year = y, month = m))
  }
}

cat(Sys.time(), '\t MODIS done!\n')
