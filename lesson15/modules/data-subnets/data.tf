terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

data "yandex_vpc_network" "net" {
  network_id = var.vpc_network_id
 # yandex_vpc_network.net.network_id = vpc_network_id 
}
#output "subnets_info" { 
 # value = data.yandex_vpc_network.net.subnet_ids
#}
