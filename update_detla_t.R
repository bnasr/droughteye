source('required_libs.R')
source('env_vars.R')
source('funcs.R')

this_month <- month(Sys.Date())
this_year <- year(Sys.Date())

for(y in 2001:this_year){
  for(m in 1:12){
    if(y==this_year&m>=this_month) next()
    cat('writing deltaT for', y, m, '\n')
    write_detla_t(y, m, deltat_repo)
  }
}
