#!/bin/bash 
# Обновляем пакеты и устанавливаем Apache и OpenSSL 
apt-get update 
apt-get install -y apache2 openssl 
 
# Создаем каталог для SSL-сертификатов 
mkdir -p /etc/apache2/ssl 
 
# Генерируем self-signed сертификат для домена olyasdomain.local 
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/olyasdomain.local.key -out /etc/apache2/ssl/olyasdomain.local.crt -subj "/CN=olyasdomain.local" 
 
# Настраиваем конфигурацию Apache для HTTPS и перенаправления 
cat <<EOF > /etc/apache2/sites-available/olyasdomain.local.conf 
<VirtualHost *:80> 
    ServerName olyasdomain.local 
    ServerAlias olyasdomain.local 
    Redirect permanent / https://olyasdomain.local/ 
</VirtualHost> 
 
<VirtualHost *:443> 
    ServerName olyasdomain.local 
    ServerAlias www.olyasdomain.local 
 
    DocumentRoot /var/www/html 
    SSLEngine on 
    SSLCertificateFile /etc/apache2/ssl/olyasdomain.local.crt 
    SSLCertificateKeyFile /etc/apache2/ssl/olyasdomain.local.key 
 
    # Перенаправление с www.olyasdomain.local на olyasdomain.local 
    RewriteEngine On 
    RewriteCond %{HTTP_HOST} ^www\.olyasdomain\.local$ [NC] 
    RewriteRule ^(.*)$ https://olyasdomain.local$1 [L,R=301] 
</VirtualHost> 
EOF 
 
# Включаем необходимые модули Apache 
a2enmod ssl 
a2enmod rewrite 
a2ensite olyasdomain.local.conf 
systemctl restart apache2
