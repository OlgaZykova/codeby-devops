#!/bin/bash

#check if myfolder is not exist

if [ ! -d $HOME/myfolder ]; then
 echo 'myfolder is not exist!' 
 exit 1
fi

cd $HOME/myfolder

#edit second file's rights

if [ -f "$HOME/myfolder/2" ]; then
 chmod 664 "$HOME/myfolder/2"
fi

#create array of file names in myfolder directory

file_list=($(ls))

#echo "${file_list[1]}"

#iterate over an array of file names, delete empty files and remove all lines except first in non-empty files
for file in "${file_list[@]}"; do
 if [ ! -s $file ]; then
  rm $file
 else
  head -n 1 $file > tmpfile
  mv tmpfile $file
 fi
done
