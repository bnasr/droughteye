cat('\n\n=============================================================================================\n')

cat(Sys.time(), '\t updating summaries ...\n')

source('required_libs.R')
source('env_vars.R')
source('funcs.R')


phys <- raster::shapefile(paste0(data_repo, 'physio/physio.shp'))

this_month <- month(Sys.Date())
this_year <- year(Sys.Date())

for(y in 2001:this_year){
  for(m in 1:12){
    if(y==this_year&m>=this_month) next()
    for(type in c('delta', 'normal', 'anomaly')){
      cat('getting summaries for', type, y, m, '\n')
      path <- switch (type,
                      'delta' = sprintf(fmt = '%sDELTA/DELTAT.%04d.%02d.01.tif', deltat_repo, y, m),
                      'normal' = sprintf(fmt = '%sNORMAL/DELTAT.NORMAL.%02d.01.tif', deltat_repo, m),
                      'anomaly' = sprintf(fmt = '%sANOMALY/DELTAT.ANOMALY.%04d.%02d.01.tif', deltat_repo, y, m)
      )
      
      summ_path <- sprintf(fmt = '%sSUMM.%s.%04d.%02d.01.rds', summ_repo, toupper(type), y, m)
      
      if(file.exists(summ_path)){
        cat(summ_path, ' already exists!\n')
        next()
      }
      
      map_raster <- raster(path)
      zonal_stats <- raster::extract(map_raster, phys)
      names(zonal_stats) <- tools::toTitleCase(tolower(phys$PROVINCE))
      saveRDS(zonal_stats, file = summ_path)
      cat(Sys.time(), '\t summaries done!\n')
    }
  }
}

