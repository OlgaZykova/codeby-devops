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
  service_account_key_file = "./authorized_key.json"
  cloud_id  = "b1gjvtbdku7d68h9pi42"           
  folder_id = "b1g5trap8k0s2qp65cfa"           

}


#network
resource "yandex_vpc_network" "default" {  
  name = "olya-vpc-network-2"
}
#public subnet creation
resource "yandex_vpc_subnet" "public" {  
  name           = "public-subnet-2"
  zone           = "ru-central1-a" 
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.1.0/24"] # Диапазон IP для публичной подсети
}
#private network creation
resource "yandex_vpc_subnet" "private" {
  name           = "private-subnet-2" 
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.default.id 
  v4_cidr_blocks = ["10.0.2.0/24"] # Диапазон IP для приватной подсети
}

# Use data module
module "data_subnets" {  
  
  source  = "./modules/data-subnets"
  vpc_network_id  = yandex_vpc_network.default.id
}


# get info from data module
output "subnets_list" {
  value = module.data_subnets.subnets_info
}

## module create vm
module "create_vm" {  
  source  = "./modules/create_vm"
  vpc_subnet_list  = module.data_subnets.subnets_info
  #let's initialize zone
  target_zone = "ru-central1-a"
}
