# Laboratório com Terraform

## Objetivo do laboratório

Provisionar um recurso básico utilizando Terraform. Neste laboratório, o provider `local` cria o arquivo `resultado-laboratorio.txt` no diretório do projeto.

O exercício demonstra o uso de:

- provider;
- resource;
- variables;
- outputs;
- comandos principais do Terraform.

## Pré-requisitos

- Terraform instalado;
- terminal Bash, PowerShell ou equivalente;
- acesso à internet na primeira execução para baixar o provider.

Verifique a instalação:

```bash
terraform version
```

## Arquivos principais

```text
terraform/
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
└── .gitignore
```

- `main.tf`: define o provider `local` e o recurso `local_file`.
- `variables.tf`: define o nome e o conteúdo do arquivo.
- `outputs.tf`: exibe o caminho e o identificador do recurso criado.
- `.gitignore`: impede o versionamento de arquivos locais do Terraform.

## Como inicializar

Entre no diretório do laboratório:

```bash
cd infra-devops-trilha/modulo-6-iac/terraform
```

Inicialize o projeto:

```bash
terraform init
```

O comando baixa o provider necessário e prepara o diretório de trabalho.

## Como validar

Formate os arquivos:

```bash
terraform fmt
```

Valide a configuração:

```bash
terraform validate
```

Resultado esperado:

```text
Success! The configuration is valid.
```

## Como revisar o plano

Execute:

```bash
terraform plan
```

O plano deve indicar a criação de um recurso:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

Revise o plano antes de continuar e confirme que somente o arquivo esperado será criado.

## Como aplicar

Execute:

```bash
terraform apply
```

Confira o plano e digite `yes` para confirmar.

O Terraform criará:

```text
resultado-laboratorio.txt
```

Consulte o conteúdo:

```bash
cat resultado-laboratorio.txt
```

Resultado esperado:

```text
Recurso provisionado com sucesso utilizando Terraform.
```

## Como consultar outputs

Execute:

```bash
terraform output
```

Para consultar apenas o caminho do arquivo:

```bash
terraform output caminho_arquivo
```

## Como destruir

Primeiro, revise o que será removido:

```bash
terraform plan -destroy
```

Depois, destrua o recurso:

```bash
terraform destroy
```

Confira o plano e digite `yes`. O arquivo criado pelo Terraform será removido.

## Cuidados

- Revise o `terraform plan` antes de executar o `terraform apply`.
- Não edite ou remova manualmente recursos gerenciados pelo Terraform.
- Não versione arquivos de estado, planos ou informações sensíveis.
- Mantenha o arquivo `.terraform.lock.hcl` no Git após a inicialização.
- Execute `terraform destroy` ao terminar laboratórios que criem recursos pagos.
- Use `terraform fmt` e `terraform validate` antes de enviar alterações ao repositório.

## Fluxo resumido

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
terraform plan -destroy
terraform destroy
```
