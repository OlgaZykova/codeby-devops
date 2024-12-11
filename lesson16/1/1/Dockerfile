# Базовый образ 
FROM alpine:latest 
 
# Установка nginx 
RUN apk update && apk add nginx 
 
# Создание директории для index
RUN mkdir -p /opt/www 
 
# Создание файла index.html 
RUN echo '<html><body><h1>Hello from Alpine</h1></body></html>' > /opt/www/index.html 
 
# Копирование конфига nginx 
COPY nginx.conf /etc/nginx/nginx.conf 
 
#Открытие порта 80 
EXPOSE 80 
 
#запуск nginx 
CMD ["nginx", "-g", "daemon off;"]
