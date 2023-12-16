terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}


provider "yandex" {
  token     = "MY TOKEN"
  cloud_id  = "b1gkoq7pl7gg0ooq3nr4"
  folder_id = "b1gp3gttqlpmtjonaks2"
 

}

### СЕТЬ ###

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

###   ПОДСЕТИ   ###

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  route_table_id = yandex_vpc_route_table.route-table.id
  v4_cidr_blocks = ["10.1.1.0/24"]
}

resource "yandex_vpc_subnet" "subnet-2" {
  name           = "subnet2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  route_table_id = yandex_vpc_route_table.route-table.id
  v4_cidr_blocks = ["10.1.2.0/24"]
}

### КОНЕЦ НАСТРОЙКИ СЕТЕЙ И ПОДСЕТЕЙ ###

### НАСТРОЙКА ВИРТУАЛЬНЫХ МАШИН ###

# === Конфигурация Bastion host ===

resource "yandex_compute_instance" "bastion" {
  name     = "bastion"
  hostname = "bastion"
  zone     = "ru-central1-a"
  

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8idfolcq1l43h1mlft"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    security_group_ids = [yandex_vpc_security_group.sg-bastion.id]
    ip_address         = "10.1.1.100"
    nat                = true
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}
# === Конец настройки Bastion host === #

# === Конфигурация web servers === #

resource "yandex_compute_instance" "web1" {
  name     = "web1"
  hostname = "web1"
  zone     = "ru-central1-a"  

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8idfolcq1l43h1mlft"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    security_group_ids = [yandex_vpc_security_group.sg-ssh.id, yandex_vpc_security_group.sg-webserv.id]
    ip_address         = "10.1.1.99"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}


resource "yandex_compute_instance" "web2" {
  name     = "web2"
  hostname = "web2"
  zone     = "ru-central1-b"
  

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8idfolcq1l43h1mlft"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-2.id
    security_group_ids = [yandex_vpc_security_group.sg-ssh.id, yandex_vpc_security_group.sg-webserv.id]
    ip_address         = "10.1.2.99"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}
# === Конец конфигурации web servers === #


# === Конфигурация ElasticSearch === #

resource "yandex_compute_instance" "elastic" {

  name = "elastic"
  hostname = "elastic"
  zone = "ru-central1-a"

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = "fd87gocdmk3tosg6onpg"
      size = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = false
    security_group_ids = [yandex_vpc_security_group.sg-elastic.id, yandex_vpc_security_group.sg-ssh.id]
    ip_address         = "10.1.1.101"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}
# === Конец конфигурации ElasticSearch === #


# === Конфигурация Kibana === #
resource "yandex_compute_instance" "kibana" {

  name = "kibana"
  hostname = "kibana"
  zone = "ru-central1-a"

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = "fd87gocdmk3tosg6onpg"
      size = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.sg-kibana.id, yandex_vpc_security_group.sg-ssh.id]
    ip_address         = "10.1.1.102"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}
# === Конец конфигурации Kibana === #



# === Конфигурация Zabbix === #

resource "yandex_compute_instance" "zabbix" {
  name = "zabbix"
  hostname = "zabbix"
  zone = "ru-central1-a"

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = "fd87gocdmk3tosg6onpg"
      size = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.sg-ssh.id, yandex_vpc_security_group.sg-zabbix.id]
    ip_address         = "10.1.1.103"
  }

  metadata = {
    user-data = "${file("./meta.yaml")}"
  }
}
# === Конец конфигурации Zabbix ===

###    OUTPUTS   ####

output "output-ip-host" {
  value = <<OUTPUT

App load balancer
external = ${yandex_alb_load_balancer.load-balancer.listener.0.endpoint.0.address.0.external_ipv4_address.0.address}

VM bastion
internal = ${yandex_compute_instance.bastion.fqdn}
external = ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}

VM web1
internal = ${yandex_compute_instance.web1.fqdn}

VM web2
internal = ${yandex_compute_instance.web2.fqdn}

VM Elastic
internal = ${yandex_compute_instance.elastic.fqdn}

VM Kibana
internal = ${yandex_compute_instance.kibana.fqdn}
external = ${yandex_compute_instance.kibana.network_interface.0.nat_ip_address}

VM Zabbix
internal = ${yandex_compute_instance.zabbix.fqdn}
external = ${yandex_compute_instance.zabbix.network_interface.0.nat_ip_address}

OUTPUT
}

output "output-ansible-hosts" {
  value = <<OUTPUT

[bastion]
bastion-host ansible_host=${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} ansible_ssh_user=ilkhom

[webservers]
web1 ansible_host=${yandex_compute_instance.web1.fqdn}
web2 ansible_host=${yandex_compute_instance.web2.fqdn}

[elastic]
elastic-host ansible_host=${yandex_compute_instance.elastic.fqdn}

[kibana]
kibana-host ansible_host=${yandex_compute_instance.kibana.fqdn}

[zabbix]
zabbix-host ansible_host=${yandex_compute_instance.zabbix.fqdn}

[webservers:vars]
ansible_ssh_user=ilkhom
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p ilkhom@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'

[elastic:vars]
ansible_ssh_user=ilkhom
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p ilkhom@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'

[kibana:vars]
ansible_ssh_user=ilkhom
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p ilkhom@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'

[zabbix:vars]
ansible_ssh_user=ilkhom
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p ilkhom@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'

OUTPUT
}
###   КОНЕЦ OUTPUTS   ####
