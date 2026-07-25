echo "_________________________________________________"
echo "|                                                |"
echo "|   EXECUTANDO SCRIPT DE BUSCA DE LOGS DE ERRO   |"
echo "|________________________________________________|"

echo
echo "1 - Erros gerais do sistema"
echo "2 - Erros de um serviço específico"
echo "3 - Buscar uma palavra nos logs"
echo "4 - Erros do boot atual"

read -p "Escolha uma opção: " opcao

clear

case "$opcao" in
    1)
        echo
        echo "Exibindo erros gerais do sistema:"
        journalctl -p err --no-pager
        ;;

    2)
        read -p "Digite o nome do serviço: " servico

        if [ -z "$palavra" ]; then
            echo
            echo "Erro: nenhuma palavra foi informada."
        else
            servico="${servico%.service}.service"

            if systemctl cat "$servico" >/dev/null 2>&1; then
                echo
                echo "Buscando erros do serviço '$servico':"

                if ! journalctl -u "$servico" -p err --no-pager; then
                    echo "Não foi possível consultar os logs do serviço." 
                fi 
            else 
                echo 
                echo "Erro: o serviço '$servico' não existe." 
            fi
        fi
        ;;

    3)
        read -p "Digite a palavra que deseja buscar: " palavra

        if [ -z "$palavra" ]; then
            echo
            echo "Erro: nenhuma palavra foi informada."
        else    
            echo
            echo "Buscando por '$palavra' nos logs:"

            if ! journalctl --no-pager | grep -i --color=always -- "$palavra"; then
                echo
                echo "Nenhum registro encontrado com a palavra '$palavra'."
            fi
        fi
        ;;

    4)
        echo
        echo "Exibindo erros do boot atual:"
        journalctl -b -p err --no-pager
        ;;

    *)
        echo "Opção inválida."
        exit 1
        ;;
esac