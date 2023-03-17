import os

minion = "saltMinion"

class State:

    def __init__(self, state, pillar)
        self.state = state
        self.pillar = pillar


state.append(State("dhcp_dns", None))
os.system(f"salt {minion} state.apply {state} pillar='{pillar}' >/dev/null")
