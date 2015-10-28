#Set Working Directory
#setwd("M:/OK_LiDAR/RCode_Testing") #Practice folder (8 las files total)
setwd("M:/OK_LiDAR/OK_LAS_data")

#Load metadata file
las.meta <- read.csv("LAS_Metadata.csv")

#Get 
las.meta.noEPSG <- as.character(las.meta[is.na(las.meta$epsg),1])

#las.meta.noEPSG <- sub('./', '/', las.meta.noEPSG)

las.meta.noEPSG_noext <- sub('.las', '', las.meta.noEPSG)


library(foreach)
library(doParallel)

cl<- makeCluster(8)
registerDoParallel(cl)

system.time(foreach(i= 1:length(las.meta.noEPSG)) %dopar% {
  if(grepl(pattern='Sallisaw_2006', las.meta.noEPSG[i])==TRUE){
      system(paste('cmd /c las2las  -i "', las.meta.noEPSG[i], '" -epsg 26915 -o "', las.meta.noEPSG_noext[i], '_PrjAdd.las"', sep=''), intern=TRUE, wait=FALSE)
    } else {
      system(paste('cmd /c las2las  -i "', las.meta.noEPSG[i], '" -epsg 26914 -o "', las.meta.noEPSG_noext[i], '_PrjAdd.las"', sep=''), intern=TRUE, wait=FALSE)
    }
  
  })

stopCluster(cl)