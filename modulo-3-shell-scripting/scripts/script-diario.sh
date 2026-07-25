#!/bin/bash

# altere conforme o local de salvamento dos relatorios
DIRETORIO_RELATORIOS="/mnt/c/Users/jean.gouvea/Downloads/infra-devops-trilha/modulo-3-shell-scripting/relatorios"
QUANTIDADE_LINHAS_LOG=10

# adicione os serviços que precisam ser monitorados
SERVICOS=(
    "ssh"
    "cron"
)

mkdir -p "$DIRETORIO_RELATORIOS"

DATA_ARQUIVO=$(date +"%d-%m-%y_%H-%M-%S")
ARQUIVO_RELATORIO="$DIRETORIO_RELATORIOS/relatorio-$DATA_ARQUIVO.txt"

# tudo que aparecer na tela também será salvo no relatório
exec > >(tee "$ARQUIVO_RELATORIO") 2>&1

echo "==========================================="
echo "|       RELATÓRIO DIÁRIO DO AMBIENTE      |"
echo "==========================================="
echo
echo "Data: $(date)"
echo "Hostname: $(hostname)"
echo "Usuário responsável: $(whoami)"

# SCRIPT - CPU
# ========================================

echo
echo "==========================================="
echo "|                  CPU                    |"
echo "==========================================="

CPU_OCIOSA=$(vmstat 1 2 | tail -n 1 | awk '{print $15}')
CPU_USADA=$((100 - CPU_OCIOSA))

echo "Uso de CPU: ${CPU_USADA}%"

echo
echo "Cinco processos que mais utilizam CPU:"
echo
ps -eo pid,user,comm,%cpu --sort=-%cpu | head -n 6


# SCRIPT - DISCO
# ========================================

echo
echo "==========================================="
echo "|                 DISCO                   |"
echo "==========================================="

echo
echo "Uso de disco:"

DISCO_USADO=$(df -h / | awk 'NR==2 {print $5}')

echo "$DISCO_USADO"

echo
echo "Diretórios que mais ocupam espaço:"
echo
du -xh / 2>/dev/null | sort -hr | head -n 5

# SCRIPT - MEMÓRIA RAM
# ========================================
echo
echo "==========================================="
echo "|              MEMÓRIA RAM                |"
echo "==========================================="

echo
echo "Uso de memória:"
echo

free -h

RAM_USADA=$(free | awk '/Mem:/ {
    printf "%.1f%%", $3/$2 * 100
}')

# SCRIPT - SERVIÇOS E LOGS
# ========================================

echo
echo "==========================================="
echo "|            SERVIÇOS E LOGS              |"
echo "==========================================="

TOTAL_ERROS=0

for SERVICO in "${SERVICOS[@]}"; do

    echo
    echo "Serviço: $SERVICO"

    if systemctl is-active --quiet "$SERVICO"; then
        echo "Status: ativo"
    else
        echo "Status: inativo"
    fi

    ERROS=$(journalctl -u "$SERVICO" -p err --since today --no-pager -q 2>/dev/null)

    QUANTIDADE_ERROS=$(echo "$ERROS" | grep -c ".")

    TOTAL_ERROS=$((TOTAL_ERROS + QUANTIDADE_ERROS))

    echo "Quantidade de erros: $QUANTIDADE_ERROS"

    echo "Últimos $QUANTIDADE_LINHAS_LOG erros:"

    if [ "$QUANTIDADE_ERROS" -gt 0 ]; then
        echo "$ERROS" | tail -n "$QUANTIDADE_LINHAS_LOG"
    else
        echo "Nenhum erro encontrado."
    fi

done

# RESUMO
# ========================================

echo
echo "==========================================="
echo "|             RESUMO GERAL                |"
echo "==========================================="

echo "CPU usada: ${CPU_USADA}%"
echo "Disco usado: $DISCO_USADO"
echo "RAM usada: $RAM_USADA"
echo "Quantidade total de erros: $TOTAL_ERROS"

# para adicionar rotina no script:
# crontab -e 
# selecione o método pra abrir o arquivo
# no final do arquivo 
# 0 */12 * * * (endereço completo de onde o script esteja localizado) >> (diretório pra onde quer que os logs sejam direcionados) 2>&1