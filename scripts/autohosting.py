import os


class User:

    def __init__(self, name, domains):
        self.name = name
        self.domains = domains
    

def get_users():
    users = list()
    for name in os.listdir('/var/www'):
        domains = dict()
        for domain in os.listdir(f'/var/www/{name}/'):
            domains[domain] = f'/var/www/{name}/{domain}'
        users.append(User(name, domains))
    return users


def print_users(users):
    for user in users:
        print(f"{user.name}")
        for domain in user.domains:
            if domain == list(user.domains)[-1]:
                print(f"    ┗━{domain}")
            else:
                print(f"    ┣━{domain}")


users = get_users()
for user in users:
    print(user.__dict__)
print_users(users)