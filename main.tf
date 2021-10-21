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

resource "docker_container" "nodered_container" {
  name  = "nodered"
  image = docker_image.nodered_image.latest
  ports {
    internal = 1800
    external = 1800 #defaults and match dockerfile. 
  }
}

output "IP_and_port" {
  value       = join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].external]) #joining IP and port with :
  description = "prints IP address of nodered container"
}
