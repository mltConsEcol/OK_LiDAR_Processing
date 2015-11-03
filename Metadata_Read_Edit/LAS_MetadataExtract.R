#Set working directory
setwd("M:/OK_LiDAR/RCode_Testing") #Practice folder (8 las files total)
#setwd("M:/OK_LiDAR/OK_LAS_data") #Full data
#setwd("M:/OK_LiDAR/OK_LAS_data/OK_DamRehab_Assessment_2011") #Actual data we'll work on, containing ~9000 las files

#Create list of las files
lf <- list.files(pattern="\\.las$", full.name=TRUE, include.dirs=TRUE, recursive=TRUE)

###If testing on a larger subset (the second and third setwd options), 
### best to use the line below as the full list of files is HUGE (the above line takes ~5 min on full folder)
#lf <- list.files(pattern="\\.las$", full.name=TRUE, include.dirs=TRUE, recursive=TRUE)[1:100]


##############
#############
library(foreach)
library(doParallel)

cl<- makeCluster(8)
registerDoParallel(cl)

system.time(las.metadata <- foreach(i= 1:length(lf), .combine=rbind) %dopar% {
  
  tmp <- system(paste('cmd /c lasinfo  "', lf[i], '" -cd 2>&1', sep=''), intern=TRUE, wait=FALSE)
  
  tmp2 <- list(length=5)
  
  tmp2[1] <- tmp[(grep(pattern='number of point records', tmp))]
  tmp2[2] <- tmp[(grep(pattern='min x y z', tmp))]#,
  tmp2[3] <- tmp[(grep(pattern='max x y z', tmp))]#, 
  tmp2[4] <- ifelse(length(tmp[(grep(pattern='key 3072', tmp))])==0, NA, tmp[(grep(pattern='key 3072', tmp))])#,,  finally=return(NA))#error=function(e) {return(NA)})#,
  tmp2[5] <- tmp[(grep(pattern='spacing:', tmp))]
  tmp2[6] <- tmp[(grep(pattern='return_number', tmp))]
  
  
  tmp2 <- unlist(tmp2)
  
  FileName <- paste(lf[i])
  epsg <- (substring(tmp2[4], 57, unlist(gregexpr(pattern =' - ',tmp2[4]))[1]))
  NumPoints <- (unlist(strsplit(tmp2[1], split="   *"))[3])
  xmin <- unlist(strsplit(tmp2[2], " * "))[6]
  xmax <- unlist(strsplit(tmp2[3], " * "))[6]
  ymin <- unlist(strsplit(tmp2[2], " * "))[7]
  ymax <- unlist(strsplit(tmp2[3], " * "))[7]
  PointSpacing <- unlist(strsplit(tmp2[5], " * "))[5]
  FirstReturnOnly <- ifelse(unlist(strsplit(tmp2[6], " * "))[4]==1, 1, 0)
  
  
  cbind(FileName, epsg, NumPoints, xmin, xmax, ymin, ymax, PointSpacing, FirstReturnOnly)
  
}
)

stopCluster(cl)


#view result
head(las.metadata)

#Convert to dataframe and assign columns correct type
las.metadata <- data.frame(las.metadata, stringsAsFactors=FALSE)

las.metadata$FileName <- as.character(las.metadata$FileName)
las.metadata$epsg <- as.integer(las.metadata$epsg)
las.metadata$NumPoints <- as.integer(las.metadata$NumPoints)
las.metadata$xmin <- as.numeric(las.metadata$xmin)
las.metadata$xmax <- as.numeric(las.metadata$xmax)
las.metadata$ymin <- as.numeric(las.metadata$ymin)
las.metadata$ymax <- as.numeric(las.metadata$ymax)
las.metadata$PointSpacing <- as.numeric(las.metadata$PointSpacing)
las.metadata$FirstReturnOnly <- as.integer(las.metadata$FirstReturnOnly)



str(las.metadata)
head(las.metadata)
tail(las.metadata)


#write.csv(las.metadata,"LAS_Metadata.csv", row.names=FALSE)
