terraform {
  required_version = ">= 1.5.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = var.imagem
  keep_locally = false
}

resource "docker_container" "painel_status" {
  name  = var.nome_container
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.porta_externa
  }

  volumes {
    host_path      = abspath("${path.module}/site")
    container_path = "/usr/share/nginx/html"
    read_only      = true
  }
}