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
## @copyright	Copyright © 2023 Oscar Cifuentes Cisterna
## @license	https://wwww.gnu.org/licenses/gpl.txt
## @email	oscar@ocifuentesc.cl
## @web		https://ocifuentesc.cl
## @github	https://github.com/ocifuentesc
##
##

###################################
## Sistemas Operativos Testeados ##
###################################
# - Debian 12
# - Ubuntu Server 22.04
# - Ubuntu Server 23.04
# - MacOS Ventura 13.4.1
# - CentOS Stream 8
# - CentOS Stream 9
# - Fedora Workstation 38

###############
## Variables ##
###############
red=$(tput setaf 1)
yellow=$(tput setaf 3)
negrita=$(tput bold)
reset=$(tput sgr0)
subrayado=$(tput smul)

#####################################
## Detectamos el sistema operativo ##
#####################################
os="Desconocido"
unamestr="${OSTYPE//[0-9.]/}"
os=$( compgen -G "/etc/*release" > /dev/null  && cat /etc/*release | grep ^NAME | tr -d 'NAME="'  ||  echo "$unamestr")

# Ejecución
clear
echo "${red}${negrita}----------------------------${reset}"
echo "${red}${negrita}Detectando Sistema Operativo${reset}"
echo "${red}${negrita}----------------------------${reset}"
echo
sleep 2
echo "${yellow}${negrita}Sistema identificado como $os${reset}"
sleep 2
echo

case $os in

# Archi Linux
*rch*)
echo "${red}${negrita}Actualizando Sistema...${reset}"
echo
sudo pacman -Syyu
echo
echo "${red}${negrita}Sistema Actualizado${reset}"
echo
;;

#
# Debian
#
*Debian* | *Ubuntu*)
# Actualizamos la lista de paquetes disponibles y sus versiones en los repositorios
echo "${red}${negrita}Descargando Lista de Repositorios...${reset}"
echo
sudo apt-get update -y
echo
# Actualizamos paquetes del sistema
echo "${red}${negrita}Actualizando Sistema...${reset}"
echo
sudo apt upgrade -y && sudo apt dist-upgrade -y
echo
# Eliminamos del repositorio local, la caché, los paquetes de versiones antiguas e inútiles
echo "${red}${negrita}Limpiando...${reset}"
echo
sudo apt autoremove -y && sudo apt autoclean
echo
# Proceso terminado
echo "${red}${negrita}Sistema Actualizado${reset}"
echo
;;

#
# CentOS
#
*CentOS*| *Fedora*)
# Actualizamos la lista de paquetes disponibles y sus versiones en los repositorios
echo "${red}${negrita}Descargando Lista de Repositorios...${reset}"
echo
sudo yum update -y
echo
# Actualizamos paquetes del sistema
echo "${red}${negrita}Actualizando Sistema...${reset}"
echo
sudo yum upgrade -y
echo
# Eliminamos del repositorio local, la caché, los paquetes de versiones antiguas e inútiles
echo "${red}${negrita}Limpiando...${reset}"
echo
sudo yum clean all
echo
# Proceso terminado
echo "${red}${negrita}Sistema Actualizado${reset}"
echo
;;

#
# MacOS
#
*darwin*)
echo "${yellow}${negrita}"Sistema Operativo MacOS NO Compatible con el Script"${reset}"
echo
;;

#
# Otros
#
(*)
echo "${yellow}${negrita}Error: Arquitectura del Sistema Operativo NO encontrada${reset}"
echo
;;

esac