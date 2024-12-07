# Базовый образ
FROM debian:11

#Обновление репозиториев и установка nginx
RUN apt-get update && apt-get install -y nginx

#Создание директории для веб-страниц
RUN mkdir -p /opt/www

#Создание файла index.html
RUN echo '<html><body><h1>Hello from Debian!</h1></body></html>' > /opt/www/index.html

#Копирование конфигурации nginx
COPY nginx.conf /etc/nginx/nginx.conf

#Открытие порта 80
EXPOSE 80

#Установка EntryPoint для запуска nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]
