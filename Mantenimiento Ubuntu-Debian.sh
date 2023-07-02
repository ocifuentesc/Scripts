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
## @copyright	Copyright © 2022 Oscar Cifuentes Cisterna
## @license	https://wwww.gnu.org/licenses/gpl.txt
## @email	oscar@ocifuentesc.cl
## @web		https://ocifuentesc.cl
## @github	https://github.com/ocifuentesc
## @twitter	https://twitter.com/ocifuentesc
## @linkedin	https://www.linkedin.com/in/oscar-cifuentes-c-b125b24a/
##
##

# Variables
red='\033[31m'
reset='\033[0m'
negrita='\033[1m'
subrayado='\033[4m'

# Limpiamos la pantalla
clear

# Actualizamos la lista de paquetes disponibles y sus versiones
# en los repositorios
echo -e "\n\t${red}${negrita}${subrayado}Descargando Lista de Repositorio${reset}\n"
sudo apt update -y

# Actualizamos paquetes del sistema
clear
echo -e "\n\t${red}${negrita}${subrayado}Actualizando Sistema${reset}\n"
sudo apt upgrade -y && sudo apt dist-upgrade -y

# Eliminamos del repositorio local, la caché, los paquetes de
# versiones antiguas e inútiles
clear
echo -e "\n\t${red}${negrita}${subrayado}Limpiando${reset}\n"
sudo apt autoremove -y && sudo apt autoclean

# Script terminado
clear
echo -e "\n\t${red}${negrita}${subrayado}Sistema Actualizado${reset}\n"