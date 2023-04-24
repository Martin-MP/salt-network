import argparse
import os
import subprocess

class Minion:
    def __init__(self, name, ip, minion_id):
        self.name = name
        self.ip = ip
        self.id = minion_id
        self.up = False

    def set_up(self):
        self.up = True
    
    def apply_state(self):
        os.system(f"salt '*{self.id}*' state.apply")


minions = {
    nftables: Minion("nftables", "192.168.1.1", "nft"),
    dnsmasq: Minion("dnsmasq", "192.168.1.4", "dnsmasq"),
    webserver: Minion("webserver", "10.2.0.5", "web"),
    vpn: Minion("vpn", "192.168.1.6", "vpn")
}
while True:
    all_up = True
    for minion in minion_list:
        if not minion.up:
            response = os.system("ping -c 1 " + minion.ip)
            print("TRYING TO PING " + minion.name)
            if response == 0:
                minion.set_up()
                print(minion.name + " is up!")
            else:
                all_up = False
                print(minion.name + " is down!")
    if all_up:
        break


# Ejecuta el comando
minions[nftables].apply_state()
minions[dnsmasq].apply_state()
