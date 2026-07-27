# **Boas Práticas de Infraestrutura como Código com Terraform**

## **Introdução**

A utilização do Terraform permite criar, alterar e remover recursos de infraestrutura por meio de arquivos de código.  
Para que esse processo seja seguro, organizado e fácil de manter, é importante seguir boas práticas durante o desenvolvimento, a revisão e a execução da infraestrutura.  
Este documento consolida as principais práticas aprendidas no módulo.

---

## **1\. Não versionar secrets**

### **Prática**

Não armazenar senhas, tokens, chaves de acesso, credenciais ou outras informações sensíveis diretamente nos arquivos do Terraform ou no repositório Git.

### 

### **Por que é importante**

Um repositório pode ser acessado por várias pessoas ou até se tornar público acidentalmente. Caso uma credencial seja versionada, ela permanece registrada no histórico do Git, mesmo depois de ser removida do arquivo atual.

### 

### **Exemplo**

Exemplo incorreto:

```
variable "senha_banco" {
  default = "senha123"
}
```

Exemplo recomendado:

```
variable "senha_banco" {
  type      = string
  sensitive = true
}
```

O valor pode ser fornecido por variável de ambiente:

```shell
export TF_VAR_senha_banco="valor-seguro"
```

Arquivos locais com valores sensíveis devem ser adicionados ao .gitignore:

```
*.tfvars
.env
*.pem
*.key
terraform.tfstate
terraform.tfstate.backup
```

### **Risco se não seguir**

* vazamento de credenciais;  
* acesso não autorizado à infraestrutura;  
* exposição de dados;  
* criação ou remoção indevida de recursos;  
* necessidade de trocar todas as credenciais comprometidas;  
* aumento do risco de incidentes de segurança.

---

## **2\. Revisar o terraform plan antes de aplicar**

### **Prática**

Executar e revisar o comando terraform plan antes de utilizar o terraform apply.

### 

### **Por que é importante**

O plano mostra antecipadamente quais recursos serão criados, alterados, substituídos ou destruídos.  
Essa revisão permite identificar alterações inesperadas antes que elas afetem o ambiente.

### 

### **Exemplo**

```shell
terraform plan
```

Também é possível salvar o plano:

```shell
terraform plan -out=plano.tfplan
```

Depois, aplicar exatamente o plano revisado:

```shell
terraform apply plano.tfplan
```

Durante a revisão, deve-se observar os seguintes símbolos:

```
+ create
~ update in-place
- destroy
-/+ replace
```

### **Risco se não seguir**

* exclusão acidental de recursos;  
* substituição inesperada de máquinas;  
* indisponibilidade de serviços;  
* perda de dados;  
* criação de recursos desnecessários;  
* aumento de custos;  
* alteração de configurações de segurança.

---

## **3\. Utilizar terraform fmt e terraform validate**

### **Prática**

Executar os comandos de formatação e validação antes de enviar ou aplicar alterações.

### 

### **Por que é importante**

O terraform fmt organiza automaticamente a formatação dos arquivos.  
O terraform validate verifica se a estrutura e a sintaxe da configuração estão corretas.  
Esses comandos ajudam a manter o código padronizado e reduzem erros simples.

### 

### **Exemplo**

Formatar os arquivos:

```shell
terraform fmt
```

Formatar todos os diretórios:

```shell
terraform fmt -recursive
```

Validar a configuração:

```shell
terraform validate
```

Sequência recomendada:

```shell
terraform fmt -recursive
terraform validate
terraform plan
```

### **Risco se não seguir**

* arquivos desorganizados;  
* diferenças de formatação entre colaboradores;  
* erros de sintaxe;  
* falhas durante a execução;  
* dificuldade de revisão;  
* maior chance de configuração incorreta.

---

## **4\. Separar variáveis do código**

### **Prática**

Não inserir diretamente no código valores que podem mudar entre ambientes ou execuções.  
Esses valores devem ser definidos como variáveis.

### 

### **Por que é importante**

Separar variáveis torna o código mais reutilizável e facilita sua utilização em desenvolvimento, homologação e produção.  
Também evita a repetição de arquivos quase iguais.

### **Exemplo**

Arquivo variables.tf:

```
variable "regiao" {
  description = "Região onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "nome_ambiente" {
  description = "Nome do ambiente"
  type        = string
}
```

Arquivo terraform.tfvars:

```
nome_ambiente = "laboratorio"
regiao        = "us-east-1"
```

Utilização no código:

```
resource "aws_instance" "servidor" {
  ami           = var.ami
  instance_type = var.tipo_instancia

  tags = {
    Name        = "servidor-${var.nome_ambiente}"
    Environment = var.nome_ambiente
  }
}
```

### **Risco se não seguir**

* código difícil de reutilizar;  
* duplicação de configurações;  
* alterações manuais frequentes;  
* aplicação de valores incorretos;  
* dificuldade para separar ambientes;  
* maior chance de alterar produção por engano.

---

## **5\. Utilizar outputs para informações úteis**

### **Prática**

Criar outputs para exibir informações importantes após a criação da infraestrutura.

### 

### **Por que é importante**

Os outputs facilitam a identificação dos recursos criados e evitam a necessidade de procurar manualmente informações no painel do provedor.  
Eles também podem ser utilizados por outros módulos, scripts e pipelines.

### 

### **Exemplo**

Arquivo outputs.tf:

```
output "ip_publico" {
  description = "Endereço IP público do servidor"
  value       = aws_instance.servidor.public_ip
}

output "id_instancia" {
  description = "Identificador da instância criada"
  value       = aws_instance.servidor.id
}
```

Consultar os outputs:

```shell
terraform output
```

Consultar um output específico:

```shell
terraform output ip_publico
```

Para informações sensíveis:

```
output "senha_inicial" {
  value     = var.senha_inicial
  sensitive = true
}
```

### **Risco se não seguir**

* dificuldade para encontrar informações criadas;  
* necessidade de consultar recursos manualmente;  
* aumento do tempo de validação;  
* dificuldade de integração com automações;  
* maior chance de copiar informações incorretas.

---

## **6\. Documentar os pré-requisitos**

### **Prática**

Registrar todas as ferramentas, permissões, contas e configurações necessárias antes da execução do projeto.

### 

### **Por que é importante**

A documentação permite que outra pessoa prepare o ambiente corretamente e execute a infraestrutura sem depender de conhecimento informal.

### 

### **Exemplo**

Os pré-requisitos podem ser registrados no README.md:

```
## Pré-requisitos

- Terraform instalado;
- Git instalado;
- conta ativa no provedor de nuvem;
- credenciais configuradas;
- acesso à internet;
- permissões para criar e remover recursos;
- versão mínima do Terraform: 1.8.0.
```

Também é possível definir a versão no código:

```
terraform {
  required_version = ">= 1.8.0"
}
```

### **Risco se não seguir**

* falhas durante a execução;  
* uso de versões incompatíveis;  
* ausência de permissões necessárias;  
* dificuldade para reproduzir o ambiente;  
* dependência excessiva de uma única pessoa;  
* perda de tempo com configurações não documentadas.

---

## **7\. Documentar os comandos de criação e destruição**

### **Prática**

Registrar claramente os comandos necessários para iniciar, validar, criar e destruir a infraestrutura.

### 

### **Por que é importante**

A documentação padroniza a execução e reduz o risco de comandos incorretos.  
Ela também facilita a repetição do laboratório e a remoção dos recursos ao final.

### 

### **Exemplo**

````
## Criação da infraestrutura

Inicializar o projeto:

```bash
terraform init
````

Formatar e validar:

```shell
terraform fmt -recursive
terraform validate
```

Visualizar as mudanças:

```shell
terraform plan
```

Criar os recursos:

```shell
terraform apply
```

## 

## **Destruição da infraestrutura**

Visualizar os recursos que serão removidos:

```shell
terraform plan -destroy
```

Destruir os recursos:

```shell
terraform destroy
```

### **Risco se não seguir**

* divergência entre código e ambiente;  
* alterações sobrescritas pelo Terraform;  
* dificuldade para identificar responsáveis;  
* falhas inesperadas;  
* perda de padronização;  
* configurações de segurança incorretas.

---

## **9\. Organizar os ambientes**

### **Prática**

Separar claramente ambientes como laboratório, desenvolvimento, homologação e produção.

### 

### **Por que é importante**

A separação evita que recursos de teste sejam misturados com recursos reais.  
Também permite utilizar tamanhos, nomes, permissões e configurações diferentes em cada ambiente.

### 

### **Exemplo**

Estrutura por diretórios:

```
infraestrutura/
├── modules/
│   ├── rede/
│   └── servidor/
├── environments/
│   ├── laboratorio/
│   ├── desenvolvimento/
│   ├── homologacao/
│   └── producao/
└── README.md
```

Outra opção é utilizar arquivos de variáveis:

```
laboratorio.tfvars
desenvolvimento.tfvars
producao.tfvars
```

Aplicação com arquivo específico:

```shell
terraform plan -var-file="laboratorio.tfvars"
terraform apply -var-file="laboratorio.tfvars"
```

### **Risco se não seguir**

* aplicação de configurações de teste em produção;  
* nomes de recursos confusos;  
* mistura de estados;  
* exclusão acidental de recursos;  
* dificuldade para controlar custos;  
* configurações inadequadas para cada ambiente.

---

## **10\. Manter commits pequenos e claros**

### **Prática**

Criar commits com poucas alterações relacionadas e mensagens que expliquem claramente o que foi modificado.

### 

### **Por que é importante**

Commits pequenos facilitam a revisão, a identificação de erros e a reversão de mudanças.  
Cada commit deve representar uma alteração lógica.

### 

### **Exemplo**

Mensagens recomendadas:

```
feat: adiciona instância de laboratório
```

```
fix: corrige regra de entrada do firewall
```

```
docs: adiciona comandos de destruição
```

```
refactor: separa variáveis do código principal
```

Exemplo de alterações que podem ficar em commits separados:

```
1. Criação da rede
2. Criação do servidor
3. Adição dos outputs
4. Atualização da documentação
```

### **Risco se não seguir**

* dificuldade para revisar alterações;  
* commits com mudanças sem relação;  
* maior dificuldade para desfazer uma alteração;  
* histórico pouco compreensível;  
* erros mais difíceis de localizar;  
* conflitos maiores entre branches.

---

## **11\. Explicar os impactos antes de aplicar mudanças**

### **Prática**

Registrar e comunicar o que será alterado, quais recursos serão afetados e quais riscos existem antes da execução.

### 

### **Por que é importante**

Mudanças de infraestrutura podem causar indisponibilidade, substituição de recursos, perda de dados ou aumento de custos.  
Explicar os impactos ajuda na tomada de decisão e na preparação de um plano de rollback.

### 

### **Exemplo**

Descrição de mudança:

```
Mudança:
Alteração do tipo da instância de pequeno para médio.

Impacto esperado:
A instância poderá ser reiniciada durante a alteração.

Recursos afetados:
Servidor da aplicação de laboratório.

Risco:
Indisponibilidade temporária.

Validação:
Confirmar que a aplicação responde após a execução.

Rollback:
Restaurar o tipo anterior da instância e executar novamente o Terraform.
```

Também é importante revisar no plano mensagens como:

```
must be replaced
will be destroyed
forces replacement
```

### **Risco se não seguir**

* indisponibilidade inesperada;  
* perda de dados;  
* interrupção de serviços;  
* aumento de custos;  
* ausência de rollback;  
* equipes não preparadas para a mudança.

---

## **12\. Registrar evidências de execução**

### **Prática**

Salvar registros que comprovem a validação, a criação, a alteração e a destruição dos recursos.

### 

### **Por que é importante**

As evidências ajudam a demonstrar que a atividade foi realizada corretamente.  
Também facilitam auditorias, investigações e apresentações do projeto.

### 

### **Exemplo**

Podem ser registradas as seguintes evidências:

* saída do terraform fmt;  
* resultado do terraform validate;  
* resumo do terraform plan;  
* resultado do terraform apply;  
* outputs gerados;  
* captura dos recursos criados;  
* teste de acesso;  
* resultado do terraform destroy;  
* confirmação de que nenhum recurso permaneceu ativo.

Exemplo de estrutura:

```
evidencias/
├── 01-terraform-init.txt
├── 02-terraform-validate.txt
├── 03-terraform-plan.txt
├── 04-terraform-apply.txt
├── 05-outputs.txt
├── 06-teste-acesso.png
└── 07-terraform-destroy.txt
```

Salvar a saída de um comando:

```shell
terraform plan | tee evidencias/terraform-plan.txt
```

```shell
terraform apply | tee evidencias/terraform-apply.txt
```

### **Risco se não seguir**

* falta de comprovação da execução;  
* dificuldade para investigar erros;  
* ausência de histórico;  
* dificuldade para apresentar resultados;  
* dúvidas sobre quais recursos foram criados ou removidos.

---

## **13\. Destruir recursos de laboratório ao final**

### **Prática**

Remover os recursos criados apenas para testes ou aprendizado quando eles não forem mais necessários.

### 

### **Por que é importante**

Recursos em nuvem podem continuar gerando cobrança mesmo quando não estão sendo utilizados.  
Máquinas virtuais, discos, endereços IP, bancos de dados, balanceadores e outros serviços podem gerar custos continuamente.

### 

### **Exemplo**

Primeiro, revisar os recursos que serão removidos:

```shell
terraform plan -destroy
```

Depois, destruir a infraestrutura:

```shell
terraform destroy
```

Confirmar a operação:

```
Enter a value: yes
```

Após a destruição, verificar:

```shell
terraform show
```

Resultado esperado:

```
The state file is empty. No resources are represented.
```

Também é recomendado acessar o painel do provedor e confirmar que não ficaram recursos ativos.

### **Risco se não seguir**

* cobrança desnecessária;  
* consumo de limites da conta;  
* recursos esquecidos;  
* exposição de serviços de laboratório;  
* risco de segurança;  
* dificuldade para identificar a origem dos custos.

---

# **Fluxo recomendado de execução**

Um fluxo seguro para trabalhar com Terraform pode seguir esta sequência:

```shell
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform output
```

Ao finalizar o laboratório:

```shell
terraform plan -destroy
terraform destroy
```

Depois da destruição, deve-se confirmar que os recursos realmente foram removidos.  
---

# **Checklist antes do terraform apply**

- [ ] Os arquivos foram formatados com terraform fmt.  
- [ ] A configuração foi validada com terraform validate.  
- [ ] O terraform plan foi revisado.  
- [ ] Não existem secrets no código.  
- [ ] As variáveis estão separadas da configuração principal.  
- [ ] O ambiente correto foi selecionado.  
- [ ] Os impactos foram identificados.  
- [ ] Recursos que serão destruídos ou substituídos foram revisados.  
- [ ] Existe uma forma de reverter a mudança.  
- [ ] Os comandos estão documentados.  
- [ ] As evidências serão registradas.

---

# **Checklist após o terraform apply**

- [ ] A execução terminou sem erros.  
- [ ] Os outputs foram conferidos.  
- [ ] Os recursos foram criados corretamente.  
- [ ] O serviço está acessível.  
- [ ] As configurações de rede estão corretas.  
- [ ] Não existem recursos inesperados.  
- [ ] As evidências foram salvas.  
- [ ] A documentação foi atualizada.

---

# **Checklist de encerramento do laboratório**

- [ ] Os resultados do laboratório foram registrados.  
- [ ] As evidências foram salvas.  
- [ ] O terraform plan \-destroy foi revisado.  
- [ ] O terraform destroy foi executado.  
- [ ] O estado não possui recursos ativos.  
- [ ] O painel do provedor foi conferido.  
- [ ] Não existem discos, IPs ou outros recursos restantes.  
- [ ] Não existem recursos gerando custos desnecessários.

---

## **Conclusão**

As boas práticas de Infraestrutura como Código ajudam a tornar a criação e o gerenciamento de recursos mais seguros, previsíveis e organizados.  
No Terraform, é importante validar e formatar o código, revisar o plano antes da aplicação, proteger informações sensíveis, separar variáveis, documentar os procedimentos e evitar alterações manuais.  
Também é necessário registrar evidências e remover recursos de laboratório ao final das atividades, evitando riscos de segurança e custos desnecessários.  
A infraestrutura deve ser tratada com o mesmo cuidado que o código de uma aplicação, utilizando versionamento, revisão, documentação e controle de mudanças.

