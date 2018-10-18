cat('\n\n=============================================================================================\n')

cat(Sys.time(), '\t updating delta_t_normal ...\n')

source('required_libs.R')
source('env_vars.R')
source('funcs.R')

for(m in 1:12){
  cat('writing deltaT normal for', m, '\n')
  write_detla_t_normal(m, deltat_repo)
}

cat(Sys.time(), '\t delta_t_normal done!\n')
