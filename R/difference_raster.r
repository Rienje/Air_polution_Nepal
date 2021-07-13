#Rienje Veenhof and Frank Fluit
#Project for the course Geoscripting at Wageningen University
#28-1-2021
#This file contains a function that calculates difference rasters

dif_func <- function(lockdown_raster, raster_of_interest){
  difference_raster <- raster_of_interest - lockdown_raster
  return(difference_raster)
}
