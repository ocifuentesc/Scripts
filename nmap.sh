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
#
# - MacOS 15.0 M1 
# - Kali Linux 2024 ARM64
# - Debian 12 ARM64

# Colores
VERDE="\033[1;32m"
NEGRITA="\033[1;39m"
SUBRAYADO="\033[4m"
RESET="\033[0m"

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

nmap_option() {
        clear
		echo
        echo -e "${VERDE}=============================================================="
        echo -e "|                           MENU NMAP                        |"
        echo -e "==============================================================${RESET}"
        echo
        echo -e "${VERDE}  1. Barrido de Ping (-sn)${RESET}"
        echo -e "${NEGRITA}     ${SUBRAYADO}Nota:${RESET}${NEGRITA} Identificar hosts activos en la red. No hace análisis de puertos posterior${RESET}"
        echo
        echo -e "${VERDE}  2. No Ping (-Pn)${RESET}"
        echo -e "${NEGRITA}     ${SUBRAYADO}Nota:${RESET}${NEGRITA} Pasa directo al escaneo de puertos${RESET}"
        echo
        echo -e "${VERDE}  3. Solo lista equipos (-sL)${RESET}"
        echo -e "${NEGRITA}     ${SUBRAYADO}Nota:${RESET}${NEGRITA} Lista equipos y con resolucion inversa DNS${RESET}"
        echo
        echo -e "${VERDE}  4. Ping ICMP (-PP)${RESET}"
        echo -e "${NEGRITA}     ${SUBRAYADO}Nota:${RESET}${NEGRITA} Identificar hosts activos en la red mediante un ICMP Timestamp Request${RESET}"
        echo
        echo -e "${VERDE}  5. Escanear puerto y deteccion de version y sistema operativo (-O -sV -p)${RESET}"
        echo -e "${NEGRITA}     ${SUBRAYADO}Nota:${RESET}${NEGRITA} Escaneo de un simple puerto o un rango de ellos."
        echo -e "     Detecta la version de los puertos e identifica el sistema operativo.${RESET}"
        echo
        echo -e "${VERDE}  6. Escaneo TCP (-sT)(*)${RESET}"
        echo -e "${NEGRITA}     ${SUBRAYADO}Nota:${RESET}${NEGRITA} Determinar el estado de un puerto (abierto, cerrado o filtrado).${RESET}"
        echo
        echo -e "${VERDE}  7. Escaneo SYN (-sS)(*)${RESET}"
        echo -e "${NEGRITA}     ${SUBRAYADO}Nota:${RESET}${NEGRITA} Escaneo sigiloso y mas rapido que el TCP${RESET}"
        echo
        echo -e "${VERDE}  8. Escaneo UDP Rapido (-sU -F) (*)${RESET}"
        echo -e "${NEGRITA}     ${SUBRAYADO}Nota:${RESET}${NEGRITA} Se escanea los primeros 100 puertos.${RESET}"
        echo
        echo -e "${VERDE}  9. Escaneo UDP (-sU) (*)${RESET}"
        echo -e "${NEGRITA}     ${SUBRAYADO}Nota:${RESET}${NEGRITA} Se escanea todo los puertos UDP. Puerde tardar varias horas${RESET}"
        echo
        echo -e "${VERDE} 10. Escaneo de vulnerabilidades (-sV --script=vulners)${RESET}"
        echo -e "${NEGRITA}     ${SUBRAYADO}Nota:${RESET}${NEGRITA} Utiliza la base de datos de vulnerabilidades junto con la deteccion"
        echo -e "     de versiones de software${RESET}"
		echo
        echo -e "${VERDE}  0.  Volver al Menú Principal${RESET}"
		echo
        echo -e "${VERDE}==============================================================${RESET}"
		echo
        read -p $'\e[1;32mIngrese una opción (0-10): \e[0m' opcionnmap

}

#
# OPCION 1
#
barrido_ping() {
    clear
    echo
    read -p $'\e[1;32mIngrese la red o IP a escanear (ejemplo: 192.168.1.0/24): \e[0m' barrido_ping_target
    echo
    if [ -z "$barrido_ping_target" ]; then
        echo "Error: no se ha proporcionado una red o IP válida."
        return
    fi

    echo
    echo "Escaneando la red $barrido_ping_target..."
    echo
    show_progress &
    spinner_pid=$!
    nmap -sn "$barrido_ping_target" | grep "Nmap scan report" | awk '{print $NF}'
    kill "$spinner_pid" 2>/dev/null
    echo
    read -p "Presione [Enter] para continuar..."
    # Después de esto volverá al menú NMAP automáticamente gracias al ciclo
}

#
# OPCION 2
#
no_ping() {
clear
ls
echo
read -p "Presione [Enter] para continuar..."
}

#
# OPCION 3
#
listar_equipos() {
clear
ls
echo
read -p "Presione [Enter] para continuar..."
}

#
# OPCION 4
#
ping_icmp() {
clear
ls
echo
read -p "Presione [Enter] para continuar..."
}

#
# OPCION 5
#
scan_full() {
clear
ls
echo
read -p "Presione [Enter] para continuar..."
}

#
# OPCION 6
#
escaneo_tcp() {
clear
ls
echo
read -p "Presione [Enter] para continuar..."
}

#
# OPCION 7
#
escaneo_syn() {
clear
ls
echo
read -p "Presione [Enter] para continuar..."
}

#
# OPCION 8
#
escaneo_udp_rapido() {
clear
ls
echo
read -p "Presione [Enter] para continuar..."
}

#
# OPCION 9
#
escaneo_udp() {
clear
ls
echo
read -p "Presione [Enter] para continuar..."
}

#
# OPCION 10
#
escaneo_vuln() {
clear
ls
echo
read -p "Presione [Enter] para continuar..."
}


if ! command -v nmap &> /dev/null; then
    echo "nmap no está instalado. Por favor, instálalo primero."
    exit 1
fi


# Menú principal
while true; do
    nmap_option

    case $opcionnmap in
        1) barrido_ping ;;
        2) no_ping ;;
        3) listar_equipos ;;
        4) ping_icmp ;;
        5) scan_full ;;
        6) escaneo_tcp ;;
        7) escaneo_syn ;;
        8) escaneo_udp_rapido ;;
        9) escaneo_udp ;;
        10) escaneo_vuln ;;
        0) exit 0 ;;
        *)
            echo
			echo "Opción no válida."
			echo
            read -p "Presione [Enter] para continuar..."
            ;;
    esac
done
