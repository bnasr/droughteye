cat('\n\n=============================================================================================\n')

cat(Sys.time(), '\t updating delta_t_anomaly ...\n')

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
    cat('writing deltaT for', y, m, '\n')
    write_delta_t_anomaly(y, m)
  }
}

cat(Sys.time(), '\t delta_t_anomaly done!\n')
