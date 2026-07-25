echo "__________________________________________________"
echo "|                                                 |"
echo "|   EXECUTANDO SCRIPT DE VERIFICAÇÃO DE SERVIÇO   |"
echo "|_________________________________________________|"

read -p "Digite o nome do serviço para a verificação: " servico

if systemctl cat "$servico" >/dev/null 2>&1; then
    systemctl status "$servico" --no-pager
else
    echo "O serviço '$servico' não foi encontrado."
fi