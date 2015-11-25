#################
# las.metadataExtract(path, cores, out)
# Function to extract metadata from .las files and output them to R object and .csv file
# Writen by Mike Treglia, mike-treglia@utulsa.edu
# Tested on R version 3.1.3 x64 on Windows 8
#
# Example Code
# setwd("../../../data/groups/OK_LiDAR/RCode_Testing")
# system.time(test <- las.metadataExtract(getwd(), 8)) #don't write out metadata
# system.time(test <- las.metadataExtract(path=getwd(), cores=6, out="testmeta1.csv"))
################

las.metadataExtract <- function(path=path, cores=cores, out=out){
  
  #import libraries
  library(foreach)
  library(doParallel)
  
  #Create list of las files
  lf <- list.files(path=path, pattern="\\.las$", full.name=TRUE, include.dirs=TRUE, recursive=TRUE)
  
  #Start parallel processing
  cl<- makeCluster(cores)
  registerDoParallel(cl)
  
  las.metadata <- foreach(i= 1:length(lf), .combine=rbind) %dopar% {
    
      tmp <- system(paste('lasinfo  "', lf[i], '" -cd 2>&1', sep=''), intern=TRUE, wait=FALSE)
      
      tmp2 <- list(length=9)
      
      tmp2[1] <- tmp[(grep(pattern='number of point records', tmp))]
      tmp2[2] <- tmp[(grep(pattern='min x y z', tmp))]
      tmp2[3] <- tmp[(grep(pattern='max x y z', tmp))] 
      tmp2[4] <- ifelse(length(tmp[(grep(pattern='key 3072', tmp))])==0, NA, tmp[(grep(pattern='key 3072', tmp))])
      tmp2[5] <- tmp[(grep(pattern='spacing:', tmp))]
      tmp2[6] <- tmp[(grep(pattern='return_number', tmp))]
      tmp2[7] <- ifelse(length(tmp[(grep(pattern='key 4098', tmp))])==0, NA, tmp[(grep(pattern='key 4098', tmp))])
      tmp2[8] <- ifelse(length(tmp[(grep(pattern='key 3076', tmp))])==0, NA, tmp[(grep(pattern='key 3076', tmp))])
      tmp2[9] <- ifelse(length(tmp[(grep(pattern='key 3073', tmp))])==0, NA, tmp[(grep(pattern='key 3073', tmp))])
      tmp2[10] <- ifelse(length(tmp[(grep(pattern='key 4097', tmp))])==0, NA, tmp[(grep(pattern='key 4097', tmp))])
      
      
      
      
      
      tmp2 <- unlist(tmp2)
      
      FileName <- paste(lf[i])
      epsgHoriz <- (substring(tmp2[4], 57, unlist(gregexpr(pattern =' - ',tmp2[4]))[1]))
      epsgVert <- (substring(tmp2[7], 57, unlist(gregexpr(pattern =' - ',tmp2[7]))[1]))
      VertUnitCode <- (substring(tmp2[8], 57, unlist(gregexpr(pattern =' - ',tmp2[8]))[1]))
      NumPoints <- (unlist(strsplit(tmp2[1], split="   *"))[3])
      xmin <- unlist(strsplit(tmp2[2], " * "))[6]
      xmax <- unlist(strsplit(tmp2[3], " * "))[6]
      ymin <- unlist(strsplit(tmp2[2], " * "))[7]
      ymax <- unlist(strsplit(tmp2[3], " * "))[7]
      zmin <- unlist(strsplit(tmp2[2], " * "))[8]
      zmax <- unlist(strsplit(tmp2[3], " * "))[8]
      PointSpacing <- unlist(strsplit(tmp2[5], " * "))[5]
      FirstReturnOnly <- ifelse(unlist(strsplit(tmp2[6], " * "))[4]==1, 1, 0)
      HorizCRS_Txt <- (strsplit(tmp2[9], ": ")[[1]][2])
      VertCRS_Txt <- (strsplit(tmp2[10], ": ")[[1]][2])
      
      
      cbind(FileName, epsgHoriz, epsgVert, VertUnitCode, NumPoints, xmin, xmax, ymin, ymax, zmin, zmax, PointSpacing, FirstReturnOnly, HorizCRS_Txt, VertCRS_Txt)
    
  }
  
  stopCluster(cl)
  
  #Convert to dataframe and assign columns correct type
  las.metadata <- data.frame(las.metadata, stringsAsFactors=FALSE)
  
  las.metadata$FileName <- as.character(las.metadata$FileName)
  las.metadata$epsgHoriz <- as.integer(las.metadata$epsgHoriz)
  las.metadata$epsgVert <- as.integer(las.metadata$epsgVert)
  las.metadata$VertUnitCode <- as.integer(las.metadata$VertUnitCode)
  las.metadata$NumPoints <- as.integer(las.metadata$NumPoints)
  las.metadata$xmin <- as.numeric(las.metadata$xmin)
  las.metadata$xmax <- as.numeric(las.metadata$xmax)
  las.metadata$ymin <- as.numeric(las.metadata$ymin)
  las.metadata$ymax <- as.numeric(las.metadata$ymax)
  las.metadata$zmin <- as.numeric(las.metadata$zmin)
  las.metadata$zmax <- as.numeric(las.metadata$zmax)
  las.metadata$PointSpacing <- as.numeric(las.metadata$PointSpacing)
  las.metadata$FirstReturnOnly <- as.integer(las.metadata$FirstReturnOnly)
  las.metadata$HorizCRS_Txt <- as.character(las.metadata$HorizCRS_Txt)
  las.metadata$VertCRS_Txt <- as.character(las.metadata$VertCRS_Txt)
  
  if(hasArg(out)==TRUE){
    write.csv(las.metadata, out, row.names=FALSE)
  }
  
  return(las.metadata)
  
}

