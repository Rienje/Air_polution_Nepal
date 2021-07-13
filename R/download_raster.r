#Rienje Veenhof and Frank Fluit
#Project for the course Geoscripting at Wageningen University
#28-1-2021
#This script takes a url, downloads a raster and gives it a specified output name
#and saves 1 line of code for each raster in the main script
  
#install needed libraries
if(!"raster" %in% rownames(installed.packages())){install.packages("raster")}
library(raster)

download_raster <- function(url, outputname) {
  download.file(url, outputname, method = 'auto')
  downloaded_raster <- raster(outputname)
  return(downloaded_raster)
}

download_many_raster <- Vectorize(download_raster)
#End