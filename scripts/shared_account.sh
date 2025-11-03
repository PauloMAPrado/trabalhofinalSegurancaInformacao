ssh victimuser@192.168.56.10  # Conecta
echo "ação anônima" >> /tmp/log.txt  # Ação sem rastreamento
grep "victimuser" /var/log/auth.log  # Verifica logs limitados
exit
