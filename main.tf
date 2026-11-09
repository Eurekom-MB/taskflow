terraform {
  required_version = ">= 1.6"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }
}

# Sans paramètre, le provider utilise le moteur Docker local
# (Docker Desktop : socket exposé dans WSL, ou named pipe sous Windows).
provider "docker" {}

resource "docker_image" "python" {
  name         = "python:3.12-slim"
  keep_locally = true # terraform destroy ne supprime pas l'image du cache local
}

resource "docker_container" "web" {
  name    = "web-01"
  image   = docker_image.python.image_id
  command = ["sleep", "infinity"] # garde le conteneur actif (pas de systemd)

  ports {
    internal = 80
    external = 8080
    ip       = "127.0.0.1"
  }
}

output "container_name" {
  value = docker_container.web.name
}

output "url" {
  value = "http://127.0.0.1:8080/"
}
