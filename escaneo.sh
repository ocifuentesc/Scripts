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

# Función para validar IP o dominio
test_input() {
    local input="$1"
    if [[ $input =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ || $input =~ ^([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$ ]]; then
        echo "$input"
    else
        echo "Error: Dirección IP o dominio inválido." >&2
        exit 1
    fi
}

# Función para resolver dominios a IP
resolve_domain() {
    local target="$1"
    if [[ $target =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo "$target"
    else
        local target_ip=$(getent hosts "$target" | awk '{ print $1 }')
        if [[ -z "$target_ip" ]]; then
            echo "Error: No se pudo resolver el dominio a una dirección IP." >&2
            exit 1
        fi
        echo "$target_ip"
    fi
}

# Función para realizar escaneo básico
scan_basic() {
    read -p "Ingresa la dirección IP o dominio de destino: " target
    target=$(test_input "$target")
    target_ip=$(resolve_domain "$target")
    echo "Escaneando $target_ip..."
    nmap -sV "$target_ip"
}

# Función para escaneo de vulnerabilidades
scan_vuln() {
    read -p "Ingresa la dirección IP o dominio de destino: " target
    target=$(test_input "$target")
    target_ip=$(resolve_domain "$target")
    scan_dir="scan_reports"
    mkdir -p "$scan_dir"
    nmap --script=vuln -oX "$scan_dir/vulnerabilidades.xml" "$target_ip"
    xsltproc "$scan_dir/vulnerabilidades.xml" -o "$scan_dir/vulnerabilidades.html"
    echo "Reporte generado en $scan_dir/vulnerabilidades.html"
}

# Menú de opciones
echo "Seleccione una opción:"
echo "1) Escaneo básico"
echo "2) Escaneo de vulnerabilidades"
echo "0) Salir"
read -p "Opción: " opcion

case $opcion in
    1) scan_basic ;;
    2) scan_vuln ;;
    0) exit 0 ;;
    *) echo "Opción no válida." ;;
esac

