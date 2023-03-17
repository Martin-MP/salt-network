import os


class User:

    def __init__(self, name, domains):
        self.name = name
        self.domains = domains
    

def get_domains():
    users = list()
    for name in os.listdir('/var/www'):
        domains = dict()
        for domain in os.listdir(f'/var/www/{name}/'):
            domains[domain] = f'/var/www/{name}/{domain}'
        users.append(User(name, domains))
    return users


def print_domains(users):
    for user in users:
        if user.name == user[0].name:
            if user.name == user[-1].name:
                print(f"    ━━{user.name}")
            else:
                print(f"    ┏━{user.name}")
        elif user.name == user[-1].name:
            print(f"    ┗━{user.name}")
        else:
            print(f"    ┣━{user.name}")
        for domain in user.domains:
            if domain == user.domains[-1]:
                print(f"        ┗━{domain}")
            else:
                print(f"        ┣━{domain}")


users = get_domains()
print_domains(users)