import os
import time

class Minion:

    def __init__(self, name, ip, minion_id):
        self.name = name
        self.ip = ip
        self.id = minion_id
        self.up = False
        self.applied_state = 0
        self.calculate_log_name()
        
    def calculate_log_name(self):
        base_name = f"{time.strftime('%Y%m%d')}-{self.name}"
        base_path = "/root/salt_logs/"
        if os.path.isfile(f"{base_path}{base_name}.log"):
            i = 1
            while os.path.isfile(f"{base_path}{base_name}-{i}.log"):
                i += 1
            self.log_name = f"{base_name}_{i}.log"
        else:
            self.log_name = f"{base_name}.log"

    def set_up(self):
        self.up = True

    def check_up(self):
        pid_code = os.system(f"ping -c 1 {self.ip} > /dev/null 2>&1")
        if pid_code == 0:
            self.set_up()
            return True
        else:
            return False

    def apply_state(self):
        pid_code = os.system(f"salt '*{self.id}*' state.apply > /root/salt_logs/{self.log_name} 2>&1")
        if pid_code == 0:
            print(f"  \033[92mSuccessfully applied state on {self.name}\033[0m")
            self.applied_state = 1
        else:
            print(f"  \033[91mFailed to apply state on {self.name}. See /root/salt_logs/{self.log_name} for details\033[0m")


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

if not os.path.isdir("/root/salt_logs"):
    os.mkdir("/root/salt_logs")
minions = {
    "nftables": Minion("nftables", "192.168.1.1", "nft"),
    "dnsmasq": Minion("dnsmasq", "192.168.1.4", "dnsmasq"),
    "webserver": Minion("webserver", "10.2.0.5", "web"),
    "vpn": Minion("vpn", "192.168.1.6", "vpn")
}
print("\nSTARTING THE SALT SCRIPT...\n")
minions["nftables"].apply_state()
minions["dnsmasq"].apply_state()
other_minions = [minion for minion in minions.values() if minion.name not in ["nftables", "dnsmasq"]]
for minion in other_minions:
    minion.apply_state()
total_states_applied = sum([minion.applied_state for minion in minions.values()])
print("\n\033[91mNo states applied :(\033[0m\n") if total_states_applied == 0 else \
print(f"\nSuccessfully applied \033[92m{total_states_applied}\033[0m/{len(minions)}\n")