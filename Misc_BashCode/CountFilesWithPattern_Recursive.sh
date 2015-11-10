find . -type d -print0 | while read -d '' -r dir; do     files=("$dir"/Reprj26914$*.las);     printf "%5d files in directory %s\n" "${#files[@]}" "$dir"; done 2>&1 | tee test.txt


ls "!Reprj26914.las"


find . -type d -print0 | while read -d '' -r dir; do fi





#Has .las
find . -type d -print0 | while read -d '' -r dir; do     files=("$dir"/*.las);     printf "%5d files in directory %s\n" "${#files[@]}" "$dir"; done 2>&1 | tee AllLasCount.txt


#Has Reprj26914.las
find . -type d -print0 | while read -d '' -r dir; do     files=("$dir"/*Reprj26914.las);     printf "%5d files in directory %s\n" "${#files[@]}" "$dir"; done 2>&1 | tee ReprjLasCount.txt



ls -1 | grep *.las | wc -l

#More Basic but accomplishes what I want
time find . -type f -name '*\Reprj26914.las' | wc -l

time find . -type f -name '*\.las' | wc -l
