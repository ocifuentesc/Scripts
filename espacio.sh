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

# Definir colores usando tput para mayor compatibilidad
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

# Mostrar ayuda si el usuario pasa --help
if [[ "$1" == "--help" ]]; then
    echo "Uso: $0 [umbral] [opciones]"
    echo "Ejemplo: $0 90 --no-snap   (Muestra alertas si el uso del disco supera el 90% y oculta snap)"
    echo ""
    echo "Opciones disponibles:"
    echo "  --no-snap     Oculta particiones de Snap"
    echo "  --no-tmpfs    Oculta particiones temporales (tmpfs, /run)"
    exit 0
fi

# Establecer un umbral por defecto de 90% si no se proporciona un argumento
threshold=${1:-90}

# Verificar si el umbral ingresado es un número válido entre 1 y 100
if ! [[ "$threshold" =~ ^[0-9]+$ ]] || [ "$threshold" -lt 1 ] || [ "$threshold" -gt 100 ]; then
    echo -e "${RED}Error: Ingrese un número válido entre 1 y 100.${RESET}"
    exit 1
fi

# Verificar si el sistema admite --output=target,pcent
if ! df -h --output=target,pcent &>/dev/null; then
    echo -e "${RED}Error: Esta versión de df no admite --output=target,pcent.${RESET}"
    echo "Prueba ejecutando: df -h"
    exit 1
fi

# Obtener los datos de uso del disco
disk_data=$(df -h --output=target,pcent | tail -n +2)

# Aplicar filtros si se especifican
if [[ "$2" == "--no-snap" ]]; then
    disk_data=$(echo "$disk_data" | grep -v '/snap')
fi

if [[ "$3" == "--no-tmpfs" ]]; then
    disk_data=$(echo "$disk_data" | grep -Ev 'tmpfs|/run')
fi

# Ordenar por mayor uso de disco
disk_data=$(echo "$disk_data" | sort -k2 -nr)

# Verificar si se obtuvieron datos después de los filtros
if [ -z "$disk_data" ]; then
    echo -e "${RED}Error: No se encontraron sistemas de archivos montados.${RESET}"
    echo "Prueba ejecutando: df -h"
    exit 1
fi

# Determinar el ancho máximo de la columna "Montaje"
max_mount_length=$(echo "$disk_data" | awk '{print length($1)}' | sort -nr | head -1)
((max_mount_length = max_mount_length < 7 ? 7 : max_mount_length)) # Mínimo de 7 caracteres

# Configurar los anchos de columna
col1_width=$((max_mount_length + 2))
col2_width=6  # Siempre 6 caracteres ("100% ")

# Encabezado con color
echo -e "${BLUE}$(printf "%-${col1_width}s %-${col2_width}s %-10s" "Montaje" "Uso%" "Estado")${RESET}"
echo -e "${BLUE}$(printf "%-${col1_width}s %-${col2_width}s %-10s" "-------" "----" "------")${RESET}"

# Procesar cada línea del resultado de df
while read -r mount usage; do
    usage=${usage%\%}  # Eliminar el símbolo de porcentaje

    # Determinar estado según el umbral con colores
    if [ "$usage" -gt "$threshold" ]; then
        status="${RED}⚠️ ALTO USO${RESET}"  # Rojo
    else
        status="${GREEN}✅ OK${RESET}"  # Verde
    fi

    # Mostrar datos alineados con colores interpretados correctamente
    echo -e "$(printf "%-${col1_width}s %-${col2_width}s %-10s" "$mount" "$usage%" "$status")"
done <<< "$disk_data"

echo -e "${BLUE}$(printf "%-${col1_width}s %-${col2_width}s %-10s" "-------" "----" "------")${RESET}\n"

