#!/bin/sh
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
## @copyright	Copyright © 2023 Oscar Cifuentes Cisterna
## @license	https://wwww.gnu.org/licenses/gpl.txt
## @email	oscar@ocifuentesc.cl
## @web		https://ocifuentesc.cl
## @github	https://github.com/ocifuentesc
##
##

# Variables
red='\033[31m'
reset='\033[0m'
negrita='\033[1m'
subrayado='\033[4m'

# Limpiamos la pantalla
clear

# Detectamos el sistema operativo
echo "\n\t${red}----------------------------${reset}"
echo "\t${red}${negrita}${subrayado}Detectando Sistema Operativo${reset}"
echo "\t${red}----------------------------${reset}"
sleep 3

uname=$(uname);
case "$uname" in

##
## Debian / Ubundu / Mint
##
    (*Linux*)
echo "Sistema Operativo derivado de Debian..."
echo "Se procederá a actualizar"
sleep 3

# Actualizamos la lista de paquetes disponibles y sus versiones
# en los repositorios
echo "\n\t${red}${negrita}${subrayado}Descargando Lista de Repositorio${reset}\n"
sudo apt update -y

# Actualizamos paquetes del sistema

echo "\n\t${red}${negrita}${subrayado}Actualizando Sistema${reset}\n"
sudo apt upgrade -y && sudo apt dist-upgrade -y

# Eliminamos del repositorio local, la caché, los paquetes de
# versiones antiguas e inútiles

echo "\n\t${red}${negrita}${subrayado}Limpiando${reset}\n"
sudo apt autoremove -y && sudo apt autoclean

echo "\n\t${red}${negrita}${subrayado}Sistema Actualizado${reset}\n"; ;;

##
## Arch Linux
##
    (*Darwin*) updateCmd='sudo pacman -Syyu'; ;;

##
## CentOS / Fedora / RHEL
##
    (*CYGWIN*)
    (
# Actualizamos la lista de paquetes disponibles y sus versiones
# en los repositorios
echo "\n\t${red}${negrita}${subrayado}Descargando Lista de Repositorio${reset}\n"
sudo yum update -y

# Actualizamos paquetes del sistema
clear
echo "\n\t${red}${negrita}${subrayado}Actualizando Sistema${reset}\n"
sudo yum upgrade -y && sudo yum dist-upgrade -y

# Eliminamos del repositorio local, la caché, los paquetes de
# versiones antiguas e inútiles
clear
echo "\n\t${red}${negrita}${subrayado}Limpiando${reset}\n"
sudo yum autoremove -y && sudo yum autoclean


clear
echo "\n\t${red}${negrita}${subrayado}Sistema Actualizado${reset}\n"); ;;



    (*) echo 'error: unsupported platform.'; exit 2; ;;
esac;
$updateCmd;
# Script terminado
