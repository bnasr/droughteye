cat('\n\n=============================================================================================\n')

cat(Sys.time(), '\t updating summaries ...\n')

source('required_libs.R')
source('env_vars.R')
source('funcs.R')


this_month <- month(Sys.Date())
this_year <- year(Sys.Date())

for(y in 2001:this_year){
  for(m in 1:12){
    if(y==this_year&m>=this_month) next()
    
    cat('getting summaries for', y, m, '\n')
    get_MOD11C3(year = y, month = m, modis_repo = modis_repo)
  }
}

cat(Sys.time(), '\t summaries done!\n')
