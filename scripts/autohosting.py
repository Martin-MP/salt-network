import os
import getpass


class User:

    def __init__(self, name, domains):
        self.name = name
        self.domains = domains
    

def root_check():
    if os.geteuid() != 0:
        print("You have to run this script as root 😡")
        exit()


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
        print(f"\n{user.name}")
        for domain in user.domains:
            if domain == list(user.domains)[-1]:
                print(f"    ┗━{domain}")
            else:
                print(f"    ┣━{domain}")


def menu(title, options):
    print(f"\n{title}")
    for i, option in enumerate(options):
        if i == len(options) - 1:
            print(f"    ┗━{options.index(option) + 1}. {option}")
        else:
            print(f"    ┣━{options.index(option) + 1}. {option}")
    ans = input("\nSelect an option: ")
    options_string = ', '.join(str(i) for i in range(1, len(options) + 1))
    while True:
        try:
            ans = int(ans)
            if ans in range(1, len(options) + 1):
                break
            else:
                ans = input(f"You have to type {options_string} 😡: ")
        except ValueError:
                ans = input("You have to type a number 😡: ")
    return ans


def get_new_name():
    name = input("\nType the name of the user: ")
    while True:
        if name == "":
            name = input("You have to type a name 😡: ")
        elif name in os.listdir('/var/www'):
            name = input("This user already exists 😡: ")
        elif " " in name:
            name = input("You can't use spaces 😡: ")
        else:
            break
    return name


def get_new_password():
    password = getpass.getpass("\nType the password for the user: ")
    while True:
        if password == "":
            password = getpass.getpass("You have to type a password 😡: ")
        elif " " in password:
            password = getpass.getpass("You can't use spaces 😡: ")
        elif getpass.getpass("Confirm password: ") != password:
            password = getpass.getpass("Passwords don't match 😡: ")
        else:
            break
    return password


def get_new_domain():
    domain = input("\nType the domain name: ")
    while True:
        if domain == "":
            domain = input("You have to type a domain 😡: ")
        elif " " in domain:
            domain = input("You can't use spaces 😡: ")
        elif "." not in domain:
            domain = input("You have to type a domain with a extension 😡: ")
        elif domain.count(".") > 1:
            domain = input("You have to type a domain with a valid 😡: ")
        elif domain in os.listdir('/var/www'):
            domain = input("This domain already exists 😡: ")
        else:
            break
    return domain


def create_user_directory(name):
    os.system(f"mkdir /var/www/{name} > /dev/null 2>&1")
    print(f"\nUser directory created in /var/www/{name}")

def create_domain_directory(name, domain):
    os.system(f"mkdir /var/www/{name}/{domain} > /dev/null 2>&1")
    print(f"\nDomain directory created in /var/www/{name}/{domain}")


root_check()
main_loop = True
while main_loop:
    ans = menu(
        "MAIN MENU", [
            "Create user or domain",
            "Delete user or domain",
            "List users and domains",
            "Exit"
        ]
    )
    if ans == 1:
        sub_ans = menu(
            "CREATE MENU", [
                "Create user",
                "Create domain",
                "Back"
            ]
        )
        if sub_ans == 1:
            name = get_new_name()
            password = get_new_password()
        elif sub_ans == 2:
            pass
    elif ans == 2:
        sub_ans = menu(
            "DELETE MENU", [
                "Delete user",
                "Delete domain",
                "Back"
            ]
        )
        if sub_ans == 1:
            pass
        elif sub_ans == 2:
            pass
    elif ans == 3:
        users = get_users()
        print_users(users)
    else:
        main_loop = False
print("\nGoodbye 👋😉\n")