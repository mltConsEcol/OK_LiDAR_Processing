################# 
# Workflow in R for processing .las files for Oklahoma Writen by
# Mike Treglia, mike-treglia@utulsa.edu Tested on R version 3.1.3 x64 on Windows
# 8 Lines w/ 2 hashtags are comments; lines w/ 1 hashtag were run and should
# not/need not be run again
###############

# Import function to run extract metadata from all .las files in directory
source("L:/OK_LiDAR_Processing/Metadata_Read_Edit/LAS_MetadataExtract.R")

source("L:/OK_LiDAR_Processing/FileManipulation/LAS_Reprojection.R")

setwd("M:/OK_LiDAR/OK_LAS_data")

## Get Metadata prior on original directory, after all files are uncompressed
#system.time(las.metadataExtract(path=getwd(), cores=8, out="LAS_Metadata_ORIG.csv"))

## Assign EPSG code for files w/out it in the metadata, based on inspections of those datasets
## This is not a function - just a script, as it is fairly specific to these data.
#system.time(source("L:/OK_LiDAR_Processing/Metadata_Read_Edit/LAS_AddProjectionInfo.R"))

## Reproject Files
#system.time(ReprojLog <- las.batch.reproj(path=getwd(), epsg=26914, cores=8, out="reprojectionLog.csv"))



###############
# Next to be developed/run
#   * Check metadata and if not projection not EPSG 26914, reproject to that; if no projection data, leave it
#     * Code written - see LAS_Reprojection.R
#   * Re-run metadata extraction - perhaps only for files w/ EPSG 26914(?)
#   * For each file create minimum concave polygon... put everything into a single shapefile or geojson or similar
#     * Have all .las files somehow indexed to respective polygons for spatial query
###############
