#!/bin/bash
nmap -sV -p 22 192.168.56.0/24  # Escaneia portas SSH abertas
echo "Dispositivos visíveis: $(arp -a)"  # Mostra ARP table
