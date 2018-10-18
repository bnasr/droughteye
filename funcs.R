# extract HDF URL from MODIS html pages
get_hdf <- function(url){
  # Create an html document from the url
  webpage <- xml2::read_html(url)
  # Extract the URLs
  links <- webpage %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href")
  hdf <- links[grep(pattern = '.hdf$', links)]
  if(length(hdf)==0) return(NULL)
  paste0(url, hdf)
}


# download hdf file from EarthData
download_hdf <- function(hdf, 
                         user, 
                         pass, 
                         dest_dir = getwd()){
  
  cmd <- paste('cd', dest_dir, ';', 
               'wget -nv --user', user, 
               '--password', pass, hdf)
  system(cmd)
  paste0(dest_dir, basename(hdf))
}


# getMOD11C3 and convert LST to geotiff
get_MOD11C3 <- function(year, month, modis_repo){
  page_url <- sprintf(fmt = '%s%04d.%02d.01/', mcd11c3_web_repo, year, month)
  
  hdf_url <- get_hdf(page_url)
  
  
  hdf_path <- paste0(modis_repo, 'HDF/', basename(hdf_url))
  
  if(file.exists(hdf_path))
    cat(hdf_path, ' already exists!\n')
  else
    hdf_path <- download_hdf(hdf_url, 
                             dest_dir = paste0(modis_repo, 'HDF/'), 
                             user = 'bijan', 
                             pass = readLines('.key.txt'))
  
  # data <- gdalUtils::get_subdatasets(hdf_path)
  
  tiff_path <- sprintf(fmt = '%sGEOTIFF/LST.Day.%04d.%02d.01.tif', modis_repo, year, month)
  
  if(file.exists(tiff_path)){
    cat(tiff_path, ' already exists!\n')
    return(tiff_path)
  }
  
  gdal_translate(hdf_path, tiff_path, sd_index=1)
  tiff_path
}

# read modis and prism and write detla T
write_detla_t <- function(y, m, deltat_repo){
  
  delta_path <- sprintf(fmt = '%sDELTA/DELTAT.%04d.%02d.01.tif', deltat_repo, y, m)
  
  if(file.exists(delta_path)){
    cat(delta_path, ' already exists!\n')
    return(delta_path)
  }
  
  
  lst_path <- sprintf(fmt = '%sGEOTIFF/LST.Day.%04d.%02d.01.tif', 
                      modis_repo, y, m)
  
  prism_stable_path <- sprintf(fmt = '%sPRISM_tmean_stable_4kmM2_%04d%02d_bil/PRISM_tmean_stable_4kmM2_%04d%02d_bil.bil', 
                               prism_repo, y, m, y, m)
  
  prism_provisional_path <- sprintf(fmt = '%sPRISM_tmean_provisional_4kmM2_%04d%02d_bil/PRISM_tmean_provisional_4kmM2_%04d%02d_bil.bil', 
                                    prism_repo, y, m, y, m)
  
  if(file.exists(prism_stable_path)){
    prism_path <- prism_stable_path
  }else{
    if(file.exists(prism_provisional_path)){
      prism_path <- prism_provisional_path
    }else{
      stop(paste(prism_stable_path, 'and', prism_provisional_path, 'not found!'))
    }
  }
  
  if(!file.exists(lst_path)){
    stop(paste(lst_path, 'not found!'))
  }
  
  file.exists(prism_provisional_path)
  
  lst <- raster(lst_path)
  ta <- raster(prism_path)
  
  
  ts <- projectRaster(lst, ta)
  
  deltat <- ts-ta-273.15
  
  
  writeRaster(deltat, delta_path)
  
  return(delta_path)
}


write_detla_t_normal <- function(m, deltat_repo){
  
  delta_normal_path <- sprintf(fmt = '%sNORMAL/DELTAT.NORMAL.%02d.01.tif', deltat_repo, m)
  
  if(file.exists(delta_normal_path)){
    cat(delta_normal_path, ' already exists!\n')
    return(delta_normal_path)
  }
  
  y <- 2001:2012
  
  delta_path <- sprintf(fmt = '%sDELTA/DELTAT.%04d.%02d.01.tif', deltat_repo, y, m)
  
  delta_t <- lapply(delta_path, raster)
  
  n <- length(delta_t)
  
  deltat_normal <- delta_t[[1]]
  
  for(i in 2:n) deltat_normal <- deltat_normal + delta_t[[i]]
  
  deltat_normal <- deltat_normal/n
  
  writeRaster(deltat_normal, delta_normal_path)
  
  return(delta_normal_path)
}

write_detla_t_anomaly <- function(y, m, deltat_repo){
  
  delta_anomaly_path <- sprintf(fmt = '%sANOMALY/DELTAT.ANOMALY.%04d.%02d.01.tif', deltat_repo, y, m)
  
  if(file.exists(delta_anomaly_path)){
    cat(delta_anomaly_path, ' already exists!\n')
    return(delta_anomaly_path)
  }
  
  delta_path <- sprintf(fmt = '%sDELTA/DELTAT.%04d.%02d.01.tif', deltat_repo, y, m)
  
  if(!file.exists(delta_path))
    stop(paste(delta_path, 'not found!'))
  
  delta_normal_path <- sprintf(fmt = '%sNORMAL/DELTAT.NORMAL.%02d.01.tif', deltat_repo, m)
  
  if(!file.exists(delta_normal_path))
    stop(paste(delta_normal_path, 'not found!'))
  
  delta <- raster(delta_path)
  delta_normal <- raster(delta_normal_path)
  
  delta_anomaly <- delta - delta_normal
  
  writeRaster(delta_anomaly, delta_anomaly_path)
  
  return(delta_anomaly_path)
}

northArrow <- function (xb, yb, len, lab = "NORTH", cex.lab = 1, tcol = "black", 
                        ...) 
{
  s <- len
  arrow.x = c(-1, 1, 1, 2, 0, -2, -1, -1)/2
  arrow.y = c(0, 0, 2, 2, 4, 2, 2, 0)
  polygon(xb + arrow.x * s, yb + arrow.y * s, ...)
  text(xb, yb - strheight(lab, cex = cex.lab), lab, cex = cex.lab, 
       col = tcol)
}

setRange <- function(r, rng=quantile(r, probs=c(.01,.99))){
  r[r<rng[1]] <- rng[1]
  r[r>rng[2]] <- rng[2]
  r
}

insertLegend <- function(rng, col , legtext = '°C'){
  bty <- par()$bty
  par(bty='o')
  image.plot(legend.only=TRUE, zlim= rng, 
             smallplot= c(.89, .93, .10, .80),
             axis.args = list(cex.axis = 1.7, font=2),
             legend.args = list(text= legtext, side = 4, xpd = T, adj = 0.5, line = 2.5, font = 2, cex = 2), 
             col = col, horizontal = F, yaxt='s') 
  par(bty=bty)
}
