#!/bin/bash
clear
RED='\033[0;31m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'

ip=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
domain=""
ipdomain=""
username=""
password=""
group=""
bash="/bin/bash"


while [ $# -gt 0 ]; do
    key="$1"
    case $key in
        -ip)
        ip="$2"
        echo "Dirección IP DNS: $ip"
        shift; shift;;
        -d)
        domain="$2"
        echo "domain a añadir: $domain"
        shift; shift;;
        -id)
        ipdomain="$2"
        echo "IP del domain a añadir: $ipdomain"
        shift; shift;;
        -u)
        username="$2"
        echo "Usuario a crear: $username"
        shift; shift;;
        -p)
        password="$2"
        echo "Contraseña a crear: $password"
        shift; shift;;
        -g)
        group="$2"
        echo "Grupo a crear: $group"
        shift; shift;;
        -b)
        bash="$2"
        echo "Shell a usar: $bash"
        shift; shift;;
        *)
        # print how to use the script
        echo "Opción desconocida: $key"
        echo "Uso: $0 [-ip <ip dns>] [-d <domain>] [-id <ip domain>]"
        exit 1;;
    esac
done

# asign to the variable 'unattented' the value True if all keys are present
unattented=$( [ -n "$ip" ] && [ -n "$domain" ] && [ -n "$ipdomain" ] && [ -n "$username" ] && [ -n "$group" ] && [ -n "$homedir" ] && [ -n "$bash" ] && echo "True" || echo "False" )
if [ -z "$ip" ]; then
    read -p "Dirección IP DNS: " ip
fi
ping -c 1 $ip > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "La IP $ip no es alcanzable/válida"
    exit 1
fi
if [ -z "$domain" ]; then
    read -p "domain a añadir: " domain
fi
if [ -z "$ipdomain" ]; then
    read -p "IP del domain a añadir: " ipdomain
fi
if [ -z "$username" ]; then
    read -p "Usuario a crear: " username
fi
if [ -z "$password" ]; then
    read -p "Contraseña a crear: " password
fi
if [ -z "$group" ]; then
    read -p "Grupo a crear: " group
fi

while [ x$username = "x" ]; do # PEDIR USUARIO
    read -p "Pon el nombre de usuario sin espacios : " username
    if id -u $username >/dev/null 2>&1; then
        echo "Usuario existente"
        username=""
    fi
done
while [ x$group = "x" ]; do # PEDIR GRUPO
    read -p "Pon grupo primario, si no existe se creará : " group
    if id -g $group >/dev/null 2>&1; then
        echo "Grupo existente, si quieres usar uno existente cambialo manualmente más tarde"
    else
        groupadd $group
    fi
done
read -p "Pon el homedir [/home/$username] : " homedir # PEDIR HOMEDIR
if [ x"$homedir" = "x" ]; then
    homedir="/home/$username"
fi
read -p "Confirma [grupo:$group][usuario:$username] [y/n]" confirm # CONFIRMAR
if [ "$confirm" = "y" ]; then
    useradd -g $group -s $bash -d $homedir -m $username # CREAR USUARIO
fi
passwd $username
chown $username:$group $homedir
read -p "Dime nombre de tu página: " domain # PEDIR DOMINIO
while [ x$domain = "x" ]; do
    read -p "Dime nombre de tu página: " domain
done
printf "\n${BLUE}>> $group creado para [$username] ${NC}\n"
printf "\n${BLUE}>> Usuario Creado [$username] ${NC}\n"
printf "\n\t\t${BLUE}[CREANDO VIRTUAL HOST]${NC}\n\n"
printf "\n${BLUE}>> Creando carpetas para [$domain] ${NC}\n"
mkdir -p /var/www/$domain/public_html/
printf "\n${BLUE}>> Estableciendo permisos para usuario [$username] en sitio [$domain] ${NC}\n"
chmod 755 /var/www/$domain/
chmod 755 /var/www/$domain/public_html/
chown root:root /var/www/$domain
chown $username:$group /var/www/$domain/public_html/
touch /var/www/$domain/public_html/index.html
chown $username:$group /var/www/$domain/public_html/index.html
chmod 755 /var/www/$domain/public_html/index.html
printf "\n${BLUE}>> Creando archivos de configuracion para sitio [$domain] ${NC}\n"
touch /etc/apache2/sites-available/$domain.conf
echo "<VirtualHost *:80>
ServerName $domain
Redirect / https://$domain
</VirtualHost>
<VirtualHost *:443>
ServerAdmin admin@$domain
ServerName $domain
ServerAlias www.$domain
DocumentRoot /var/www/$domain/public_html
ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined
SSLEngine on
SSLCertificateFile /etc/apache2/certificate/apache-certificate.crt
SSLCertificateKeyFile /etc/apache2/certificate/apache.key
</VirtualHost>" > /etc/apache2/sites-available/$domain.conf
echo "Match Group $group
ChrootDirectory /var/www/$domain/
AllowTCPForwarding no
X11Forwarding no
ForceCommand internal-sftp
" >> /etc/ssh/sshd_config
systemctl restart ssh
printf "\n${BLUE}>> Habilitando sitio [$domain] ${NC}\n\n"
a2ensite $domain.conf
echo "<!DOCTYPE html>
<html>
<body>
<h1>La teva pagina $username</h1>
<h2>puja el teu $domain</h2>
</body>
</html>" >> /var/www/$domain/public_html/index.html
printf "\n${BLUE}>> Reiniciando apache2 ${NC}\n"
systemctl reload apache2
printf "\n${BLUE}>> Añadiendo sitio [$domain] a host[local]${NC}\n"
printf "\n${BLUE}>> VIRTUALHOST PARA SITIO [http://$domain] HABILITADO${NC}\n"


# Definir ancho máximo de cada columna
max_ipdns=15
max_domain=28
max_ipdomain=15

# Función para truncar los datos que exceden el ancho máximo
function truncar {
    local max_length=$1
    local string="$2"
    if [[ ${#string} -gt $max_length ]]; then
    string="${string:0:$max_length-3}..."
    fi
    printf "%-${max_length}s" "$string"
}

# Mostrar los datos en un cuadro con los anchos máximos y truncando los datos si es necesario
echo "┌─────────────────┬──────────────────────────────┬─────────────────┐"
echo "│ $(truncar $max_ipdns "IP DNS") │ $(truncar $max_domain "domain") │ $(truncar $max_ipdomain "IP domain") │"
echo "├─────────────────┼──────────────────────────────┼─────────────────┤"
echo "│ $(truncar $max_ipdns "$ip") │ $(truncar $max_domain "$domain") │ $(truncar $max_ipdomain "$ipdomain") │"
echo "└─────────────────┴──────────────────────────────┴─────────────────┘"

#echo -e "La información es la siguiente: \n IP DNS= $ip \n domain= $domain \n IP domain= $ipdomain \n"
if [ -z "$unattented" ]; then
    read -rp $'¿Desea proceder? (y/n):' confirm
    if [ "$confirm" != "y" ]; then
        echo "Operación cancelada."
        exit 0
    fi
fi
ssh root@$ip echo "$ipdomain $domain" >> /etc/hosts

if [ $? -eq 0 ]; then
    echo "La línea se ha añadido correctamente al archivo /etc/hosts."
else
    echo "Ha ocurrido un error al añadir la línea al archivo /etc/hosts."
fi