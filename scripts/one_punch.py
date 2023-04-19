import argparse
import os

class Minion:
    def __init__(self, name, ip):
        self.name = name
        self.ip = ip
        self.up = False
    
    def set_up(self):
        self.up = True

minion_list = [
    Minion('nftables', '192.168.1.1'),
    Minion('dhcpdns', '192.168.1.4'),
    Minion('webserver', '10.2.0.5'),
    Minion('vpn', '192.168.1.6')
]


while True:
    all_up = True
    for minion in minion_list:
        if not minion.up:
            # ping the minion
            response = os.system("ping -c 1 " + minion.ip)
            print("TRYING TO PING " + minion.name)
            print(response)
            if response == 0:
                minion.set_up()
                print(minion.name + " is up!")
            else:
                all_up = False
                print(minion.name + " is down!")
            break
    if all_up:
        break