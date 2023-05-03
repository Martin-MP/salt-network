import os
import time
import paramiko


connection = paramiko.SSHClient()
connection.set_missing_host_key_policy(paramiko.AutoAddPolicy())
connection.connect('pdsx.ins-mediterrania.cat', username="martin", password="perez")
ftp = connection.open_sftp()
while True:
    acceptades = list()
    rebutjades = list()
    os.system('clear')
    correccions = ftp.listdir('correccions')
    for correccio in correccions:
        if 'ACCEPTAT' in correccio:
            acceptades.append(correccio)
        if 'REBUTJAT' in correccio:
            rebutjades.append(correccio)
    print(f"\nUSER: {connection.get_transport().get_username()}")
    print(f"HOST: {connection.get_transport().getpeername()[0]}")
    print('\nAcceptades: ' + str(len(acceptades)))
    for acceptada in acceptades:
        print('\033[92m' + acceptada + '\033[0m')
    print('\nRebutjades: ' + str(len(rebutjades)))
    for rebutjada in rebutjades:
        print('\033[91m' + rebutjada + '\033[0m')
    time.sleep(2)