#################
# las.metadataExtract(path, epsg, cores, out)
# Function to extract metadata from .las files and output them to R object and .csv file
# Writen by Mike Treglia, mike-treglia@utulsa.edu
# Tested on R version 3.1.3 x64 on Windows 8
#Example Code
# Set Working Directory
# setwd("M:/OK_LiDAR/RCode_Testing")
#
# path <- getwd()
# epsg=26914
# 
# system.time(test <- batch.reproj.las(path=getwd(), epsg=26914, cores=8, out="reprojTestLog.csv"))
################



las.batch.reproj <- function(path=path, epsg=epsg, cores=cores, out=out){
  
  #import libraries
  library(foreach)
  library(doParallel)
  
  lf <- list.files(path=path, pattern="\\.las$", full.name=TRUE, include.dirs=TRUE, recursive=TRUE)
  
  las.noext <- sub('.las', '', lf)
  
  cl<- makeCluster(cores)
  registerDoParallel(cl)
  
  reproj.status <- foreach(i= 1:length(lf), .combine=rbind) %dopar% {
    
    tmp <- system(paste('cmd /c lasinfo  "', lf[i], '" -cd 2>&1', sep=''), intern=TRUE, wait=FALSE)
    
    
    EPSG <- ifelse(length(tmp[(grep(pattern='key 3072', tmp))])==0, NA, tmp[(grep(pattern='key 3072', tmp))])
    
    EPSG <- (substring(EPSG, 57, unlist(gregexpr(pattern =' - ', EPSG))[1]))
    
    
    if(is.na(EPSG)){
      message <- c(file=lf[i], status='Warning: No EPSG Code Detected for File')
    } else if (as.integer(EPSG)==epsg){
      message <- c(lf[i], 'Already in Desired Projection')
    } else {
      system(paste('cmd /c las2las  -i "', lf[i], '" -target_epsg "', epsg, '" -o "',
                   las.noext[i], '_Reprj', epsg, '.las"', sep=''), intern=TRUE, wait=FALSE)
      message <- c(file=lf[i], status='File Reprojected')
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