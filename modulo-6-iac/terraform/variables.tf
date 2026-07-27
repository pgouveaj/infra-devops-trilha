variable "imagem" {
  description = "Imagem utilizada no container"
  type        = string
  default     = "nginx:alpine"
}

variable "nome_container" {
  description = "Nome do container"
  type        = string
  default     = "painel-status"
}

variable "porta_externa" {
  description = "Porta para acessar a aplicação"
  type        = number
  default     = 8080
}