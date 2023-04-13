#!/bin/bash
echo -e "\e[1;32mBienvenido a la creación de certificados\e[0m"
echo -e "\e[1;32mEste script te ayudará a crear los certificados para los clientes\e[0m"
echo -e "\e[1;32m=====================================================================\e[0m"
read -p "¿Cómo quieres que se llame el certificado? " certificado
echo "[LOG] Este es el nombre de tu certificado: $certificado"
cd /root
echo -e "[LOG] Generando los certificados y firmandolos"
/usr/share/easy-rsa/easyrsa --batch gen-req $certificado nopass > /dev/null 2>&1
/usr/share/easy-rsa/easyrsa --batch sign-req client $certificado > /dev/null 2>&1
echo "[LOG] Todos los ficheros han sido creados"
mkdir /home/templates
cd /home/templates
touch $certificado.conf
echo "[LOG] La ip local es la siguiente:"
ip -c a show enp0s3 | grep 'inet ' | awk '{print $2}'
read -p "¿Que ip se va a conectar el cliente? [Firewall-Externa]: " ip
echo "client
proto udp
dev tun
remote $ip 1194
ca ca.crt
cert $certificado.crt
key $certificado.key
redirect-gateway def1" >> /home/templates/$certificado.conf
echo "[LOG] Transeferencia de archivos"
read -p "¿Cual es IP destino (Cliente): " destip
while ! ping -c 1 -W 1 $destip &> /dev/null
do
    echo "[LOG] IP no válida o no alcanzable"
    read -p "¿Cual es IP destino (Cliente): " destip
done
read -p "¿Cual es tu usuario para hacer scp? (Cliente) [nada = 'root']: " user
if [ -z $user ]; then
    user="root"
fi
read -p "¿Que ruta desea? (Cliente): " rute
echo -e "[LOG] Realizando la transmisión a $destip y ficheros necesarios"
cd /home
mkdir -p /home/$certificado/$certificado
cp -r /home/templates/$certificado.conf /home/$certificado/$certificado
cp /etc/openvpn/easy-rsa/keys/ca.crt /home/$certificado/$certificado
cp /root/pki/issued/$certificado.crt /home/$certificado/$certificado
cp /root/pki/private/$certificado.key /home/$certificado/$certificado
echo -e "[LOG] Ficheros necesarios ubicados en /home/$certificado/$certificado"
scp -q -r /home/$certificado/* $user@$destip:$rute
if [ $? -eq 0 ]; then
    echo "[LOG] Transmisión realizada con éxito"
else
    echo "[LOG] Error en la transmisión, comprueba la ruta y el usuario"
fi
echo -e "[LOG] Transmisión realizada a la ip $destip con $user en la siguiente ruta: $rute"