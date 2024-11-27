terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

data "yandex_vpc_subnet" "subnets" {
  for_each = toset(var.vpc_subnet_list)
  subnet_id       = each.value

}
# Найти первую подсеть, подходящую указанной зоне
locals {
  matched_subnet_id = (
    [for subnet in data.yandex_vpc_subnet.subnets :
      subnet.subnet_id if subnet.zone == var.target_zone]
  )[0] # Берем первую подходящую подсеть
}

#Create VM
resource "yandex_compute_instance" "vm-1" {
  name        = "vm-1"
  platform_id = "standard-v2"
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
    subnet_id = local.matched_subnet_id
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  } 

}