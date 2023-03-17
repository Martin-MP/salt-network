import os

minion = "saltMinion"
state = "hello"
name = input("¿Cómo te llamas?: ")
pillar = {
    "name": name
}
os.system(f"salt {minion} state.apply {state} pillar='{pillar}' >/dev/null")
