echo "________________________________________________"
echo "|                                               |"
echo "|   EXECUTANDO SCRIPT DE BACKUP DE DIRETÓRIO    |"
echo "|_______________________________________________|"

#pasta para ser copiada (endereço completo)
PASTA_ORIGEM=

#pasta onde serão armazenados os backups (endereço completo)
PASTA_DESTINO=

NOME_PASTA=$(basename "$PASTA_ORIGEM")
DATA=$(date +"%d-%m-%Y_%H-%M-%S")
destino="$PASTA_DESTINO/${NOME_PASTA}-backup-$DATA"

if [ ! -d "$PASTA_ORIGEM" ]; then
    echo "Erro: a pasta '$PASTA_ORIGEM' não existe."
    exit 1
fi

mkdir -p "$PASTA_DESTINO"

if cp -a "$PASTA_ORIGEM" "$DESTINO"; then
    echo "$(date): backup realizado em $DESTINO"
else
    echo "$(date): erro ao realizar o backup."
    exit 1
fi

# para adicionar rotina no script:
# crontab -e 
# selecione o método pra abrir o arquivo
# no final do arquivo 
# 0 */12 * * * (endereço completo de onde o script esteja localizado) >> (diretório pra onde quer que os logs sejam direcionados) 2>&1