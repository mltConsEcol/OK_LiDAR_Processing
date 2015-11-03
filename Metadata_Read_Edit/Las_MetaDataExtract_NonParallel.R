#Set working directory
setwd("M:/OK_LiDAR/RCode_Testing") #Practice folder (8 las files total)
#setwd("M:/OK_LiDAR/OK_LAS_data") #Full data
#setwd("M:/OK_LiDAR/OK_LAS_data/OK_DamRehab_Assessment_2011") #Actual data we'll work on, containing ~9000 las files

#Create list of las files
lf <- list.files(pattern="\\.las$", full.name=TRUE, include.dirs=TRUE, recursive=TRUE)

###If testing on a larger subset (the second and third setwd options), 
### best to use the line below as the full list of files is HUGE (the above line takes ~5 min on full folder)
#lf <- list.files(pattern="\\.las$", full.name=TRUE, include.dirs=FALSE)[1:100]

#Create dataframe to be filled in in the loop
las.filedata <- data.frame(FileName=as.character(rep(NA, length(lf))),
                           epsg=as.integer(rep(NA, length(lf))),
                           NumPoints=as.integer(rep(NA, length(lf))),
                           xmin=as.numeric(rep(NA, length(lf))),
                           xmax=as.numeric(rep(NA, length(lf))),
                           ymin=as.numeric(rep(NA, length(lf))), 
                           ymax=as.numeric(rep(NA, length(lf))), 
                           PointSpacing=as.numeric(rep(NA, length(lf))), 
                           stringsAsFactors=FALSE)


##############
#Fill in the dataframe by looping lasinfo through all las files in working directory (and subdirectory)
#############
system.time(for(i in 1:length(lf)){
  
  las.filedata[i, "FileName"] <- paste(lf[i])
  
  tmp <- system(paste('cmd /c lasinfo "', lf[i], '" -cd 2>&1', sep=''), intern=TRUE, wait=FALSE)
  
  tmp2 <- list(length=5)
  
  tmp2[1] <- tmp[(grep(pattern='number of point records', tmp))]
  tmp2[2] <- tmp[(grep(pattern='min x y z', tmp))]#,
  tmp2[3] <- tmp[(grep(pattern='max x y z', tmp))]#, 
  tmp2[4] <- ifelse(length(tmp[(grep(pattern='key 3072', tmp))])==0, NA, tmp[(grep(pattern='key 3072', tmp))])#,,  finally=return(NA))#error=function(e) {return(NA)})#,
  tmp2[5] <- tmp[(grep(pattern='spacing:', tmp))]
  
  tmp2 <- unlist(tmp2)
  
  las.filedata[i, "epsg"] <- as.integer(substring(tmp2[4], 57, unlist(gregexpr(pattern =' - ',tmp2[4]))[1]))
  las.filedata[i,"NumPoints"] <- as.integer(unlist(strsplit(tmp2[1], split="   *"))[3])
  las.filedata[i, "xmin"] <- as.numeric(unlist(strsplit(tmp2[2], " * "))[6])
  las.filedata[i, "xmax"] <- as.numeric(unlist(strsplit(tmp2[3], " * "))[6])
  las.filedata[i, "ymin"] <- as.numeric(unlist(strsplit(tmp2[2], " * "))[7])
  las.filedata[i, "ymax"] <- as.numeric(unlist(strsplit(tmp2[3], " * "))[7])
  las.filedata[i, "PointSpacing"] <- as.numeric(unlist(strsplit(tmp2[5], " * "))[5])
  
  rm(tmp)
}
)

#View result
head(las.filedata)
