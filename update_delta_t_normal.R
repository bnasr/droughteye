cat('\n\n=============================================================================================\n')

cat(Sys.time(), '\t updating delta_t_normal ...\n')

source('required_libs.R')
source('env_vars.R')
source('app/funcs.R')

for(m in 1:12){
  cat('writing deltaT normal for', m, '\n')
  write_delta_t_normal(m)
}

cat(Sys.time(), '\t delta_t_normal done!\n')
