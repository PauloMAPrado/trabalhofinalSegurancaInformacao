#!/bin/bash
# Execute na Vítima para configurar vulnerabilidades
sudo apt update
sudo apt install openssh-server
sudo useradd victimuser
echo "victimuser:weakpass" | sudo chpasswd
sudo usermod -aG sudo victimuser
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh
echo "Configuração concluída. Vulnerabilidades simuladas."
