# Laboratório com Ansible

## Objetivo do laboratório

Configurar automaticamente um servidor web utilizando Ansible.

O playbook realiza as seguintes tarefas:

- atualiza a lista de pacotes;
- instala o Nginx;
- copia uma página HTML personalizada;
- inicia o serviço do Nginx;
- habilita o Nginx na inicialização do sistema;
- valida se o servidor responde com status HTTP `200`.

## Pré-requisitos

- Ansible instalado na máquina de controle;
- servidor Linux baseado em Debian ou Ubuntu;
- acesso SSH ao servidor;
- usuário com permissão para executar comandos com `sudo`;
- arquivo `index.html` disponível no caminho configurado no playbook;
- comunicação de rede entre a máquina de controle e o servidor.

Verifique se o Ansible está instalado:

```bash
ansible --version
```

## Como configurar o inventário

Crie um arquivo chamado `inventory.ini` no diretório do laboratório:

```ini
[servidores_web]
servidor-web ansible_host=IP_DO_SERVIDOR ansible_user=USUARIO
```

Substitua:

- `IP_DO_SERVIDOR` pelo endereço IP do servidor;
- `USUARIO` pelo usuário utilizado na conexão SSH.

Exemplo:

```ini
[servidores_web]
servidor-web ansible_host=192.168.1.100 ansible_user=administrador
```

Teste a comunicação com o servidor:

```bash
ansible servidores_web -i inventory.ini -m ping
```

Resultado esperado:

```text
servidor-web | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

## Como executar o playbook

Entre no diretório do laboratório:

```bash
cd infra-devops-trilha/modulo-6-iac/ansible
```

Execute o playbook:

```bash
ansible-playbook -i inventory.ini playbook.yml
```

Caso seja necessário informar a senha do `sudo`:

```bash
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass
```

## Como executar em modo check

O modo check simula a execução sem aplicar as alterações:

```bash
ansible-playbook -i inventory.ini playbook.yml --check
```

Para visualizar as diferenças nos arquivos:

```bash
ansible-playbook -i inventory.ini playbook.yml --check --diff
```

Algumas tarefas podem não ser totalmente validadas no modo check quando dependem de pacotes ou serviços que ainda não existem no servidor.

## O que o playbook altera

O playbook realiza as seguintes alterações no servidor:

- atualiza o cache de pacotes do sistema;
- instala o pacote `nginx`;
- copia o arquivo configurado na variável `local_index`;
- substitui o arquivo `/var/www/html/index.html`;
- define `root` como proprietário e grupo do arquivo;
- define a permissão do arquivo como `0644`;
- inicia o serviço do Nginx;
- habilita o Nginx para iniciar junto com o sistema;
- valida o acesso local em `http://localhost`.

## Como validar se funcionou

Ao final da execução, o resumo do Ansible deve apresentar:

```text
failed=0
```

Verifique o status do Nginx no servidor:

```bash
sudo systemctl status nginx
```

Teste a resposta HTTP:

```bash
curl -I http://IP_DO_SERVIDOR
```

Resultado esperado:

```text
HTTP/1.1 200 OK
```

Também é possível acessar a página pelo navegador:

```text
http://IP_DO_SERVIDOR
```

A página exibida deve ser o conteúdo do arquivo `index.html` copiado pelo playbook.

Execute novamente o playbook para verificar a idempotência:

```bash
ansible-playbook -i inventory.ini playbook.yml
```

Na segunda execução, o resultado esperado é:

```text
changed=0
failed=0
```

## Cuidados

- confirme se o grupo `servidores_web` existe no inventário;
- revise o endereço IP e o usuário SSH antes da execução;
- confirme se o usuário possui permissão para utilizar `sudo`;
- verifique se o arquivo configurado em `local_index` existe;
- o arquivo `/var/www/html/index.html` existente será substituído;
- utilize `--check --diff` antes de aplicar alterações;
- não armazene senhas diretamente no inventário ou no playbook;
- utilize o Ansible Vault para proteger informações sensíveis;
- revise os servidores selecionados antes de executar o playbook.