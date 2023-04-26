import os
import time

class Minion:
    def __init__(self, name, ip, minion_id):
        self.name = name
        self.ip = ip
        self.id = minion_id
        self.up = False

    def set_up(self):
        self.up = True

    def check_up(self):
        response = os.system(f"ping -c 1 {self.ip} > /dev/null 2>&1")
        if response == 0:
            self.set_up()
            return True
        else:
            return False
    
    def apply_state(self):
        #response = os.popen(f"salt '*{self.id}*' state.apply").read()
        response = os.system(f"salt '*{self.id}*' state.apply")
        print(response)


def check_all_up(timeout=20):
    start_time = time.time()
    while any(not minion.up for minion in minions.values()):
        for minion in minions.values():
            if not minion.up:
                if minion.check_up():
                    print(minion.name + " is up!")
                else:
                    print(minion.name + " is down!")
        if time.time() - start_time > timeout:
            raise TimeoutError(f"{timeout} seconds timeout while waiting for minions to start up")


minions = {
    "nftables": Minion("nftables", "192.168.1.1", "nft"),
    "dnsmasq": Minion("dnsmasq", "192.168.1.4", "dnsmasq"),
    "webserver": Minion("webserver", "10.2.0.5", "web"),
    "vpn": Minion("vpn", "192.168.1.6", "vpn")
}
minions["dnsmasq"].apply_state()
#minions["nftables"].apply_state()
#minions["dnsmasq"].apply_state()
#other_minions = [minion for minion in minions.values() if minion.name not in ["nftables", "dnsmasq"]]
#for minion in other_minions:
#    minion.apply_state()