#Set working directory
setwd("M:/OK_LiDAR/RCode_Testing") #Practice folder (7 las files total)
setwd("M:/OK_LiDAR/OK_LAS_data") #Full data
#setwd("M:/OK_LiDAR/OK_LAS_data/OK_DamRehab_Assessment_2011") #Actual data we'll work on, containing ~9000 las files

#Create list of las files
lf <- list.files(pattern="\\.las$", full.name=TRUE, include.dirs=TRUE, recursive=TRUE)

###If testing on a larger subset (the second and third setwd options), 
### best to use the line below as the full list of files is HUGE (the above line takes ~5 min on full folder)
#lf <- list.files(pattern="\\.las$", full.name=TRUE, include.dirs=FALSE)[1:100]


##############
#############
library(foreach)
library(doParallel)

cl<- makeCluster(8)
registerDoParallel(cl)

system.time(las.metadata <- foreach(i= 1:length(lf), .combine=rbind) %dopar% {
  
  tmp <- system(paste('cmd /c lasinfo  "', lf[i], '" 2>&1', sep=''), intern=TRUE, wait=FALSE)
  
  tmp <- tmp[c(grep(pattern='number of point records', tmp),
               grep(pattern='min x y z', tmp),
               grep(pattern='max x y z', tmp), 
               grep(pattern='key 3072', tmp))]
  
  FileName <- paste(lf[i])
  epsg <- (substring(tmp[4], 57, unlist(gregexpr(pattern =' - ',tmp[4]))[1]))
  NumPoints <- (unlist(strsplit(tmp[1], split="   *"))[3])
  xmin <- unlist(strsplit(tmp[2], " * "))[6]
  xmax <- unlist(strsplit(tmp[3], " * "))[6]
  ymin <- unlist(strsplit(tmp[2], " * "))[7]
  ymax <- unlist(strsplit(tmp[3], " * "))[7]
  cbind(FileName, epsg, NumPoints, xmin, xmax, ymin, ymax)
}
)

stopCluster(cl)

#view result
head(las.metadata)

#Convert to dataframe and assign columns correct type
las.metadata <- as.data.frame(las.metadata, stringsAsFactors=FALSE)

las.metadata$FileName <- as.character(las.metadata$FileName)
las.metadata$epsg <- as.integer(las.metadata$epsg)
las.metadata$NumPoints <- as.integer(las.metadata$NumPoints)
las.metadata$xmin <- as.numeric(las.metadata$xmin)
las.metadata$xmax <- as.numeric(las.metadata$xmax)
las.metadata$ymin <- as.numeric(las.metadata$ymin)
las.metadata$ymax <- as.numeric(las.metadata$ymax)

str(las.metadata)
head(las.metadata)

write.csv(las.metadata,"LAS_Metadata.csv", row.names=FALSE)
