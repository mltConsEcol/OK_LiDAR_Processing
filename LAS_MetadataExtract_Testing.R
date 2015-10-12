library(foreach)
library(doParallel)

#Set working directory
setwd("L:/TestLAS")

#system.time(tmp <- system(paste("lasinfo", lf[1], sep=" "), intern=TRUE, wait=FALSE)[c(16,20,21,30)])

#Create list of las files
lf <- list.files(pattern="*.las$", full.name=TRUE, include.dirs=TRUE, recursive=TRUE)


lf
#Create dataframe to be filled in in the loop
las.filedata <- data.frame(FileName=as.character(rep(NA, length(lf))),epsg=as.integer(rep(NA, length(lf))),NumPoints=as.integer(rep(NA, length(lf))),xmin=as.numeric(rep(NA, length(lf))),xmax=as.numeric(rep(NA, length(lf))),ymin=as.numeric(rep(NA, length(lf))), ymax=as.numeric(rep(NA, length(lf))), stringsAsFactors=FALSE)

##############
#Fill in the dataframe by looping lasinfo through all las files in working directory (and subdirectory)
#############
system.time(for(i in 1:length(lf)){
  
  las.filedata[i, "FileName"] <- paste(lf[i])
  
  tmp <- system(paste('lasinfo "', lf[i], '"', sep=''), intern=TRUE, wait=FALSE)[c(16,20,21,30)]
  
  las.filedata[i, "epsg"] <- as.integer(substring(tmp[4], 57, unlist(gregexpr(pattern =' - ',tmp[4]))[1]))
  las.filedata[i,"NumPoints"] <- as.integer(unlist(strsplit(tmp[1], split="   *"))[3])
  las.filedata[i, "xmin"] <- as.numeric(unlist(strsplit(tmp[2], " * "))[6])
  las.filedata[i, "xmax"] <- as.numeric(unlist(strsplit(tmp[3], " * "))[6])
  las.filedata[i, "ymin"] <- as.numeric(unlist(strsplit(tmp[2], " * "))[7])
  las.filedata[i, "ymax"] <- as.numeric(unlist(strsplit(tmp[3], " * "))[7])
rm(tmp)
}
)

las.filedata

rm(las.filedata)






#######No Performance Gain
foo <- function(x){
  
#  las.filedata <- data.frame(FileName=character(),epsg=integer(),NumPoints=integer(),xmin=numeric(),xmax=numeric(),ymin=numeric(), ymax=numeric(), stringsAsFactors=FALSE)
 
  tmp <- system(paste("lasinfo", x, sep=" "), intern=TRUE, wait=FALSE)[c(16,20,21,30)]

  FileName <- paste(x)
  
  epsg <- as.integer(substring(tmp[4], 57, unlist(gregexpr(pattern =' - ',tmp[4]))[1]))
  NumPoints <- as.integer(unlist(strsplit(tmp[1], split="   *"))[3])
  xmin <- as.numeric(unlist(strsplit(tmp[2], " * "))[6])
  xmax <- as.numeric(unlist(strsplit(tmp[3], " * "))[6])
  ymin <- as.numeric(unlist(strsplit(tmp[2], " * "))[7])
  ymax <- as.numeric(unlist(strsplit(tmp[3], " * "))[7])
  #return(las.filedata)
  return(cbind(FileName, epsg, NumPoints, xmin, xmax, ymin, ymax))

}
lf2 <- as.list(lf)

system.time(test <- lapply(lf2, foo))
################

lf2

help(lapply)


##Trying Parallel
################
cl<- makeCluster(8)
registerDoParallel(cl)

las.filedata <- data.frame(FileName=as.character(rep(NA, length(lf))),epsg=as.integer(rep(NA, length(lf))),NumPoints=as.integer(rep(NA, length(lf))),xmin=as.numeric(rep(NA, length(lf))),xmax=as.numeric(rep(NA, length(lf))),ymin=as.numeric(rep(NA, length(lf))), ymax=as.numeric(rep(NA, length(lf))), stringsAsFactors=FALSE)


#system.time(for(i in 1:length(lf)){
system.time(test <- foreach(i=1: length(lf), .combine=cbind) %dopar% {
  
  las.filedata[i, "FileName"] <- paste(lf[i])
  
  tmp <- system(paste("lasinfo", lf[i], sep=" "), intern=TRUE, wait=FALSE)[c(16,20,21,30)]
  
  las.filedata[i, "epsg"] <- as.integer(substring(tmp[4], 57, unlist(gregexpr(pattern =' - ',tmp[4]))[1]))
  las.filedata[i,"NumPoints"] <- as.integer(unlist(strsplit(tmp[1], split="   *"))[3])
  las.filedata[i, "xmin"] <- as.numeric(unlist(strsplit(tmp[2], " * "))[6])
  las.filedata[i, "xmax"] <- as.numeric(unlist(strsplit(tmp[3], " * "))[6])
  las.filedata[i, "ymin"] <- as.numeric(unlist(strsplit(tmp[2], " * "))[7])
  las.filedata[i, "ymax"] <- as.numeric(unlist(strsplit(tmp[3], " * "))[7])
  rm(tmp)
}
)
stopCluster(cl)

las.filedata




##Trying Parallel
################
cl<- makeCluster(8)
registerDoParallel(cl)
#lf2 <- as.list(lf)

las.filedata <- data.frame(FileName=as.character(rep(NA, length(lf))),epsg=as.integer(rep(NA, length(lf))),NumPoints=as.integer(rep(NA, length(lf))),xmin=as.numeric(rep(NA, length(lf))),xmax=as.numeric(rep(NA, length(lf))),ymin=as.numeric(rep(NA, length(lf))), ymax=as.numeric(rep(NA, length(lf))), stringsAsFactors=FALSE)

tmp <- list()

system.time(test <- foreach(i=1:length(lf), .combine=rbind) %dopar% {
  
  las.filedata[i, "FileName"] <- paste(lf[i])
  
  for(i in 1:length(lf)){
  
  tmp[[i]] <- system(paste("lasinfo", lf[i], sep=" "), intern=TRUE, wait=FALSE)[c(16,20,21,30)]
  
}
  
  las.filedata[i, "epsg"] <- as.integer(substring(tmp[[i]][4], 57, unlist(gregexpr(pattern =' - ',tmp[[i]][4]))[1]))
#   las.filedata[i,"NumPoints"] <- as.integer(unlist(strsplit(tmp[1], split="   *"))[3])
#   las.filedata[i, "xmin"] <- as.numeric(unlist(strsplit(tmp[2], " * "))[6])
#   las.filedata[i, "xmax"] <- as.numeric(unlist(strsplit(tmp[3], " * "))[6])
#   las.filedata[i, "ymin"] <- as.numeric(unlist(strsplit(tmp[2], " * "))[7])
#   las.filedata[i, "ymax"] <- as.numeric(unlist(strsplit(tmp[3], " * "))[7])
}
)
stopCluster(cl)


for(i in 1:length(lf)){
  
  tmp[[i]] <- system(paste("lasinfo", lf[i], sep=" "), intern=TRUE, wait=FALSE)[c(16,20,21,30)]
  
}



tmp <- list()

################
cl<- makeCluster(8)
registerDoParallel(cl)

#tmp <- list()
system.time(test <- foreach(i= 1:length(lf)) %dopar% {
  setwd("L:/TestLAS")
  tmp <-  system(paste("lasinfo", lf[i], sep=" "), intern=TRUE, wait=FALSE)[c(16,20,21,30)]
  as.integer(substring(tmp[[4]], 57, unlist(gregexpr(pattern =' - ',tmp[[4]]))[1]))
  }
)

stopCluster(cl)






################
cl<- makeCluster(8)
registerDoParallel(cl)
x <- iris[which(iris[,5] != "setosa"), c(1,5)]
trials <- 10000
ptime <- system.time({
  r <- foreach(icount(trials), .combine=cbind) %dopar% {
    ind <- sample(100, 100, replace=TRUE)
    result1 <- glm(x[ind,2]~x[ind,1], family=binomial(logit))
    coefficients(result1)
  }
})[3]
ptime

stopCluster(cl)








lf2 <- as.list(lf)
}
)

las.filedata



