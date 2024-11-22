#!/bin/bash

#This script creates directory myfolder in current user's home directory and 5 files in this directory 
#This is new line making script executable
chmod +x "$0"

#this is a new constant

DIRECTORY="$HOME/myfolder"

#create directory myfolder if it doesn't exist


if [ ! -d "$DIRECTORY" ]; then
 mkdir "$DIRECTORY"
fi 

#give rights to open directory and create files in it

chmod 755 "$DIRECTORY"

#first file creation (hello and date)

if [ ! -f "$DIRECTORY/1" ]; then
 touch "$DIRECTORY/1"
fi

#give owner rights to write in file

chmod 644 "$DIRECTORY/1"

#and write hello and date 

echo -e "Hello!\n $(date '+%Y-%m-%d_%H-%M-%S')" > "$DIRECTORY/1"
 
#second file creation (empty +777)

if [ ! -f "$DIRECTORY/2" ]; then
 touch "$DIRECTORY/2"
fi

chmod 777 "$DIRECTORY/2"

#third file creation

if [ ! -f "$DIRECTORY/3" ]; then
 touch "$DIRECTORY/3"
fi 
chmod 644 "$DIRECTORY/3"

#fill file with 20 random letters
echo "$(shuf -e q w e r t y u i o p a s d f g h j k l z x c v b n m -n 20)" > "$DIRECTORY/3"

#fourth file creation (empty file)
if [ ! -f "$DIRECTORY/4" ]; then
 touch "$DIRECTORY/4"
fi 

#fifth file creation (empty file)
if [ ! -f "$DIRECTORY/5" ]; then
 touch "$DIRECTORY/5"
fi 

chmod 644 "$DIRECTORY/4" "$DIRECTORY/5"
