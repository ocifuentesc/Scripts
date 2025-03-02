#!/bin/bash

##
##
## ░█████╗░░█████╗░██╗███████╗██╗░░░██╗███████╗███╗░░██╗████████╗███████╗░██████╗░█████╗░
## ██╔══██╗██╔══██╗██║██╔════╝██║░░░██║██╔════╝████╗░██║╚══██╔══╝██╔════╝██╔════╝██╔══██╗
## ██║░░██║██║░░╚═╝██║█████╗░░██║░░░██║█████╗░░██╔██╗██║░░░██║░░░█████╗░░╚█████╗░██║░░╚═╝
## ██║░░██║██║░░██╗██║██╔══╝░░██║░░░██║██╔══╝░░██║╚████║░░░██║░░░██╔══╝░░░╚═══██╗██║░░██╗
## ╚█████╔╝╚█████╔╝██║██║░░░░░╚██████╔╝███████╗██║░╚███║░░░██║░░░███████╗██████╔╝╚█████╔╝
## ░╚════╝░░╚════╝░╚═╝╚═╝░░░░░░╚═════╝░╚══════╝╚═╝░░╚══╝░░░╚═╝░░░╚══════╝╚═════╝░░╚════╝░
##
##
## @author	Oscar Cifuentes Cisterna
## @copyright	Copyright © 2025 Oscar Cifuentes Cisterna
## @license	https://wwww.gnu.org/licenses/gpl.txt
## @email	oscar@ocifuentesc.cl
## @web		https://oscarcifuentes.cl
## @github	https://github.com/ocifuentesc
##
##

###################################
## Sistemas Operativos Testeados ##
###################################

# - MacOS 15.0 M1
# - Kali Linux 2024 ARM64
# - Debian 10 ARM64
# - Debian 11 ARM64
# - Debian 12 ARM64
# - Ubuntu Server 20.04 ARM64
# - Ubuntu Server 24.04 ARM64
# - CentOS 9 Stream ARM64
# - CentOS 10 Stream ARM64
# - Alma Linux 9.4 ARM
# - Fedora Server 39 ARM
# - Fedora Server 40 ARM
# - Fedora Workstation 38 ARM
# - Fedora Workstation 40 ARM
# - Rocky Linux 9.4 ARM
# - ArchLinux ARM

# Colores
VERDE="\033[1;32m"
ROJO="\033[1;31m"
NEGRITA="\033[1;39m"
SUBRAYADO="\033[4m"
RESET="\033[0m"

# Verificación de permisos de superusuario
if [[ $EUID -ne 0 ]]; then
    echo -e "${ROJO}Este script requiere permisos de superusuario.${RESET}" >&2
    exit 1
fi

# Menú principal
show_menu() {
    clear
    echo
    echo -e "${VERDE}======================================"
    echo -e "|           MENU PRINCIPAL           |"
    echo -e "======================================"
	echo -e
    echo -e " 1.  PING a una IP o Dominio"
    echo -e " 2.  NSLOOKUP a una IP o Dominio"
    echo -e " 3.  TRACERT a una IP o Dominio"
    echo -e " 4.  Información del equipo"
    echo -e " 5.  Listar procesos activos"
    echo -e " 6.  Ver Usuarios del Sistema"
    echo -e " 7.  Ver cache ARP"
    echo -e " 8.  Mostrar las conexiones activas"
    echo -e " 9.  Actualizar Sistema"
    echo -e "10.  Borrar caché DNS y Temporales"
	echo -e "11.  Revisar Certificado SSL"
	echo -e
    echo -e " 0.  Salir"
	echo -e
    echo -e "======================================${RESET}"
	echo
    read -p $'\e[1;32mIngrese una opción (0-11): \e[0m' opcion
}

# Función para detectar el sistema operativo
detect_os() {
    case "$(uname -s)" in
        Linux*)   
            if [ -f /etc/os-release ]; then
                # Extraer el nombre de la distribución desde os-release
                OS="$(. /etc/os-release && echo "$NAME")"
            elif [ -f /etc/redhat-release ]; then
                OS="$(cat /etc/redhat-release)"
            elif [ -f /etc/lsb-release ]; then
                OS="$(. /etc/lsb-release && echo "$DISTRIB_ID")"
            else
                OS="Linux (Desconocido)"
            fi
            ;;
        Darwin*)  OS="macOS" ;;
        *)        OS="Desconocido" ;;
    esac
}

# Barra de progreso optimizada
show_progress() {
    local delay=0.1
    local spin='|/-\'
    while true; do
        for ((i=0; i<${#spin}; i++)); do
            echo -en "${spin:$i:1} \r"
            sleep $delay
        done
    done
}


# Función para verificar dependencias
check_dependency() {
    if ! command -v "$1" &>/dev/null; then
        echo -e "${ROJO}Error: '$1' no está instalado.${RESET}" >&2
        exit 1
    fi
}

# Función para manejar la opción 1 - PING a una IP o Dominio
ping_option() {
    clear
    echo
    read -p $'\e[1;32mIngrese dirección IP o Dominio: \e[0m' ping_target
    echo

    check_dependency ping
    show_progress &
    spinner_pid=$!
   if ping -c 3 "$ping_target" &>/dev/null; then
        kill "$spinner_pid" 2>/dev/null
        echo -e "${VERDE}Respuesta recibida desde $ping_target${RESET}"
    else
        kill "$spinner_pid" 2>/dev/null
        echo -e "${ROJO}No se recibió respuesta desde $ping_target${RESET}"
    fi
    echo
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

# Función para manejar la opción 2 - NSLOOKUP a una IP o Dominio
nslookup_option() {
    clear
    echo
    read -p $'\e[1;32mIngrese dirección IP o Dominio: \e[0m' nslookup_target
    echo
    check_dependency nslookup
    nslookup $nslookup_target
    echo
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

# Función para manejar la opción 3 - TRACERT a una IP o Dominio
tracert_option() {  
    clear
    echo
    read -p $'\e[1;32mIngrese dirección IP o Dominio: \e[0m' traceroute_target
    echo
    check_dependency traceroute
    traceroute $traceroute_target
    echo
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

# Función para manejar la opción 4 - Información del equipo
info_option() {
   	clear
	echo
	detect_os
    	echo -e "${VERDE}Sistema identificado como $OS${RESET}"
	echo
   	sleep 2
	clear
    case $OS in
            *Debian* | *Ubuntu* | *Kali* | *CentOS* | *Fedora* | *AlmaLinux* | *Rocky* | *Arch*)
            echo -e "${VERDE}=================================="
            echo -e "|     INFORMACIÓN DEL EQUIPO     |"
            echo -e "==================================${RESET}"
            echo
            uname -a
            echo
            cat /etc/os-release | grep -Ev "HOME_URL|SUPPORT_URL|BUG_REPORT_URL"
            echo
            echo -e "${VERDE}======================"
            echo -e "| INFORMACIÓN DE RED |"
            echo -e "======================${RESET}"
            echo
            command -v ip >/dev/null && ip -c a || echo "Comando 'ip' no disponible"
            echo
            echo -e "${VERDE}==========="
            echo -e "| MEMORIA |"
            echo -e "===========${RESET}"
            echo
            command -v free >/dev/null && free -mth || echo "Comando 'free' no disponible"
            echo
            ;;
        *MacOS*)
            echo -e "${VERDE}=================================="
            echo -e "|     INFORMACIÓN DEL EQUIPO     |"
            echo -e "==================================${RESET}"
            echo
            system_profiler SPHardwareDataType
            echo
            scutil --get HostName
            echo
            echo -e "${VERDE}======================"
            echo -e "| INFORMACIÓN DE RED |"
            echo -e "======================${RESET}"
            echo
            command -v scutil >/dev/null && scutil --nwi || echo "Comando 'scutil' no disponible"
            echo
            echo -e "${VERDE}==========="
            echo -e "| MEMORIA |"
            echo -e "===========${RESET}"
            echo
            command -v sysctl >/dev/null && sysctl hw.memsize || echo "Comando 'sysctl' no disponible"
            echo
            command -v top >/dev/null && top -l 1 | grep PhysMem || echo "Comando 'top' no disponible"
            echo
            ;;
        *)
            clear
            echo
            echo -e "${ROJO}Error: Arquitectura del Sistema Operativo NO soportada${RESET}"
            echo
            ;;
    esac
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

# Función para manejar la opción 5 - Listar procesos activos
processes_option() {
    clear
    echo
    ps aux
    echo
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

# Función para manejar la opción 6 - Ver Usuarios del Sistema
users_option() {
    clear
	echo
	detect_os
    echo -e "${VERDE}Sistema identificado como $OS${RESET}"
	echo
    sleep 2
	clear
    case $OS in
	#
	# Derivados de Debian y Red Hat
	#
	*Debian* | *Ubuntu* | *Kali* | *CentOS*| *Fedora* | *lmaLinux* | *Rocky* | *rch*)
        echo
        echo -e "${VERDE}============"
        echo -e "| USUARIOS |"
        echo -e "============${RESET}"
        echo
        awk -F: '{ print $1}' /etc/passwd
        echo
        ;;
	#
	# MacOS
	#
	*darwin*)
        echo
        echo -e "${VERDE}============"
        echo -e "| USUARIOS |"
        echo -e "============${RESET}"
        echo
        dscl . list /Users | grep -v '_'
        echo
        ;;
	#
	# Otros
	#
	(*)
        echo -e "${ROJO}Error: Arquitectura del Sistema Operativo NO soportada${RESET}"
        echo
        ;;
esac
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

# Función para manejar la opción 7 - Ver cache ARP
arp_cache_option() {
    clear
	echo
	detect_os
    echo -e "${VERDE}Sistema identificado como $OS${RESET}"
	echo
    sleep 2
	clear
    case $OS in
	#
	# Derivados de Debian y Red Hat
	#
	*Debian* | *Ubuntu* | *Kali* | *CentOS*| *Fedora* | *lmaLinux* | *Rocky* | *rch*)
        echo
        echo -e "${VERDE}==============="
        echo -e "|  TABLA ARP  |"
        echo -e "===============${RESET}"
        echo
        sudo arp -a
        echo
        ;;
	#
	# MacOS
	#
	*darwin*)
        echo
        echo -e "${VERDE}==============="
        echo -e "|  TABLA ARP  |"
        echo -e "===============${RESET}"
        echo
        sudo arp -a
        echo
        ;;
	#
	# Otros
	#
	(*)
    	echo -e "${ROJO}Error: Arquitectura del Sistema Operativo NO soportada${RESET}"
	    echo
	    ;;
esac
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

# Función para manejar la opción 8 - Mostrar las conexiones activas
connections_option() {
    check_dependency ss
    clear
    echo
    echo -e "${VERDE}Sistema identificado como $OS${RESET}"
	echo
    sleep 2
	clear
    case $OS in
	#
	# Derivados de Debian y Red Hat
	#
	*Debian* | *Ubuntu* | *Kali* | *CentOS*| *Fedora* | *lmaLinux* | *Rocky* | *rch*)
        echo
        echo -e "${VERDE}================"
        echo -e "|  CONEXIONES  |"
        echo -e "================${RESET}"
        echo
        ss -tuln
        echo
        ;;
	#
	# MacOS
	#
	*darwin*)
        echo
        echo -e "${VERDE}================"
        echo -e "|  CONEXIONES  |"
        echo -e "================${RESET}"
        echo
        netstat -an
        echo
        ;;
	#
	# Otros
	#
	(*)
        echo -e "${ROJO}Error: Arquitectura del Sistema Operativo NO soportada${RESET}"
    	echo
	    ;;
esac
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

# Función para manejar la opción 9 - Actualizar Sistema
update_option() {
    clear
	echo
    echo -e "${VERDE}Sistema identificado como $OS${RESET}"
	echo
    sleep 2
	clear
    case $OS in
    # Arch Linux
	*rch*)
        echo -e "${VERDE}Actualizando Sistema...${RESET}"
        echo
        sudo pacman -Syyu
        echo
        echo -e "${VERDE}Sistema Actualizado${RESET}"
        echo
        ;;
	# Derivados de Debian
    *Debian* | *Ubuntu* | *Kali*)
        echo -e "${VERDE}Descargando Lista de Repositorios..."
        echo
        sudo apt update -y
        echo
        echo -e "${VERDE}Actualizando Sistema..."
        echo
        sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt full-upgrade -y
        echo
        echo -e "${VERDE}Limpiando..."
        echo
        sudo apt autoremove -y && sudo apt autoclean
        echo
        echo -e "${VERDE}Sistema Actualizado"
        echo
        ;;
    # Derivados de Red Hat
    *CentOS*| *Fedora* | *lmaLinux* | *Rocky*)
        echo -e "${VERDE}Descargando Lista de Repositorios..."
        echo
        sudo dnf update -y
        echo
        echo -e "${VERDE}Actualizando Sistema...${RESET}"
        echo
        sudo dnf upgrade -y
        echo
        echo "Limpiando..."
        echo
        sudo dnf clean all
        echo
        echo "Sistema Actualizado"
        echo
        ;;
	# MacOS
	*darwin*)
        echo -e "${VERDE}Actualizando Sistema...${RESET}"
        echo
        softwareupdate --all --install --force
        echo
        ;;
	# Otros
	(*)
        echo -e "${ROJO}Error: Arquitectura del Sistema Operativo NO soportada${RESET}"
        echo
	;;
	esac
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

# Función para manejar la opción 10 - Borrar caché DNS y Temporales
deldns_option() {
    clear
	echo
	detect_os
    echo -e "${VERDE}Sistema identificado como $OS${RESET}"
	echo
    sleep 2
	clear
    case $OS in
        *Debian*|*Ubuntu*) sudo apt clean && sudo apt autoremove --purge ;;
        *Fedora*|*CentOS*) sudo dnf clean all ;;
        *Arch*) sudo pacman -Qdtq | sudo pacman -Rns - ;;
        *MacOS*) sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder ;;
    esac
    echo
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

## Función para manejar la opción 11 - Revisar Certificado SSL
certssl_option() {
	clear
    check_dependency openssl
    PROTOCOLS="https://|ldaps://|smtps://"
	TMPDIR="/tmp/uli-war-da.$$"
	cleanUp () {
	    rm -rf "${TMPDIR}"
	}
	trap cleanUp 0 1 2 3 4 5 6 7 8 9 10 12 13 14 15
	TMPDIR="$(mktemp -d)"
	while true; do
		# Solicitar IP o dominio si no se pasa como argumento
		if [ $# -eq 0 ]; then
		    echo -e "${VERDE}  MODO DE USO"
			echo " -------------"
			echo
	    	echo "  example.com               		# Verificar un dominio en el puerto 443 (HTTPS)"
			echo "  https://example.com       		# Verificar usando protocolo https en el puerto 443"
			echo "  https://example.com:8080  		# Verificar usando protocolo https en el puerto 8080"
			echo
			echo "  sub.example.com           		# Verificar un subdominio en el puerto 443"
			echo "  https://sub.example.com       	# Verificar un subdominio https en el puerto 443"
			echo "  https://sub.example.com:8080  	# Verificar un subdominio https en el puerto 8080"
			echo
	    	echo "  192.168.1.1               		# Verificar una dirección IP en el puerto 443 (HTTPS)"
	    	echo "  https://192.168.1.1       		# Verificar una dirección IP en el puerto 443"
	    	echo -e "  https://192.168.1.1:8080  		# Verificar una dirección IP en el puerto 8080 (HTTPS)${RESET}"
			echo 
	        read -p $'\e[1;32mIntroduce la IP o dominio a verificar (M para volver al Menú Principal): \e[0m' H
			echo

			# Si el usuario ingresa 'M', salir de la función y volver al menú
			[[ "$H" == "M" ]] && return

			# Validar entrada (IP o dominio)
			if ! [[ "$H" =~ ^(https://|ldaps://|smtps://)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,}|[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)(:[0-9]+)?$ ]]; then
				echo -e "\e[1;31mOpción no válida. Inténtelo de nuevo.\e[0m"
				sleep 2
				clear
				continue
			fi
		else
		    H="$1"
		fi

		break
	done

	PR="https://"
	PO=":443"
	URL="$(echo "${H}"|grep -oE "(${PROTOCOLS})?[^:/]*(:[0-9]*)?"|head -1)"
	HPR="$(echo "${URL}"|grep -oE "${PROTOCOLS}")"
	HPO="$(echo "${URL}"|grep -oE ":[0-9]+")"
	HO="${URL}"

	if [ -n "${HPR}" ]; then
	    HO="$(echo "${HO}"|sed -e "s,${HPR},,")"
	fi
	if [ -n "${HPO}" ]; then
	    HO="$(echo "${HO}"|sed -e "s,${HPO},,")"
	    PO="${HPO}"
	else
	    case "${HPR}" in
	      "https://")
	        PO=":443"
	        ;;
	      "ldaps://")
	        PO=":636"
	        ;;
	      "smtps://")
	        PO=":587"
	        ;;
	    esac
	fi

	openssl </dev/zero s_client 2>/dev/null -connect "${HO}${PO}" -servername "${HO}"\
	|openssl x509 -text >"${TMPDIR}/x509_text"

	< "${TMPDIR}/x509_text" grep -E "^\s*(Subject:|Issuer:|Not |DNS:)"\
	|sed -e "s/^\s*//" -e 's/^\([^:]*\):/\1\t/' -e "s/DNS://g" -e "s/^/${HO}${PO}\t/"

	echo -e "${HO}${PO}\tMD5\t$(<"${TMPDIR}/x509_text" openssl x509 -noout -modulus|openssl md5|sed -e "s/^[^ ]* //")"

	cleanUp
	echo
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
    return
}

# Bucle del menú
while true; do
    show_menu
    case $opcion in
        1) ping_option ;;
        2) nslookup_option ;;
        3) tracert_option ;;
        4) info_option ;;
        5) processes_option ;;
        6) users_option ;;
        7) arp_cache_option ;;
        8) connections_option ;;
        9) update_option ;;
        10) deldns_option ;;
		11) certssl_option ;;
        0) exit 0 ;;
        *)
            echo
            echo -e "\e[1;31mOpción no válida. Inténtelo de nuevo.\e[0m"
			echo
            read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
            ;;
    esac
done
