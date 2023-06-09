│#!/bin/bash
clear

ip=""
dominio=""
ipdominio=""

while [ $# -gt 0 ]; do
    key="$1"
    case $key in
        -ip)
        ip="$2"
        echo "Dirección IP DNS: $ip"
        shift; shift;;
        -d)
        dominio="$2"
        echo "Dominio a añadir: $dominio"
        shift; shift;;
        -id)
        ipdominio="$2"
        echo "IP del dominio a añadir: $ipdominio"
        shift; shift;;
        *)
        # print how to use the script
        echo "Opción desconocida: $key"
        echo "Uso: $0 [-ip <ip dns>] [-d <dominio>] [-id <ip dominio>]"
        exit 1;;
    esac
done


# asign to the variable 'unattented' the value True if all keys are present
unattented=$(if [ -n "$ip" ] && [ -n "$dominio" ] && [ -n "$ipdominio" ]; then echo "True"; fi)

if [ -z "$ip" ]; then
    read -p "Dirección IP DNS: " ip
fi

ping -c 1 $ip > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "La IP $ip no es alcanzable/válida"
    exit 1
fi

if [ -z "$dominio" ]; then
    read -p "Dominio a añadir: " dominio
fi

if [ -z "$ipdominio" ]; then
    read -p "IP del dominio a añadir: " ipdominio
fi

# Definir ancho máximo de cada columna
max_ipdns=15
max_dominio=28
max_ipdominio=15

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
echo "│ $(truncar $max_ipdns "IP DNS") │ $(truncar $max_dominio "Dominio") │ $(truncar $max_ipdominio "IP Dominio") │"
echo "├─────────────────┼──────────────────────────────┼─────────────────┤"
echo "│ $(truncar $max_ipdns "$ip") │ $(truncar $max_dominio "$dominio") │ $(truncar $max_ipdominio "$ipdominio") │"
echo "└─────────────────┴──────────────────────────────┴─────────────────┘"

#echo -e "La información es la siguiente: \n IP DNS= $ip \n Dominio= $dominio \n IP Dominio= $ipdominio \n"
if [ -z "$unattented" ]; then
    read -rp $'¿Desea proceder? (y/n):' confirm
    if [ "$confirm" != "y" ]; then
        echo "Operación cancelada."
        exit 0
    fi
fi
ssh root@$ip echo "$ipdominio $dominio" >> /etc/hosts

if [ $? -eq 0 ]; then
    echo "La línea se ha añadido correctamente al archivo /etc/hosts."
else
    echo "Ha ocurrido un error al añadir la línea al archivo /etc/hosts."
fi
