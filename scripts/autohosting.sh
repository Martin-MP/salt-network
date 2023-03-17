#!/bin/bash

cyan="\e[36m"
red="\e[31m"
green="\e[32m"
white="\e[97m"
reset="\e[0m"

spinner() {  # SPINNER ANIMATION
    local info="$1"
    local pid=$2
    local delay=0.15
    local spinstr='|/-\'
    while kill -0 $pid 2> /dev/null; do
        local temp=${spinstr#?}
        printf "$cyan[%c]  $info" "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        local reset="\b\b\b\b\b\b"
        for ((i=1; i<=$(echo $info | wc -c); i++)); do
            reset+="\b"
        done
        printf $reset
    done
    printf "    \b\b\b\b"
}

list_allhosts() {
    cd /var/www || exit
    for d in */
    do
        echo -e "${cyan}$d" | cut -d "/" -f -1
        cd /var/www/"$d" || exit
        lln=0
        for d1 in *
        do
            lln=$((lln+1))
        done
        ln=0
        for d1 in *
        do
            ln=$((ln+1))
            if [[ $ln = "$lln" ]]; then
                echo -e "${cyan}└─$d1" | cut -d "/" -f -1
            else
                echo -e "${cyan}├─$d1" | cut -d "/" -f -1
            fi
        done
        echo ""
    done
}

print_main_menu() {  # MAIN MENU LAYOUT
    echo -e "${cyan}┌─────────────────────────────────────────────────────┐"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│          Bienvenido al script de autohost,          │"
    echo -e "${cyan}│                ¿qué quieres hacer?                  │"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│      ${green}[1] Añadir un cliente o dominio${cyan}                │"
    echo -e "${cyan}│      ${red}[2] Eliminar un cliente o dominio${cyan}              │"
    echo -e "${cyan}│      ${white}[3] Listar todos los clientes y dominios${cyan}       │"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}└─────────────────────────────────────────────────────┘"
}

print_add_menu() {  # ADD MENU LAYOUT
    echo -e "${cyan}┌─────────────────────────────────────────────────────┐"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│                ¿Qué quieres ${green}añadir${cyan}?                 │"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│      ${green}[1] Añadir cliente y dominio nuevos${cyan}            │"
    echo -e "${cyan}│      ${green}[2] Añadir dominio para cliente existente${cyan}      │"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}└─────────────────────────────────────────────────────┘"
}

print_del_menu() {  # DELETE MENU LAYOUT
    echo -e "${cyan}┌─────────────────────────────────────────────────────┐"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│               ¿Qué quieres ${red}eliminar${cyan}?                │"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│      ${red}[1] Eliminar cliente y todos sus dominios${cyan}      │"
    echo -e "${cyan}│      ${red}[2] Eliminar dominio de cliente existente${cyan}      │"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}└─────────────────────────────────────────────────────┘"
}

print_useradd_menu() {  # ADDING NEW USER INFORMATION LAYOUT
	usr_gap="${green}${usr}${cyan}"
    pass_gap="${green}${pass}${cyan}"
    dom_gap="${green}${dom}${cyan}"
    while [[ ${#usr_gap} < 48 ]]
    do
        usr_gap="$usr_gap "
    done
    while [[ ${#pass_gap} < 48 ]]
    do
        pass_gap="$pass_gap "
    done
    while [[ ${#dom_gap} < 48 ]]
    do
        dom_gap="$dom_gap "
    done
	echo -e "${cyan}┌─────────────────────────────────────────────────────┐"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│     Estas son las propiedades que has escogido:     │"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│     Usuario:    ${usr_gap}│"
    echo -e "${cyan}│     Contraseña: ${pass_gap}│"
    echo -e "${cyan}│     Dominio:    ${dom_gap}│"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}└─────────────────────────────────────────────────────┘"
}

print_domainadd_menu() {
    usr_gap="${green}${usr}${cyan}"
    dom_gap="${green}${dom}${cyan}"
    while [[ ${#usr_gap} < 48 ]]
    do
        usr_gap="$usr_gap "
    done
    while [[ ${#dom_gap} < 48 ]]
    do
        dom_gap="$dom_gap "
    done
	echo -e "${cyan}┌─────────────────────────────────────────────────────┐"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│     Estas son las propiedades que has escogido:     │"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│     Usuario:    ${usr_gap}│"
    echo -e "${cyan}│     Dominio:    ${dom_gap}│"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}│                                                     │"
    echo -e "${cyan}└─────────────────────────────────────────────────────┘"
}

root_check() {  # ROOT CHECK
    whoami=$(whoami)
    if [[ $whoami != "root" ]]; then 
        echo -e "${red}Necesitas permisos de superusuario para utilizar esta herramienta."
        exit
    fi
}

new_user_iferror() {
    clear
    print_add_menu
    echo -e "${cyan}$1"
    read -rep $'\nNombre del nuevo usuario: ' usr
    cd /var/www/"$usr" > /dev/null 2>&1
    error=$?
}

obtain_new_user_name() {  # OBTAINING USERNAME FOR NEW USER
    read -rep $'\n\nNombre del nuevo usuario: ' usr
    cd /var/www/"$usr" > /dev/null 2>&1
    error=$?
    a=false
    while [ $a = false ]
    do
        if [[ $usr = "" ]]; then
            new_user_iferror "El nombre de usuario no puede estar en blanco."
        elif [ $error -eq 0 ]; then
            new_user_iferror "Ya existe un usuario con ese nombre."
		elif (( ${#usr} > 32 ));then
            new_user_iferror "El nombre de usuario no puede tener más de 32 caracteres."
        elif [[ "$usr" =~ ( |\') ]]; then
            new_user_iferror "El nombre no puede contener espacios."
        else
	        a=true
            cd "$script_path"
        fi
    done
}

existing_user_iferror() {
    clear
    if [[ $main_option = 1 ]]; then
        print_add_menu
    elif [[ $main_option = 2 ]];then
        print_del_menu
    fi
    echo -e "${cyan}$1"
    read -rep $'\nNombre de un usuario ya existente: ' usr
    cd /var/www/"$usr" > /dev/null 2>&1
    error=$?
}

obtain_existing_user_name() {  # OBTAINING USERNAME OF EXISITING USER
    read -rep $'\n\nNombre de un usuario ya existente: ' usr
    cd /var/www/"$usr" > /dev/null 2>&1
    error=$?
    a=false
    while [ $a = false ]
    do
        if [[ $usr = "" ]]; then
            existing_user_iferror "El nombre de usuario no puede estar en blanco."
        elif [[ $error != 0 ]]; then
            existing_user_iferror "No existe ningún usuario con ese nombre."
        else
	        a=true
            cd "$script_path"
        fi
    done
}

password_iferror() {
    clear
    print_add_menu
    echo -e "${cyan}$1"
    read -srp $'\nContraseña del usuario: ' pass
}

obtain_new_password() {  # OBTAINING PASSWORD FOR NEW USER
    read -srp $'\n\nContraseña del usuario: ' pass
    a=false
    while [ $a = false ]
    do
        if [[ $pass = "" ]]; then
            password_iferror "La contraseña no puede estar en blanco."
        elif (( ${#pass} > 32 )); then
                password_iferror "La contraseña no puede tener más de 32 caracteres."
        else
            read -srp $'\nConfirmar contraseña: ' pass_confirm
            if [[ $pass_confirm != $pass ]]; then
                password_iferror "Las contraseñas no coinciden."
            else
                a=true
            fi
        fi
    done
}

domain_iferror() {
    clear
    if [[ $main_option = 1 ]]; then
        print_add_menu
    elif [[ $main_option = 2 ]];then
        print_del_menu
    fi
    echo -e "${cyan}$1"
    read -rep $'\nNombre del dominio: ' dom
    tc=$(echo "$dom" | rev | cut -d "." -f 1)
    atc=$(echo "$dom" | grep -F ".")
    cd /var/www/"$usr"/"$dom" > /dev/null 2>&1
    error=$?
}

obtain_new_domain() {  # OBTAINING DOMAIN NAME FOR NEW DOMAIN
    read -rep $'\n\nNombre del dominio: ' dom
    tc=$(echo "$dom" | rev | cut -d "." -f 1)
    atc=$(echo "$dom" | grep -F ".")
    cd /var/www/"$usr"/"$dom" > /dev/null 2>&1
    error=$?
    a=false
    while [ $a = false ]
    do
        if [[ $dom = "" ]]; then
            domain_iferror "El dominio no puede estar en blanco."
        elif [[ "$dom" =~ ( |\') ]]; then
            domain_iferror "El dominio no puede contener espacios."
        elif (( ${#dom} > 32 )); then
            domain_iferror "El dominio no puede tener más de 32 caracteres."
        elif [[ $tc = "" ]]; then
            domain_iferror "Debes escribir una extensión válida."
        elif [[ $atc = "" ]]; then
            domain_iferror "Debes escribir también la extensión del dominio."
        elif [ $error -eq 0 ]; then
            domain_iferror "Ya existe un dominio con ese nombre."
        elif (( ${#tc} > 3 ));then
            domain_iferror "La extensión no puede tener más de 3 caracteres."
        else
            dom=$(echo $dom | tr '[:upper:]' '[:lower:]')
            a=true
            cd "$script_path"
        fi
    done
}

obtain_existing_domain() {
    read -rep $'\n\nNombre del dominio: ' dom
    cd /var/www/"$usr"/"$dom" > /dev/null 2>&1
    error=$?
    a=false
    while [ $a = false ]
    do
        if [[ $error != 0 ]]; then
            domain_iferror "No existe ese dominio."
        else
            a=true
            cd "$script_path"
        fi
    done    
}

create_user_directory() { 
    mkdir /var/www/"$usr" > /dev/null 2>&1 &
    process=$!
    spinner "Creando directorio de usuario" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido crear el directorio del usuario${reset}"
        exit
    fi
    echo -e "${green}[+]  Directorio de usuario creado        "
}

create_domain_directory() {
    mkdir /var/www/"$usr"/"$dom" > /dev/null 2>&1 &
    process=$!
    spinner "Creando directorio de dominio" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido crear el directorio del dominio${reset}"
        exit
    fi
    echo -e "${green}[+]  Directorio de dominio creado        "
}

create_user() {
    useradd "$usr" -g clientes -d /var/www/"$usr"/ > /dev/null 2>&1 &
    process=$!
    spinner "Creando nuevo usuario" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido crear el usuario${reset}"
        exit
    fi
    echo -e "${green}[+]  Usuario ${usr} creado        "
}

change_permissions() {
    chmod -R 755 /var/www/"$usr"/"$dom" > /dev/null 2>&1 &
    process=$!
    spinner "Cambiando permisos de los directorios" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se han podido cambiar los permisos de los directorio${reset}"
        exit
    fi
    echo -e "${green}[+]  Se han cambiado los permisos de los directorios        "
}

change_owner() {
    chown "$usr":clientes /var/www/"$usr"/"$dom" > /dev/null 2>&1 &
    process=$!
    spinner "Cambiando el propietario de los directorios" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido cambiar el propietario de los directorio${reset}"
        exit
    fi
    echo -e "${green}[+]  Se ha cambiado el propietario de los directorios        "
}

create_configuration_file() {
    DUSER=$usr
    DOMAIN=$dom
    export DUSER DOMAIN
    cat autohosting-template.conf | envsubst >> /etc/apache2/sites-available/"$usr-$dom.conf" 2>/dev/null &  # Create configuration file
    process=$!
    spinner "Creando archivo de configuración" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido crear el archivo de configuración del sitio${reset}"
        exit
    fi
    echo -e "${green}[+]  Se ha creado el archivo de configuración del sitio        "
}

activate_domain() {
    a2ensite "$usr-$dom.conf" > /dev/null 2>&1 &  # Activate domain
    process=$!
    spinner "Activando dominio" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido activar el dominio${reset}"
        exit
    fi
    echo -e "${green}[+]  El dominio ha sido activado        "
}

restart_apache() {
    systemctl restart apache2 > /dev/null 2>&1 &  # Restart apache service
    process=$!
    spinner "Reiniciando apache" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido reiniciar apache${reset}"
        exit
    fi
    echo -e "${green}[+]  Apache se ha reiniciado correctamente        "    
}

create_main_html() {
    echo "<h1>Bienvenido a tu nuevo sitio web, $usr</h1>" >> /var/www/"$usr"/"$dom"/index.html 2>/dev/null  # Creating index.html
    echo "<p>Puedes conectarte por sftp usando hostname $dom, nombre de usuario $usr</p>" >> /var/www/"$usr"/"$dom"/index.html 2>/dev/null  # Appending to index.html
    chown "$usr":clientes /var/www/"$usr"/"$dom"/index.html > /dev/null 2>&1 &  # Change owner
    process=$!
    spinner "Creando página inicial" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido crear la página inicial${reset}"
        exit
    fi
    echo -e "${green}[+]  Se ha creado la página inicial"
}

add_domain_to_windows_server() {
    DOMAIN=$dom
    export DOMAIN
    cat ahdns-template.ps1 | envsubst >> "temp-ahdns.ps1" 2>/dev/null &  # Create .ps1 script
    process=$!
    spinner "Creando script de configuración DNS" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido crear el script de configuración DNS${reset}"
        exit
    fi
    echo -e "${green}[+]  Se ha creado el script de configuración DNS        "
    sshpass -p 'Alumnat123!' scp "temp-ahdns.ps1" Administrador@192.168.6.5:/C:/ahconf > /dev/null 2>&1 &  # Copy script to Windows Server
    process=$!
    spinner "Creando script de configuración DNS" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido crear el script de configuración DNS${reset}"
        exit
    fi
    echo -e "${green}[+]  Se ha creado el script de configuración DNS        "
    rm "temp-ahdns.ps1" > /dev/null 2>&1 &  # Delete .ps1 temporary file
    process=$!
    spinner "Eliminando el script temporal" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido eliminar el script temporal temp-ahdns.ps1${reset}"
        exit
    fi
    echo -e "${green}[+]  Se ha eliminado el script temporal        "
    sshpass -p 'Alumnat123!' ssh Administrador@192.168.6.5 powershell "C:\ahconf\temp-ahdns.ps1" > /dev/null 2>&1 &  # Running script on Windows Server
    process=$!
    spinner "Ejecutando script en Windows Server" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido ejecutar el script en Windows Server${reset}"
        exit
    fi
    echo -e "${green}[+]  Se ha ejecutado el script en Windows Server        "
    sshpass -p 'Alumnat123!' ssh Administrador@192.168.6.5 del "C:\ahconf\temp-ahdns.ps1" > /dev/null 2>&1 &  # Delete script on Windows Server
    process=$!
    spinner "Eliminando script en Windows Server" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido eliminar el script en Windows Server${reset}"
        exit
    fi
    echo -e "${green}[+]  Se ha eliminado el script en Windows Server        "
}

delete_every_domain() {
    cd /var/www/"$usr"/ || exit > /dev/null 2>&1
    for a in */
    do
        a=$(echo "$a" | cut -d "/" -f -1)
        if ! rm /etc/apache2/sites-available/"$usr"-"$a".conf 2>&1; then
            echo "${red}ERROR FATAL, INICIANDO SECUENCIA DE AUTODESTRUCCIÓN $a"
            exit
        fi
        DOMAINS=$(echo -e "$DOMAINS,'$a'")
    done
        export DOMAINS
    if ! cat < /sftp/ahdns-fh-template.ps1 | envsubst '$DOMAINS' >> ahdns-forhost.ps1; then
        echo "${red}ERROR FATAL, INICIANDO SECUENCIA DE AUTODESTRUCCIÓN"
        exit
    fi
    sshpass -p 'Alumnat123!' scp "ahdns-forhost.ps1" Administrador@192.168.6.5:/C:/ahconf > /dev/null 2>&1 &
    process=$!
    spinner "Enviando script a máquina de Windows Server" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido enviar el script${reset}"
        exit
    fi
    echo -e "${green}[+]  El script se ha enviado correctamente        "
    rm "ahdns-forhost.ps1" > /dev/null 2>&1 &
    process=$!
    spinner "Eliminando script temporal" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido eliminar el script temporal${reset}"
        exit
    fi
    echo -e "${green}[+]  El script temporal se ha eliminado correctamente        "
    sshpass -p 'Alumnat123!' ssh Administrador@192.168.6.5 powershell "C:\ahconf\ahdns-forhost.ps1" > /dev/null 2>&1 &
    process=$!
    spinner "Ejecutando script" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido ejecutar el script${reset}"
        exit
    fi
    echo -e "${green}[+]  El script se ha ejecutado correctamente        "
    sshpass -p 'Alumnat123!' ssh Administrador@192.168.6.5 del "C:\ahconf\ahdns-forhost.ps1" > /dev/null 2>&1 &
    process=$!
    spinner "Eliminando script temporal en Windows Server" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido eliminar el script temporal ubicado en Windows Server${reset}"
        exit
    fi
    echo -e "${green}[+]  El script temporal ubicado en Windows Server se ha eliminado correctamente        "
}

delete_user_directory() {
    rm -r /var/www/"$usr" > /dev/null 2>&1 &
    process=$!
    spinner "Eliminando directorios del usuario" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se han podido eliminar los directorios del usuario${reset}"
        exit
    fi
    echo -e "${green}[+]  Los directorios del usuario se han eliminado correctamente        "
}

delete_user() {
    userdel "$usr" > /dev/null 2>&1 &
    process=$!
    spinner "Eliminando usuario" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido eliminar el usuario${reset}"
        exit
    fi
    echo -e "${green}[+]  El usuario se ha eliminado correctamente        "
}

delete_domain_in_windows_server() {
    DOMAINS=$(echo -e "\"$dom\"")
    export DOMAINS
    cat < ahdns-fh-template.ps1 | envsubst '$DOMAINS' >> ahdns-forhost.ps1
    rm /etc/apache2/sites-available/"$usr"-"$dom".conf
    sshpass -p 'Alumnat123!' scp "ahdns-forhost.ps1" Administrador@192.168.6.5:/C:/ahconf > /dev/null 2>&1 &
    process=$!
    spinner "Enviando script a máquina de Windows Server" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido enviar el script${reset}"
        exit
    fi
    echo -e "${green}[+]  El script se ha enviado correctamente        "
    rm "ahdns-forhost.ps1" > /dev/null 2>&1 &
    process=$!
    spinner "Eliminando script temporal" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido eliminar el script temporal${reset}"
        exit
    fi
    echo -e "${green}[+]  El script temporal se ha eliminado correctamente        "
    sshpass -p 'Alumnat123!' ssh Administrador@192.168.6.5 powershell "C:\ahconf\ahdns-forhost.ps1" > /dev/null 2>&1 &
    process=$!
    spinner "Ejecutando script" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido ejecutar el script${reset}"
        exit
    fi
    echo -e "${green}[+]  El script se ha ejecutado correctamente        "
    sshpass -p 'Alumnat123!' ssh Administrador@192.168.6.5 del "C:\ahconf\ahdns-forhost.ps1" > /dev/null 2>&1 &
    process=$!
    spinner "Eliminando script temporal en Windows Server" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido eliminar el script temporal ubicado en Windows Server${reset}"
        exit
    fi
    echo -e "${green}[+]  El script temporal ubicado en Windows Server se ha eliminado correctamente        "
}

delete_domain() {
    rm -r /var/www/"$usr"/"$dom" > /dev/null 2>&1 &
    process=$!
    spinner "Eliminando dominio" $process
    wait "$process"; error=$?
    if [ $error != 0 ]; then
        echo -e "${red}[x]  No se ha podido eliminar el dominio${reset}"
        exit
    fi
    echo -e "${green}[+]  El dominio se ha eliminado correctamente        "
}

add_user_and_domain() {  # CREATE NEW USER, PASSWORD AND DOMAIN
    clear
    print_add_menu
    obtain_new_user_name
    clear
    print_add_menu
    obtain_new_password
    clear
    print_add_menu
    obtain_new_domain
    clear
    print_useradd_menu
    read -rep $'\n\nEstás de acuerdo? (S/N): ' confirm
    confirm=$(echo $confirm | tr '[:upper:]' '[:lower:]')
    a=false
    while [ $a = false ]
    do
        if [ "$confirm" != "s" ] && [ "$confirm" != "n" ]; then
            clear
            print_useradd_menu
            echo -e $'\nTienes que escribir "S" (sí) o "N" (no)'
            read -rep $'Estás de acuerdo? (S/N): ' confirm
            confirm=$(echo $confirm | tr '[:upper:]' '[:lower:]')
        else
            a=true
        fi
    done
    if [[ "$confirm" != "s" ]]; then
        echo -e "${reset}"
        exit
    fi
    clear
    print_useradd_menu
    echo ""
    create_user_directory
    create_domain_directory
    create_user
    change_permissions
    change_owner
    create_configuration_file
    activate_domain
    restart_apache
    create_main_html
    add_domain_to_windows_server
}

add_domain_for_existing_user() {  # CREATE NEW DOMAIN FOR EXISTING USER
    clear
    print_add_menu
    obtain_existing_user_name
    clear
    print_add_menu
    obtain_new_domain
    clear
    print_domainadd_menu
    read -rep $'\n\nEstás de acuerdo? (S/N): ' confirm
    confirm=$(echo $confirm | tr '[:upper:]' '[:lower:]')
    a=false
    while [ $a = false ]
    do
        if [ "$confirm" != "s" ] && [ "$confirm" != "n" ]; then
            clear
            print_useradd_menu
            echo -e $'\nTienes que escribir "S" (sí) o "N" (no)'
            read -rep $'Estás de acuerdo? (S/N): ' confirm
            confirm=$(echo $confirm | tr '[:upper:]' '[:lower:]')
        else
            a=true
        fi
    done
    if [[ "$confirm" != "s" ]]; then
        echo -e "${reset}"
        exit
    fi
    clear
    print_domainadd_menu
    echo ""
    create_domain_directory
    change_permissions
    change_owner
    create_configuration_file
    activate_domain
    restart_apache
    create_main_html
    add_domain_to_windows_server
}

del_user_and_domains() {  # DELETE A USER AND ALL OF HIS DOMAINS
    clear
    print_del_menu
    obtain_existing_user_name
    clear
    print_del_menu
    echo -e "\nVas a eliminar al usuario ${usr} y todos sus dominios"
    read -rep $'Estás de acuerdo? (S/N): ' confirm
    confirm=$(echo $confirm | tr '[:upper:]' '[:lower:]')
    a=false
    while [ $a = false ]
    do
        if [ "$confirm" != "s" ] && [ "$confirm" != "n" ]; then
            clear
            print_del_menu
            echo -e $'Tienes que escribir "S" (sí) o "N" (no)'
            echo -e "Vas a eliminar al usuario ${usr} y todos sus dominios"
            read -rep $'Estás de acuerdo? (S/N): ' confirm
            confirm=$(echo $confirm | tr '[:upper:]' '[:lower:]')
        else
            a=true
        fi
    done
    if [[ "$confirm" != "s" ]]; then
        echo -e "${reset}"
        exit
    fi
    clear
    print_del_menu
    echo ""
    delete_every_domain
    delete_user_directory
    delete_user
}

del_domain_of_user() {  # DELETE A DOMAIN OF A CERTAIN USER
    clear
    print_del_menu
    obtain_existing_user_name
    obtain_existing_domain
    clear
    print_del_menu
    echo -e "\nVas a eliminar el dominio ${dom}, que pertenece al usuario ${usr}"
    read -rep $'Estás de acuerdo? (S/N): ' confirm
    confirm=$(echo $confirm | tr '[:upper:]' '[:lower:]')
    a=false
    while [ $a = false ]
    do
        if [ "$confirm" != "s" ] && [ "$confirm" != "n" ]; then
            clear
            print_del_menu
            echo -e $'Tienes que escribir "S" (sí) o "N" (no)'
            echo -e "\nVas a eliminar el dominio ${dom}, que pertenece al usuario ${usr}"
            read -rep $'Estás de acuerdo? (S/N): ' confirm
            confirm=$(echo $confirm | tr '[:upper:]' '[:lower:]')
        else
            a=true
        fi
    done
    if [[ "$confirm" != "s" ]]; then
        echo -e "${reset}"
        exit
    fi
    clear
    print_del_menu
    echo ""
    delete_domain_in_windows_server
    delete_domain
        
}

main_menu() {  # MAIN MENU CODE
    print_main_menu
    read -rep $'\n\n> ' main_option
    a=false
    while [ $a = false ]
    do
        if [[ $main_option != 1 ]] && [[ $main_option != 2 ]] && [[ $main_option != 3 ]]; then
            clear
            print_main_menu
            echo -e "${cyan}Debes escribir ${green}1${cyan}, ${red}2${cyan} o ${white}3${cyan}."
            read -rep $'\n> ' main_option
        else
            a=true
        fi
    done
}

add_menu() {  # ADD MENU CODE
    print_add_menu
    read -rep $'\n\n> ' option
    a=false
    while [ $a = false ]
    do
        if [ $option != 1 ] && [ $option != 2 ]; then
            clear
            print_add_menu
            echo -e "${cyan}Debes escribir ${green}1${cyan} o ${green}2${cyan}."
            read -rep $'\n> ' option
        else
            a=true
        fi
    done
    if [[ $option = 1 ]]; then
        add_user_and_domain
    else
        add_domain_for_existing_user
    fi
}

del_menu() {  # DEL MENU CODE
    print_del_menu
    read -rep $'\n\n> ' option
    a=false
    while [ $a = false ]
    do
        if [ $option != 1 ] && [ $option != 2 ]; then
            clear
            print_del_menu
            echo -e "${cyan}Debes escribir ${red}1${cyan} o ${red}2${cyan}."
            read -rep $'\n> ' option
        else
            a=true
        fi
    done
    if [[ $option = 1 ]]; then
        del_user_and_domains
    elif [[ $option = 2 ]]; then
        del_domain_of_user
    fi
}

clear
script_path=$(pwd)
root_check
main_menu
if [ $main_option = 1 ]; then
    clear
    add_menu
elif [ $main_option = 2 ]; then
    clear
    del_menu
elif [ $main_option = 3 ]; then
    clear
    print_main_menu
    echo -e "\n"
    list_allhosts
fi
echo -e "${reset}"