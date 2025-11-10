````markdown
# Trabalho Final de Segurança da Informação (BSI 6º Período)

## 1. Descrição do Projeto
Este repositório contém o trabalho final da disciplina de **Segurança da Informação** (2025/02), desenvolvido por **Paulo Prado** e **Sara Luiz de Farias**.

O projeto consiste na análise de um incidente de segurança em um laboratório acadêmico (acesso não autorizado via SSH). Atuando como uma consultoria de segurança, este trabalho apresenta:
1.  **Relatório Teórico:** Uma análise forense do incidente, diagnóstico de vulnerabilidades, análise de impacto e um plano de ação.
2.  **Demonstração Prática:** Uma simulação em ambiente controlado (VMs) que replica os ataques e, o mais importante, demonstra a aplicação de técnicas de *hardening* para mitigá-los.

### Vulnerabilidades Analisadas
Conforme a proposta, o trabalho explora o cenário base (SSH com senha fraca) e mais 5 vulnerabilidades identificadas:
1.  Acesso SSH via Senha Fraca (Cenário Base)
2.  Redes Não Segmentadas
3.  Permissões Excessivas (Abuso de `sudo`)
4.  Falta de Rastreabilidade (Contas Compartilhadas)
5.  Pontos de Rede Expostos
6.  Engenharia Social (Pretexting)

**Aviso Importante:** Este projeto é estritamente para fins acadêmicos. Todas as simulações devem ser executadas em um ambiente de rede isolado (VMs em *Internal Network*). Não tente replicar em sistemas de produção.

## 2. Diagrama da Arquitetura
O ambiente prático simula a rede do laboratório de forma isolada, conforme exigido.

**Diagrama de Rede (Vulnerável vs. Mitigada):**
<img width="521" height="321" alt="Diagrama de rede segmentada" src="[https://github.com/user-attachments/assets/7bce666c-bd90-4735-ad03-c968f3a3a0ce](https://github.com/user-attachments/assets/7bce666c-bd90-4735-ad03-c968f3a3a0ce)" />

**Ferramentas:** VMs (Linux), VirtualBox, Nmap, Python/Bash scripts.

## 3. Instalação e Configuração do Ambiente

### Pré-Requisitos
* **Software:** VirtualBox ou VMware.
* **Imagens OS:** Duas VMs Linux (ex: Ubuntu Server para "Vítima", Kali ou Linux Mint para "Atacante").
* **Hardware:** Mínimo 8GB RAM.
* **Rede:** Conhecimento básico de configuração de rede em VMs.

### Passos para Configuração
1.  **Criação das VMs:**
    * Crie duas máquinas virtuais ("Vitima" e "Atacante").
    * Instale o sistema operacional em ambas.

2.  **Configuração da Rede Isolada:**
    * No VirtualBox, vá em `Configurações > Rede` de **ambas** as VMs.
    * Mude `Conectado a:` para `Rede Interna`.
    * Defina o `Nome:` como `labnet`.
    * **Importante:** Isso isola as VMs do seu PC e da internet.

3.  **Configuração de IPs Estáticos:**
    * Inicie as VMs e configure os IPs manualmente (ex: editando `/etc/netplan/01-netcfg.yaml` no Ubuntu).
    * **VM Vítima:** `192.168.1.10`
    * **VM Atacante:** `192.168.1.20`
    * Teste a conectividade: `ping 192.168.1.10` (a partir do Atacante).

4.  **Configuração do Ambiente Vulnerável (Setup Inicial):**
    * **Atenção:** Para instalar as ferramentas (`ssh`, `nmap`, `ufw`, `libpam-google-authenticator`), as VMs precisarão de internet temporariamente. Use o "Método dos 2 Adaptadores" (Adaptador 1 = Rede Interna, Adaptador 2 = NAT) para instalar tudo e, **antes da apresentação**, desabilite o Adaptador 2 (NAT).
    * Clone este repositório na VM Vítima.
    * `git clone https://github.com/PauloMAPrado/trabalhofinalSegurancaInformacao.git`
    * `cd trabalhofinalSegurancaInformacao`
    * `chmod +x scripts/setup_vulneravel.sh`
    * `./scripts/setup_vulneravel.sh`
    * *Nota: Este script irá (1) instalar o `openssh-server`, (2) criar contas de usuário vulneráveis (ex: `lab_admin`, `professor`) e (3) configurar permissões de `sudo` indevidas.*

## 4. Parte Prática: Demonstração (Ataque e Hardening)
Esta seção é o núcleo da parte prática, demonstrando cada vulnerabilidade e sua respectiva mitigação.

---

### Cenário 1: Acesso SSH via Senha Fraca (Cenário Base)
* **Descrição:** O serviço SSH tem acesso fácil quando as maquinas compartilham o mesmo usuário e senha

#### 1.A - Ataque
```bash
# Scan de descoberta na rede
nmap -sn 192.168.1.0/24 

# Scan de portas no alvo
nmap -sV 192.168.1.10

# Tente o login SSH
ssh professor@192.168.1.10 

# Usando a senha de acesso ('senha_roubada_123'), você comanda a máquina remotamente
````

#### 1.B - Hardening

> A configuração do usuário SSH precisa ser bem protegida para que não haja problemas na rede.
> Por padrão, SSH não deveria aceitar a senha do computador como senha pra acesso remoto.
> Um simples 'PasswordAuthentication no' no arquivo sshd\_config do SSH desabilita essa função

-----

### Cenário 2: Redes Não Segmentadas

  * **Descrição:** O salão de festas

#### 2.A - Ataque

```bash
# Scan de descoberta na rede
nmap -sn 192.168.1.0/24 

# Scan de portas no alvo
nmap -sV 192.168.1.10

# Tente o login SSH
ssh professor@192.168.1.10 

# Usando a senha de acesso, você comanda a máquina remotamente
```

#### 2.B - Hardening

> Temos aqui o mesmo código, logo que o acesso via SSH depende da abertura da configuração do SSH e de uma rede plana.
> Aqui, não há barreiras entre computadores, uma máquina de um laboratório vê máquinas de outro laboratório e tudo fica exposto.
> Neste caso, a solução seria separar as redes (VLANs), como mostrado no diagrama da Seção 2.

-----

### Cenário 3: Permissões Excessivas (Abuso de `sudo`)

  * **Descrição:** Com fácil acesso a maquina, senha simples e compartilhada, o atacante se torna um Deus na máquina

#### 3.A - Ataque

```bash
# Desligando a máquina
sudo shutdown -h now
```

#### 3.B - Hardening

> Aqui demonstramos apenas como desligar a máquina, mas o limite é a criatividade do atacante.
> Dados podem ser roubados, acessos realizados, tudo pode acontecer.
> A solução então é que o super usuário seja permitido apenas pelo pessoal altorizado.
> Os únicos que devem conter o acesso ao super usuário são os funcionários do departamento de TI.

-----

### Cenário 4: Falta de Rastreabilidade (Contas Compartilhadas)

  * **Descrição:** O uso de contas genéricas (`lab_admin`) impossibilita a auditoria e a resposta a incidentes.

#### 4.A - Ataque

Na **VM Atacante**, use a credencial compartilhada para acessar e causar dano:

```bash
# Atacante usa a conta compartilhada
$ ssh lab_admin@192.168.1.10
(Senha: "admin123") # Senha definida no script de setup

# Ação maliciosa (ex: apagar logs)
(lab_admin)$ sudo rm /var/log/auth.log
```

Na **VM Vítima**, o log de forense é inútil para identificar a *pessoa*:

```bash
# Log mostra 'lab_admin', mas não quem (Paulo, Sara, etc.)
$ journalctl -u sshd -n 5
# SAÍDA: ... Accepted password for lab_admin from 192.168.1.20 ...
```

#### 4.B - Hardening

Na **VM Vítima**, bloqueie contas genéricas e force o uso de contas nominais (conforme PUA):

```bash
# 1. Bloquear (lock) a conta compartilhada
$ sudo passwd -l lab_admin

# 2. (Opcional) Criar contas nominais
$ sudo adduser paulo
$ sudo adduser sara
```

**Validação:** Tente logar da **VM Atacante** como `lab_admin`. O acesso será negado (`Permission denied`). Qualquer ação futura será registrada no log com um nome de usuário individual.

-----

### Cenário 5: Pontos de Rede Expostos

  * **Descrição:** Um ponto de rede físico ativo permite que um atacante conecte seu dispositivo e mapeie a rede interna (vulnerabilidade agravada pela falta de segmentação).

#### 5.A - Ataque

Na **VM Atacante** (simulando plugar no ponto de rede), mapeie a rede:

```bash
# 1. Descobrir hosts vivos na sub-rede (o "ping scan")
$ nmap -sn 192.168.1.0/24
# SAÍDA: Host 192.168.1.10 is up.

# 2. Varrer as portas do alvo descoberto
$ nmap -p 22,80,445 192.168.1.10
# SAÍDA: PORT 22/tcp open ssh
```

**Resultado:** O atacante descobriu o IP da Vítima e seu serviço SSH.

#### 5.B - Hardening

Na **VM Vítima**, aplique um firewall de host (UFW) como camada de defesa. A mitigação ideal (802.1X) é no switch, mas o firewall local é crucial.

```bash
# 1. Instalar o firewall (feito na Etapa 3)
# $ sudo apt-get install ufw

# 2. Bloquear tudo por padrão
$ sudo ufw default deny incoming
$ sudo ufw default allow outgoing

# 3. Permitir SSH APENAS de um IP/Rede de Gerência
$ sudo ufw allow from 192.168.100.0/24 to any port 22 # IP de Gerência Fictício

# 4. Ativar o firewall
$ sudo ufw enable
```

**Validação:** Rode o `nmap` novamente da **VM Atacante** (IP `192.168.1.20`). O scan falhará (`filtered` ou `closed`), pois o IP do atacante não está na lista de permissão.

-----

### Cenário 6: Engenharia Social (Pretexting) e 2FA

  * **Descrição:** O atacante usa um pretexto (ex: "Suporte de TI") para roubar a senha da vítima (professor).

#### 6.A - Ataque

1.  **Encenação:** Simule a ligação do "TI" pedindo a senha do professor para "verificar um alerta".
2.  Na **VM Atacante**: Use a senha roubada.

<!-- end list -->

```bash
$ ssh professor@192.168.1.10
(Senha: "senha_roubada_123")
# SAÍDA: Acesso concedido!
```

#### 6.B - Hardening

Na **VM Vítima**, implemente a Autenticação de Dois Fatores (MFA/2FA) no SSH, protegendo contra o vazamento da senha.

```bash
# 1. Instale o módulo PAM (feito na Etapa 3)
# $ sudo apt-get install libpam-google-authenticator

# 2. Rode o setup (como o usuário 'professor', NÃO como root)
# SUBLINHE que deve ser executado pelo usuário que vai usar o 2FA
$ su - professor
(Digite a senha do usuário 'professor')
$ google-authenticator
# (Responda 'y' (sim) para as perguntas e escaneie o QR Code com seu celular)

# 3. Configure o SSH para exigir o 2FA (como root/sudo)
$ sudo nano /etc/ssh/sshd_config
# Mude/adicione a linha:
ChallengeResponseAuthentication yes

# 4. Configure o PAM (como root/sudo)
$ sudo nano /etc/pam.d/sshd
# Adicione no topo do arquivo:
auth required pam_google_authenticator.so

# 5. Reinicie o serviço
$ sudo systemctl restart sshd
```

**Validação:** Tente logar da **VM Atacante** novamente. O sistema pedirá a senha (`Password:`) E o `Verification code:`. O atacante não possui o código, e o ataque falha.

-----

## 5\. Parte Teórica (Relatório)

Leia o relatório completo (`relatoriofinal.pdf`) neste repositório para a análise detalhada de vulnerabilidades, forense (cadeia de custódia, logs), impactos e propostas (PUA, treinamentos).

## 6\. Autores

  * **Paulo Prado** - ([@PauloMAPrado](https://www.google.com/search?q=https://github.com/PauloMAPrado))
  * **Sara Luiz de Farias**

<!-- end list -->

```
```
