!/bin/bash

# Директория для SSH-ключей
SSH_DIR="/home/vagrant/.ssh"

# Создание директории для ключей на клиенте, если её ещё нет
mkdir -p $SSH_DIR
chmod 700 $SSH_DIR

# Генерация SSH-ключа на клиенте, если ключ не существует
if [ ! -f "$SSH_DIR/id_rsa" ]; then
  ssh-keygen -t rsa -b 2048 -f $SSH_DIR/id_rsa -q -N ""
fi
apt-get update -y
apt-get install sshpass -y
# Копирование публичного ключа клиента на сервер
sshpass -p "vagrant" ssh-copy-id -i $SSH_DIR/id_rsa.pub -o StrictHostKeyChecking=no vagrant@192.168.56.4