cat('\n\n=============================================================================================\n')

cat(Sys.time(), '\t daily runs started ...\n')

source('update_prism.R')
source('update_modis.R')
source('update_detla_t.R')
source('update_delta_t_normal.R')
source('update_delta_t_anomaly.R')

cat(Sys.time(), '\t daily runs done!\n')
