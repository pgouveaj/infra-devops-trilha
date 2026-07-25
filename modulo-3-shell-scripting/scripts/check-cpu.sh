echo "______________________________________________"
echo "|                                             |"
echo "|   EXECUTANDO SCRIPT DE VERIFICAÇÃO DE CPU   |"
echo "|_____________________________________________|"

echo
echo "Uso geral da CPU:"
top -bn1 | grep "Cpu(s)"

echo
echo "Cinco processos que mais utilizam CPU:"
ps -eo pid,user,comm,%cpu --sort=-%cpu | head -n 6