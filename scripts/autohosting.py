import os


class User:

    def __init__(self, user, domains):
        self.user = user
        self.domains = domains
    

def get_domains():
    users = list()
    for user in os.listdir('/var/www'):
        domains = dict()
        for domain in os.listdir(f'/var/www/{user}/'):
            domains[domain] = f'/var/www/{user}/{domain}'
        users.append(User(user, domains))
    return users


def print_domains(users):
    for user in users:
        if user == user[0]:
            if user == user[-1]:
                print(f"    ━━{user.user}")
            else:
                print(f"    ┏━{user.user}")
        elif user == user[-1]:
            print(f"    ┗━{user.user}")
        else:
            print(f"    ┣━{user.user}")
        for domain in user.domains:
            if domain == user.domains[-1]:
                print(f"        ┗━{domain}")
            else:
                print(f"        ┣━{domain}")