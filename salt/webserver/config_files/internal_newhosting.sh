#!/bin/bash
RED='\033[0;31m'
NC='\033[0m' # No Color
BLUE='\033[0;36m'

ip=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
domain=""
ipdomain=""
username=""
password=""
group="clientes"
bash="/bin/bash"


while [ $# -gt 0 ]; do
    key="$1"
    case $key in
        -ip)
        ip="$2"
        shift; shift;;
        -d)
        domain="$2"
        shift; shift;;
        -id)
        ipdomain="$2"
        shift; shift;;
        -u)
        username="$2"
        shift; shift;;
        -p)
        password="$2"
        shift; shift;;
        -g)
        group="$2"
        shift; shift;;
        -b)
        bash="$2"
        shift; shift;;
        *)
        # print how to use the script
        echo "Opción desconocida: $key"
        echo "Uso: $0 [-ip <ip dns>] [-d <domain>] [-id <ip domain>]"
        exit 1;;
    esac
done

# asign to the variable 'unattented' the value True if all keys are present
if [ -z "$ip" ] || [ -z "$domain" ] || [ -z "$ipdomain" ] || [ -z "$username" ] || [ -z "$password" ] || [ -z "$group" ]; then
    unattented="False"
else
    unattented="True"
fi
if [ "$unattented" = "False" ]; then
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
        read -p "IP del domain a añadir (10.2.0.5): " ipdomain
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
done
if getent group $group >/dev/null 2>&1; then
    echo "Grupo existente, si quieres usar uno existente cambialo manualmente más tarde"
else
    echo "Grupo no existente, se creará"
fi
if [ "$unattented" = "True" ]; then
    confirm="y"
else
    read -p "Confirma [grupo:$group][usuario:$username] [y/n]" confirm # CONFIRMAR
fi
if [ "$confirm" != "y" ]; then
    exit 1
fi

useradd -g $group -s $bash -m $username # CREAR USUARIO
echo -e "$password\n$password" | passwd $username > /dev/null 2>&1 # CREAR CONTRASEÑA
while [ x$domain = "x" ]; do
    read -p "Dime nombre de tu página: " domain
done
printf "\n${BLUE}>> $group creado para [$username] ${NC}\n"
printf "\n${BLUE}>> Usuario Creado [$username] ${NC}\n"
printf "\n${BLUE}>> Creando carpetas para [$domain] ${NC}\n"
mkdir -p /var/www/$username/public_html/
printf "\n${BLUE}>> Estableciendo permisos para usuario [$username] en sitio [$domain] ${NC}\n"
chmod 755 /var/www/$username/
chmod 755 /var/www/$username/public_html/
chown root:root /var/www/$username
touch /var/www/$username/public_html/index.html
chown $username:$group /var/www/$username/public_html/
chown $username:$group /var/www/$username/public_html/index.html
chmod 755 /var/www/$username/public_html/index.html
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
DocumentRoot /var/www/$username/public_html
ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined
SSLEngine on
SSLCertificateFile /etc/apache2/certificate/apache2.cert
SSLCertificateKeyFile /etc/apache2/certificate/apache2.key
</VirtualHost>" > /etc/apache2/sites-available/$domain.conf
systemctl restart ssh
printf "\n${BLUE}>> Habilitando sitio [$domain] ${NC}\n\n"
a2ensite $domain.conf > /dev/null 2>&1
echo "<!DOCTYPE html>
<html>
<body>
<h1>La teva pagina $username</h1>
<h2>puja arxius en el teu $domain</h2>
</body>
</html>" >> /var/www/$username/public_html/index.html
printf "\n${BLUE}>> Reiniciando apache2 ${NC}\n"
systemctl reload apache2
printf "\n${BLUE}>> Añadiendo sitio [$domain] a host[local]${NC}\n"
printf "\n${BLUE}>> VIRTUALHOST PARA SITIO [http://$domain] HABILITADO${NC}\n\n"
usermod $username -d /public_html


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
printf "${BLUE}"
echo "┌─────────────────┬──────────────────────────────┬─────────────────┐"
echo "│ $(truncar $max_ipdns "IP DNS") │ $(truncar $max_domain "domain") │ $(truncar $max_ipdomain "IP domain") │"
echo "├─────────────────┼──────────────────────────────┼─────────────────┤"
echo "│ $(truncar $max_ipdns "$ip") │ $(truncar $max_domain "$domain") │ $(truncar $max_ipdomain "$ipdomain") │"
echo "└─────────────────┴──────────────────────────────┴─────────────────┘"
printf "${NC}"
#echo -e "La información es la siguiente: \n IP DNS= $ip \n domain= $domain \n IP domain= $ipdomain \n"
if [ -z "$unattented" ]; then
    read -rp $'¿Desea proceder? (y/n):' confirm
    if [ "$confirm" != "y" ]; then
        echo "Operación cancelada."
        exit 0
    fi
fi
ssh root@$ip 'echo '$ipdomain $domain' >> /etc/hosts && systemctl restart dnsmasq'

if [ $? -eq 0 ]; then
    printf "\n${BLUE}>> La línea se ha añadido correctamente al archivo /etc/hosts.${NC}\n"
else
    echo "Ha ocurrido un error al añadir la línea al archivo /etc/hosts."
fi
