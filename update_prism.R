cat('\n\n=============================================================================================\n')

cat(Sys.time(), '\t updating PRISM ...\n')

source('required_libs.R')
source('env_vars.R')
source('funcs.R')

this_year <- year(Sys.Date())

options(prism.path = prism_repo)

get_prism_monthlys(type="tmean", year = 2001:this_year, mon = 1:12, keepZip=F)

cat(Sys.time(), '\t PRISM done!\n')
