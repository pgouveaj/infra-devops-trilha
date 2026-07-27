output "endereco_aplicacao" {
  description = "Endereço do painel"
  value       = "http://localhost:${var.porta_externa}"
}

output "nome_container" {
  description = "Nome do container criado"
  value       = docker_container.painel_status.name
}

output "id_container" {
  description = "Identificador do container"
  value       = docker_container.painel_status.id
}