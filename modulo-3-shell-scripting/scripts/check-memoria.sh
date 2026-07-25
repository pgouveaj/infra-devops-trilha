echo "______________________________________________"
echo "|                                             |"
echo "|   EXECUTANDO SCRIPT DE VERIFICAÇÃO DE RAM   |"
echo "|_____________________________________________|"

echo
echo "Uso geral da RAM:"
top -bn1 | grep "Mem"

echo
echo "Uso da memória SWAP:"
top -bn1 | grep "Swap"

echo
echo "Cinco processos que mais utilizam RAM:"
ps -eo pid,user,comm,%mem --sort=-%mem | head -n 6