#################
# las.metadataExtract(path, epsg, cores, out)
# Function to extract metadata from .las files and output them to R object and .csv file
# Writen by Mike Treglia, mike-treglia@utulsa.edu
# Tested on R version 3.1.3 x64 on Windows 8
#Example Code
#
# source("../../../data/users/mtreglia/OK_LiDAR_Processing/Metadata_Read_Edit/LAS_CorrectProjectioninfo_unix.R")
# source("../../../data/users/mtreglia/OK_LiDAR_Processing/Metadata_Read_Edit/LAS_MetadataExtract_unix.R")
#
# Set Working Directory
# setwd("M:/OK_LiDAR/RCode_Testing")
# setwd("../../../data/groups/OK_LiDAR/RCode_Testing/Mixed_RealFiles")
#
# path <- getwd()
# epsg=26914
# 
################


#Set Working Directory
#setwd("M:/OK_LiDAR/RCode_Testing") #Practice folder (8 las files total)
setwd("M:/OK_LiDAR/OK_LAS_data")

#Load metadata file
las.meta <- read.csv("LAS_Metadata_ORIG.csv")

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