#!/bin/bash

timestamp=$(date +"%Y%m%d%H%M")

backup_file="/opt/mysql_backup/test_db_$timestamp.sql"

mysqldump test_db > $backup_file
rsync -avz /opt/mysql_backup/ olya@10.10.80.147:/opt/store/mysql 




