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
# epsgBad=26914
# epsgDes=26914
# cores=8
################


las.batch.reproj <- function(path=path, epsgDes=epsgDes, epsgBad=epsgBad, cores=cores, out=out){
  
  #import libraries
  library(foreach)
  library(doParallel)
  
  lf <- list.files(path=path, pattern="\\.las$", full.name=TRUE, include.dirs=TRUE, recursive=TRUE)
  
  las.noext <- sub('.las', '', lf)
  
  cl<- makeCluster(cores)
  registerDoParallel(cl)
  
  reproj.status <- foreach(i= 1:length(lf), .combine=rbind) %dopar% {
    
    tmp <- system(paste('lasinfo  "', lf[i], '" -cd 2>&1', sep=''), intern=TRUE, wait=FALSE)
    
    
    EPSG <- ifelse(length(tmp[(grep(pattern='key 3072', tmp))])==0, NA, tmp[(grep(pattern='key 3072', tmp))])
    
    EPSG <- (substring(EPSG, 57, unlist(gregexpr(pattern =' - ', EPSG))[1]))
    
    
    if(as.integer(EPSG)==epsgBad){
      system(paste('las2las  -i "', lf[i], '" -epsg "', epsgDes, '" -o "',
                   las.noext[i], '_PrjDef_', epsg, '.las"', sep=''), intern=TRUE, wait=FALSE)
      message <- c(file=lf[i], status=paste('Defined Projection Changed to ', epsgDes, ' from ', epsgBad, '.'))
    }
      
    return(message)
    
  }    
  
  stopCluster(cl)
  
  reproj.status <- data.frame(reproj.status, stringsAsFactors=FALSE)
  if(hasArg(out)==TRUE){
    write.csv(reproj.status, out, row.names=FALSE)
  }
  
  return(reproj.status)
  
}

