#!/bin/bash
clear
RED='\033[0;31m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'
while [ x$username = "x" ]; do
    read -p "Pon el nombre de usuario sin espacios : " username
    if id -u $username >/dev/null 2>&1; then
        echo "Usuario existente"
        username=""
    fi
done
printf "\n${BLUE}>> Usuario Creado [$username] ${NC}\n"
while [ x$group = "x" ]; do
    read -p "Pon grupo primario, si no existe se creará : " group
    if id -g $group >/dev/null 2>&1; then
        echo "Grupo existente, si quieres usar uno existente cambialo manualmente más tarde"
    else
        groupadd $group
    fi
done
printf "\n${BLUE}>> $group creado para [$username] ${NC}\n"
read -p "Pon el bash [/bin/bash] : " bash
if [ x"$bash" = "x" ]; then
    bash="/bin/bash"
fi
read -p "Pon el homedir [/home/$username] : " homedir
if [ x"$homedir" = "x" ]; then
    homedir="/home/$username"
fi
read -p "Confirma [grupo:$group][usuario:$username] [y/n]" confirm
if [ "$confirm" = "y" ]; then
    useradd -g $group -s $bash -d $homedir -m $username
fi
passwd $username
printf "\n${BLUE}>> [$username] satisfactoramiente creado con [$group] ${NC}\n"
chown $username:$group $homedir
read -p "Dime nombre de tu página: " domain
if [ "$domain" != "" ]; then
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
    echo "192.168.7.14  $domain" >> /etc/hosts
    printf "\n${BLUE}>> VIRTUALHOST PARA SITIO [http://$domain] HABILITADO${NC}\n"
fi