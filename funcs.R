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

