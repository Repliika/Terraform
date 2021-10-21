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
  length = 2


}
resource "random_pet" "randomtwo" {
  length = 2


}
resource "docker_container" "nodered_container" {
  name  = join("_", ["nodered", random_pet.random.id])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1800
    external = 1800 #defaults and match dockerfile. 
  }
}
resource "docker_container" "nodered_container2" {
  name  = join("_", ["nodered", random_pet.randomtwo.id])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1800
    #get rid of external, docker will map internal 1800 to a random external for you 
  }
}
output "IP_and_port" {
  value       = join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].external]) #joining IP and port with :
  description = "prints IP address of nodered container"
}
