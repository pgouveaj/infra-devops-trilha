# Laboratório com Docker e Docker Compose

## Objetivo do laboratório

Executar uma aplicação Go com PostgreSQL e pgAdmin utilizando Docker e Docker Compose.

## Pré-requisitos

- Docker instalado;
- Docker Compose disponível;
- portas `8000`, `5432` e `54321` livres.

## Como subir o ambiente

Na pasta do projeto, execute:

```bash
docker compose up --build -d
```

Verifique os containers:

```bash
docker compose ps
```

## Como validar se funcionou

Acesse:

- Aplicação: `http://localhost:8000`
- pgAdmin: `http://localhost:54321`

Login do pgAdmin:

- E-mail: `jeangouvea@clinicaexperts.com.br`
- Senha: `123456`

Conexão do PostgreSQL no pgAdmin:

- Host: `postgres`
- Porta: `5432`
- Banco: `root`
- Usuário: `root`
- Senha: `root`

## Como consultar logs

Todos os serviços:

```bash
docker compose logs
```

Logs em tempo real:

```bash
docker compose logs -f
```

Logs de um serviço específico:

```bash
docker compose logs postgres
docker compose logs pgadmin-compose
```

## Como parar o ambiente

Parar os containers:

```bash
docker compose down
```

Parar e remover também o volume do banco:

```bash
docker compose down -v
```

## Problemas comuns

- **Erro de conexão com o banco:** dentro dos containers, utilize `postgres` como host, e não `localhost`.
- **Porta em uso:** verifique os containers ativos com `docker ps`.
- **Alterações não aparecem:** recrie o ambiente com:

```bash
docker compose up --build -d --force-recreate
```
