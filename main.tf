terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>2.15.0"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}
resource "random_pet" "random" {
  count  = 2
  length = 2
}

resource "docker_container" "nodered_container" {
  count = 2
  name  = join("_", ["nodered", random_pet.random[count.index].id])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1800

  }
}
output "ip_port" {
  value       = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
  description = "ip address with exposed port"

}
