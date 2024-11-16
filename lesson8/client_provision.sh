#!/bin/bash 
# Добавляем запись в /etc/hosts для local домена 
echo "192.168.56.10 olyasdomain.local www.olyasdomain.local" | sudo tee -a /etc/hosts 
 
# Установка сертификата сервера как доверенного 
mkdir -p /usr/local/share/ca-certificates 
scp vagrant@192.168.56.10:/etc/apache2/ssl/olyasdomain.local.crt /usr/local/share/ca-certificates/ 
update-ca-certificates
