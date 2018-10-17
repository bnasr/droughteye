library(prism)

source('env_vars.R')

this_year <- year(Sys.Date())

options(prism.path = prism_repo)

get_prism_monthlys(type="tmean", year = 2001:this_year, mon = 1:12, keepZip=F)
