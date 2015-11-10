#!/bin/bash
#This creates a csv file showing for every folder, the number of .las files and reprojected las files.  For some reason, no files return 1s, but that should be okay for now
echo Directory, lasFiles, ReprojLasFiles > $1
find . -type d -print0 | while read -d '' -r dir; do     files1=("$dir"/*\.las) files2=("$dir"/*Reprj26914\.las);  echo "$dir", "${#files1[@]}",  "${#files2[@]}" >> $1; done
