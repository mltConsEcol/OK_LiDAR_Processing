#Set working directory
#setwd("M:/OK_LiDAR/RCode_Testing")
setwd("M:/OK_LiDAR/OK_LAS_data")

#Create list of las files
lf <- list.files(pattern="*.las$", full.name=TRUE, include.dirs=TRUE, recursive=TRUE)

#Create dataframe to be filled in in the loop
las.filedata <- data.frame(FileName=as.character(rep(NA, length(lf))),epsg=as.integer(rep(NA, length(lf))),NumPoints=as.integer(rep(NA, length(lf))),xmin=as.numeric(rep(NA, length(lf))),xmax=as.numeric(rep(NA, length(lf))),ymin=as.numeric(rep(NA, length(lf))), ymax=as.numeric(rep(NA, length(lf))), stringsAsFactors=FALSE)

##############
#Fill in the dataframe by looping lasinfo through all las files in working directory (and subdirectory)
#############
system.time(for(i in 1:length(lf)){
  
  las.filedata[i, "FileName"] <- paste(lf[i])
  
  tmp <- system(paste('cmd /c lasinfo -no_vlrs "', lf[i], '"', sep=''), intern=TRUE, wait=FALSE)[c(16,20,21,30)]
  
  las.filedata[i, "epsg"] <- as.integer(substring(tmp[4], 57, unlist(gregexpr(pattern =' - ',tmp[4]))[1]))
  las.filedata[i,"NumPoints"] <- as.integer(unlist(strsplit(tmp[1], split="   *"))[3])
  las.filedata[i, "xmin"] <- as.numeric(unlist(strsplit(tmp[2], " * "))[6])
  las.filedata[i, "xmax"] <- as.numeric(unlist(strsplit(tmp[3], " * "))[6])
  las.filedata[i, "ymin"] <- as.numeric(unlist(strsplit(tmp[2], " * "))[7])
  las.filedata[i, "ymax"] <- as.numeric(unlist(strsplit(tmp[3], " * "))[7])
  rm(tmp)
}
)

#View result
las.filedata


##############
# Attempt to do this via parallel processing for all vars
# Evan Linde found that cmd /c prior to lasinfo prints it out to stdout instead of the default stderr
#############
library(foreach)
library(doParallel)

cl<- makeCluster(8)
registerDoParallel(cl)

system.time(epsg <- foreach(i= 1:length(lf), .combine=rbind) %dopar% {
  
  
  tmp <- system(paste('cmd /c lasinfo  "', lf[i], '" 2>&1', sep=''), intern=TRUE, wait=FALSE)[c(16,20,21,30)]
  FileName <- paste(lf[i])
  epsg <- as.integer(substring(tmp[4], 57, unlist(gregexpr(pattern =' - ',tmp[4]))[1]))
  NumPoints <- as.integer(unlist(strsplit(tmp[1], split="   *"))[3])
  xmin <- as.numeric(unlist(strsplit(tmp[2], " * "))[6])
  xmax <- as.numeric(unlist(strsplit(tmp[3], " * "))[6])
  ymin <- as.numeric(unlist(strsplit(tmp[2], " * "))[7])
  ymax <- as.numeric(unlist(strsplit(tmp[3], " * "))[7])
  cbind(FileName, epsg, xmin, xmax, ymin, ymax)
}
)

stopCluster(cl)

#view result
epsg



##############
# Attempt to do this via parallel processing - first, only trying to extract the epsg code
# Evan Linde found that cmd /c prior to lasinfo prints it out to stdout instead of the default stderr
#############
library(foreach)
library(doParallel)

cl<- makeCluster(8)
registerDoParallel(cl)

system.time(epsg <- foreach(i= 1:length(lf), .combine=rbind) %dopar% {

  tmp <- system(paste('cmd /c lasinfo "', lf[i], '" 2>&1', sep=''), intern=TRUE, wait=FALSE)[c(16,20,21,30)]
  as.integer(substring(tmp[4], 57, unlist(gregexpr(pattern =' - ',tmp[4]))[1]))
}
)

stopCluster(cl)


epsg





