# Trabalho Final de Segurança da Informação

## Descrição do Projeto
Este repositório contém o trabalho final da disciplina de **Segurança da Informação** do curso de **Bacharelado em Sistemas de Informação** (6º período). Desenvolvido pela dupla **Paulo Prado e Sara Luiz de Farias**, o projeto analisa um incidente de acesso não autorizado via SSH em um laboratório acadêmico, explorando vulnerabilidades, análise forense, impactos e propostas de mitigação. O foco é holístico: teoria (relatório em PDF), prática (simulações em VMs) e conscientização (políticas e treinamentos).

**Objetivos:**
- Diagnosticar vulnerabilidades (SSH mal configurado, redes não segmentadas, permissões excessivas, falta de rastreabilidade, pontos expostos e engenharia social).
- Demonstrar ataques simulados e técnicas de hardening.
- Propor políticas de segurança e planos de treinamento.
- Promover cultura de segurança ética e responsável.


**Ferramentas:** VMs (Linux), VirtualBox, Nmap, Hydra, Wireshark, Python/Bash scripts.  
**Aviso Importante:** Este projeto é para fins educacionais. Todas as simulações ocorrem em ambientes isolados (VMs sem internet). Não use em sistemas reais para evitar violações legais.


## Pré-Requisitos
- **Software:** VirtualBox ou VMware (gratuito).
- **Sistema Operacional:** https://linuxmint.com/download.php.
- **Hardware:** PC com 8GB RAM mínimo, 40GB espaço em disco.
- **Conhecimentos:** Básicos de Linux, redes e segurança (SSH, firewalls).
- **Rede:** Configure VMs em Internal Network (isolada) para simular laboratório.

## Instalação e Configuração
1. **Baixe e Instale VirtualBox:** [virtualbox.org](https://www.virtualbox.org/).
2. **Crie VMs:**
   - Duas VMs: "Vitima" e "Atacante" (2GB RAM, 20GB HD cada).
   - Monte o ISO do Linux e instale.
3. **Configure Rede Isolada:**
   - Em VirtualBox: Settings > Network > Internal Network > Name: "labnet".
   - Atribua IPs: Vítima (192.168.56.10), Atacante (192.168.56.20).
4. **Clone o Repositório:**
   - git clone
   - cd trabalhofinalSegurancaInformacao
6.  **Execute Setup Inicial na Vítima:**
   - chmod +x scripts/setup_vms.sh
   - ./scripts/setup_vms.sh
   - Isso instala SSH, configura vulnerabilidades simuladas (senhas fracas, permissões excessivas).

## Como Usar (Parte Prática)
### Demonstração de Ataques
Execute em sequência da VM Atacante. Documente com screenshots/logs (salve em `docs/pratica/`). Grave vídeos para apresentação.

1. **Ataque SSH (Brute-Force):**
- Comando: `hydra -l root -P wordlist.txt ssh://192.168.56.10` (wordlist com "weakpass").
- Código: `python3 scripts/ssh_brute.py`.
- Demonstre: Conecte via SSH e manipule arquivos.

2. **Redes Não Segmentadas:**
- Comando: `nmap -sP 192.168.56.0/24`.
- Código: `./scripts/scan_network.sh`.

3. **Permissões Excessivas:**
- Após SSH: `sudo su` (sem senha).
- Código: `./scripts/escalate_priv.sh`.

4. **Falta de Rastreabilidade:**
- Use conta compartilhada: `ssh victimuser@192.168.56.10`.
- Código: `./scripts/shared_account.sh`.

5. **Pontos Expostos:**
- Simule USB: Monte dispositivo e copie dados.
- Código: `./scripts/exposed_ports.sh`.

6. **Engenharia Social (Pretexting):**
- Código: `python3 scripts/pretexting_sim.py`.


### Aplicação de Hardening
Após ataques, mitigue na Vítima:
- Repita ataques: Devem falhar (ex.: SSH bloqueado, permissões revogadas).
- Documente: Logs antes/depois em `docs/pratica/`.

## Parte Teórica
- Leia o relatório em relatoriofinal.pdf`.
- Inclui análise de vulnerabilidades, forense (cadeia de custódia, logs), impactos e propostas (PUA, treinamentos).
