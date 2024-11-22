#!/bin/bash

#This script creates directory myfolder in current user's home directory and 5 files in this directory 

#create directory myfolder if it doesn't exist

if [ ! -d "$HOME/myfolder" ]; then
 mkdir "$HOME/myfolder"
fi 

#give rights to open directory and create files in it

chmod 755 "$HOME/myfolder"

#first file creation (hello and date)

if [ ! -f "$HOME/myfolder/1" ]; then
 touch "$HOME/myfolder/1"
fi

#give owner rights to write in file

chmod 644 "$HOME/myfolder/1"

#and write hello and date 

echo -e "Hello!\n $(date '+%Y-%m-%d_%H-%M-%S')" > "$HOME/myfolder/1"
 
#second file creation (empty +777)

if [ ! -f "$HOME/myfolder/2" ]; then
 touch "$HOME/myfolder/2"
fi

chmod 777 "$HOME/myfolder/2"

#third file creation

if [ ! -f "$HOME/myfolder/3" ]; then
 touch "$HOME/myfolder/3"
fi 
chmod 644 "$HOME/myfolder/3"

#fill file with 20 random letters
echo $(shuf -e q w e r t y u i o p a s d f g h j k l z x c v b n m -n 20) > "$HOME/myfolder/3"

#fourth file creation (empty file)
if [ ! -f "$HOME/myfolder/4" ]; then
 touch "$HOME/myfolder/4"
fi 

#fifth file creation (empty file)
if [ ! -f "$HOME/myfolder/5" ]; then
 touch "$HOME/myfolder/5"
fi 

chmod 644 "$HOME/myfolder/4" "$HOME/myfolder/5"
