
#Change to directory with las files
cd /cygdrive/d/TregliaFiles/GIS/Data/US_Data/Oklahoma/LiDAR/NRCS_LIDAR_RAW_DATA_e2624430-e171-491e-9e1c-c83303508322_selection_EPSG_26915_0_meters

#classify ground points	
mkdir temp_tiles #Make temp directory for tiles

#Tile dataset in reversible way
lastile -i NRCS_LIDAR_RAW_DATA_e2624430-e171-491e-9e1c-c83303508322_selection_EPSG_26915_0_meters.las  -reversible -tile_size 1000 -buffer 50 -o temp_tiles/tileOrig.las

mkdir temp_tiles_ground
#Classify Ground Points
lasground -i temp_tiles/tileOrig*.las -wilderness -odir temp_tiles_ground -olas

