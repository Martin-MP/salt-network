#!/bin/bash
echo -e "\e[1;32mBienvenido a la creación de certificados\e[0m"
echo -e "\e[1;32mEste script te ayudará a crear los certificados para los clientes\e[0m"
echo -e "\e[1;32m=====================================================================\e[0m"
read -p "¿Cómo quieres que se llame el certificado? " certificado
echo "Este es el nombre de tu certificado: $certificado"
cd /usr/share/easy-rsa
echo -e "Generando los certificados y firmandolos"
./easyrsa --batch gen-req $certificado nopass > /dev/null 2>&1
./easyrsa --batch sign-req client $certificado > /dev/null 2>&1
echo "todos los ficheros creados"
cd /home/templates
touch $certificado.conf
echo "La ip local es la siguiente:"
ip -c a show enp0s3 | grep 'inet ' | awk '{print $2}'
read -p "¿Que ip se va a conectar el cliente? [Firewall-Externa]: " ip
echo "client
proto udp
dev tun
remote $ip 1194
ca ca.crt
cert $certificado.crt
key $certificado.key" >> /home/templates/$certificado.conf
echo "Transeferencia de archivos"
read -p "¿Cual es IP destino [Cliente]: " destip
while ! ping -c 1 -W 1 $destip &> /dev/null
do
    echo "IP no válida o no alcanzable"
    read -p "¿Cual es IP destino [Cliente]: " destip
done
read -p "¿Cual es tu usuario para hacer scp? [Cliente]: " user
read -p "¿Que ruta desea? [Cliente]: " rute
echo -e "Realizando la transmisión a $destip y ficheros necesarios"
cd /home
mkdir -p /home/$certificado/$certificado
cp -r /home/templates/$certificado.conf /home/$certificado/$certificado
cp /usr/share/easy-rsa/pki/ca.crt /home/$certificado/$certificado
cp /usr/share/easy-rsa/pki/issued/$certificado.crt /home/$certificado/$certificado
cp /usr/share/easy-rsa/pki/private/$certificado.key /home/$certificado/$certificado
echo -e "ficheros necesarios ubicados en /home/$certificado/$certificado"
scp -q -r /home/$certificado/* $user@$destip:$rute
if [ $? -eq 0 ]; then
    echo "Transmisión realizada con éxito"
else
    echo "Error en la transmisión, comprueba la ruta y el usuario"
fi
echo -e "Transmisión realizada a la ip $destip con $user en la siguiente ruta: $rute"