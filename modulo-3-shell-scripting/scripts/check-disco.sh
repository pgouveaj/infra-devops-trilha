#!/bin/bash

echo "________________________________________________"
echo "|                                               |"
echo "|   EXECUTANDO SCRIPT DE VERIFICAÇÃO DE DISCO   |"
echo "|_______________________________________________|"

echo
echo "Uso das partições:"
df -h

echo
echo "Cinco diretórios que mais ocupam espaço:"
du -xh / 2>/dev/null | sort -hr | head -n 5