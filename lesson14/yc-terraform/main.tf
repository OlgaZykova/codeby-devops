terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {  
  zone = "ru-central1-a"
  service_account_key_file = "./authorized_key.json" # Укажите путь к ключу JSON
  cloud_id  = "b1gjvtbdku7d68h9pi42"           # Укажите ваш Cloud ID
  folder_id = "b1g5trap8k0s2qp65cfa"           # Укажите ваш Folder ID

}
#network
resource "yandex_vpc_network" "default" {  
  name = "olya-vpc-network"
}
#public subnet creation
resource "yandex_vpc_subnet" "public" {  
  name           = "public-subnet"
  zone           = "ru-central1-a" 
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.1.0/24"] # Диапазон IP для публичной подсети
}
#private network creation
resource "yandex_vpc_subnet" "private" {
  name           = "private-subnet" 
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id 
  v4_cidr_blocks = ["10.0.2.0/24"] # Диапазон IP для приватной подсети
}
#VM in private creation
resource "yandex_compute_instance" "private_vm" { 
  name        = "private-vm"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"
  resources {
    cores  = 2  
    memory = 2
  }
  boot_disk { 
    initialize_params {
      image_id = "fd81id4ciatai2csff2u" # ID Ubuntu 
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    security_group_ids = [yandex_vpc_security_group.private-sg.id]

  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}" # Ваш публичный SSH-ключ
 }

#Private VM doesn't need Nginx (I guess)
}

resource "yandex_compute_instance" "public_vm" {
  name        = "public-vm"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd81id4ciatai2csff2u" # ID Ubuntu
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true # Доступ к интернету
    security_group_ids = [yandex_vpc_security_group.public-sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}" # Ваш публичный SSH-ключ
  }
#provision nginx
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]

    # Данные для подключения
    connection {
      type        = "ssh"
      user        = "ubuntu" # Пользователь
      private_key = file("~/.ssh/id_rsa") # Приватный ключ
      host        = self.network_interface.0.nat_ip_address
    }
  }
}


# public security group
resource "yandex_vpc_security_group" "public-sg" {
  name        = "public-security-group" 
  description = "Allows SSH, HTTP, and HTTPS connections"
  network_id  = yandex_vpc_network.default.id
 
  # Разрешаем входящие соединения по SSH (порт 22)  
  ingress {
    protocol       = "TCP"
    description    = "Allow SSH connections"
    v4_cidr_blocks = ["0.0.0.0/0"] # Разрешаем со всех IP-адресов  
    port           = 22
  }
  # Разрешаем входящие соединения по HTTP (порт 80)
  ingress {
    protocol       = "TCP"   
    description    = "Allow HTTP connections"
    v4_cidr_blocks = ["0.0.0.0/0"] # Разрешаем со всех IP-адресов  
    port           = 80
  }
  # Разрешаем входящие соединения по HTTPS (порт 443)
  ingress {    
    protocol       = "TCP"
    description    = "Allow HTTPS connections"    
    v4_cidr_blocks = ["0.0.0.0/0"] # Разрешаем со всех IP-адресов
    port           = 443 
  }
  # Разрешаем все исходящие соединения (по умолчанию)
  egress {   
    protocol       = "ANY"
    description    = "Allow all outbound traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "yandex_vpc_security_group" "private-sg" {
  name        = "private-security-group"
  description = "Allows SSH and 8080 connections in private subnet"
  network_id  = yandex_vpc_network.default.id

  labels = {
    environment = "private"
  }

  # Разрешаем входящие соединения по SSH (порт 22)
  ingress {
    protocol       = "TCP"
    description    = "Allow SSH connections"
    v4_cidr_blocks = ["10.0.0.0/8"] # Разрешаем только с внутренних подсетей
    port           = 22
  }

  # Разрешаем входящие соединения по порту 8080
  ingress {
    protocol       = "TCP"
    description    = "Allow connections on port 8080"
    v4_cidr_blocks = ["10.0.0.0/8"] # Разрешаем только с внутренних подсет
    port           = 8080
  }

  # Разрешаем весь исходящий трафик (по умолчанию)
  egress {
    protocol       = "ANY"
    description    = "Allow all outbound traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_instance" "manual_vm" { 
  name        = "manually-created-vm"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"
  resources {
    cores  = 2  
    memory = 2
  }
  boot_disk { 
    initialize_params {
      image_id = "fd87tnm3ldu6nqhki8f7" # ID Ubuntu 
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    security_group_ids = [yandex_vpc_security_group.private-sg.id]

  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}" # Ваш публичный SSH-ключ
  }
}

