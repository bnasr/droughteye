prism_repo <- '/mnt/monsoon/datarepo/DROUGHT_EYE/PRISM/tmean/'

# mod11c3_repo <- '/mnt/monsoon/datarepo/DROUGHT_EYE/MODIS/MOD11C3/'
# mod11c3_web_repo <- 'https://e4ftl01.cr.usgs.gov/MOLT/MOD11C3.006/'
# 
# myd11c3_repo <- '/mnt/monsoon/datarepo/DROUGHT_EYE/MODIS/MYD11C3/'
# myd11c3_web_repo <- 'https://e4ftl01.cr.usgs.gov/MOLA/MYD11C3.006/'
# 

# deltat_repo <- '/mnt/monsoon/datarepo/DROUGHT_EYE/DELTA_T/'
# deltat_repo2 <- '/mnt/monsoon/datarepo/DROUGHT_EYE/DELTA_T2/'

# summ_repo <- '/mnt/monsoon/datarepo/DROUGHT_EYE/SUMM/'

data_repo <- '/home/bijan/Projects/droughteye/data/'


LST_SOURCE <- 'AQUA'
# LST_SOURCE <- 'TERRA'

lst_repo <- ifelse(LST_SOURCE=='TERRA', 
                   yes = '/mnt/monsoon/datarepo/DROUGHT_EYE/MODIS/MOD11C3/', 
                   no = '/mnt/monsoon/datarepo/DROUGHT_EYE/MODIS/MYD11C3/')

lst_webrepo <- ifelse(LST_SOURCE=='TERRA', 
                   yes = 'https://e4ftl01.cr.usgs.gov/MOLT/MOD11C3.006/', 
                   no = 'https://e4ftl01.cr.usgs.gov/MOLA/MYD11C3.006/')

deltat_repo <- ifelse(LST_SOURCE=='TERRA', 
                      yes = '/mnt/monsoon/datarepo/DROUGHT_EYE/DELTA_T/', 
                      no = '/mnt/monsoon/datarepo/DROUGHT_EYE/DELTA_T2/')

summ_repo <- ifelse(LST_SOURCE=='TERRA', 
                   yes = '/mnt/monsoon/datarepo/DROUGHT_EYE/SUMM/', 
                   no = '/mnt/monsoon/datarepo/DROUGHT_EYE/SUMM2/')
