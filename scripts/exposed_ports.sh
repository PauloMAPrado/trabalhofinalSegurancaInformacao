ssh root@192.168.56.10  # Após brute-force
sudo mkdir /mnt/usb  # Simula montagem
echo "dados roubados" > /mnt/usb/file.txt  # "Rouba" dados
cat /mnt/usb/file.txt  # Mostra
exit
