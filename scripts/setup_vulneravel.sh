#!/bin/bash

# =============================================================================
# SCRIPT: setup_vulneravel.sh
# OBJETIVO: Configura a VM Vítima para o trabalho de Segurança da Informação
# AUTORES: Paulo Prado & Sara Luiz de Farias
#
# AVISO: Este script cria vulnerabilidades propositalmente.
#        NÃO execute em máquinas de produção.
# =============================================================================

echo "[+] 1/7 - Atualizando repositórios de pacotes (apt-get update)..."
sudo apt-get update -y > /dev/null 2>&1

echo "[+] 2/7 - Instalando o servidor SSH (openssh-server)..."
sudo apt-get install openssh-server -y > /dev/null 2>&1

echo "[+] 3/7 - Criando usuário 'professor' (vítima do pretexting)..."
# Cria o usuário 'professor' com a senha 'senha_roubada_123'
sudo useradd -m -s /bin/bash professor
echo "professor:senha_roubada_123" | sudo chpasswd
echo "   -> Usuário 'professor' criado com senha 'senha_roubada_123'"

echo "[+] 4/7 - Criando conta compartilhada 'lab_admin' (Falta de Rastreabilidade)..."
# Cria o usuário 'lab_admin' com a senha fraca 'admin123'
sudo useradd -m -s /bin/bash lab_admin
echo "lab_admin:admin123" | sudo chpasswd
echo "   -> Usuário 'lab_admin' criado com senha 'admin123'"

echo "[+] 5/7 - Configurando 'Permissões Excessivas' (Vulnerabilidade sudo)..."
# Adiciona o usuário 'lab_admin' ao grupo sudo, dando-lhe poder total
sudo usermod -aG sudo lab_admin
echo "   -> Usuário 'lab_admin' adicionado ao grupo 'sudo'."

echo "[+] 6/7 - Configurando SSH para permitir login com senha (Vulnerabilidade)..."
# Garante que o sshd_config permita autenticação por senha (necessário para o ataque)
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo "   -> 'PasswordAuthentication yes' garantido no /etc/ssh/sshd_config"

echo "[+] 7/7 - Reiniciando o serviço SSH..."
sudo systemctl restart sshd

echo ""
echo "========================================================"
echo " A VM VÍTIMA está PRONTA e VULNERÁVEL."
echo "========================================================"
echo " Usuários criados:"
echo "   - professor (senha: senha_roubada_123)"
echo "   - lab_admin (senha: admin123) <-- Este usuário tem privilégios 'sudo'"
echo " IP da Máquina: $(hostname -I)"
echo "========================================================"
