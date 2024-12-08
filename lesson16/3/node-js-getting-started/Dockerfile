# Stage 1: Сборка приложения
FROM node:16 AS build-stage
# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем весь исходный код в контейнер
COPY . .

#
RUN npm  install
# Stage 2: Запуск приложения
FROM node:16 AS production-stage
# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app
# Копируем только необходимые файлы из build-stage
COPY --from=build-stage /app /app
# Открываем порт, на котором будет работать приложение
EXPOSE 5006
# Запускаем приложение
CMD ["npm", "start"]
