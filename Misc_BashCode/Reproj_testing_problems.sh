    tmp <- system(paste('lasinfo  "', lf[2], '" -cd 2>&1', sep=''), intern=TRUE, wait=FALSE)

      system(paste('las2las  -i "', lf[2], '" -target_epsg "', epsg, '" -o "',
                   las.noext[2], '_Reprj', epsg, '.las"', sep=''), intern=TRUE, wait=FALSE)
      message <- c(file=lf[i], status='File Reprojected')

#for testing in R
system (paste('las2las  -i "/data/groups/OK_LiDAR/RCode_Testing/test_Sallisaw_2006_test/f36097H3_SED_PrjAdd.las" -target_epsg 26914 -o test.las'))

#For testing in shell
las2las  -i /data/groups/OK_LiDAR/RCode_Testing/test_Sallisaw_2006_test/f36097H3_SED_PrjAdd.las -target_epsg 26914 -o /data/groups/OK_LiDAR/RCode_Testing/test_Sallisaw_2006_test/test4.las
