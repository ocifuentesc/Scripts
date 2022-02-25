#!/bin/bash

# ███╗   ██╗███████╗████████╗███████╗███████╗ ██████╗██╗   ██╗██████╗ ██╗████████╗██╗   ██╗
# ████╗  ██║██╔════╝╚══██╔══╝██╔════╝██╔════╝██╔════╝██║   ██║██╔══██╗██║╚══██╔══╝╚██╗ ██╔╝
# ██╔██╗ ██║█████╗     ██║   ███████╗█████╗  ██║     ██║   ██║██████╔╝██║   ██║    ╚████╔╝ 
# ██║╚██╗██║██╔══╝     ██║   ╚════██║██╔══╝  ██║     ██║   ██║██╔══██╗██║   ██║     ╚██╔╝  
# ██║ ╚████║███████╗   ██║   ███████║███████╗╚██████╗╚██████╔╝██║  ██║██║   ██║      ██║   
# ╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝   
#
# Sitio Web: https://netsecurity.cl 

echo -e "¿Desea realizar el mantenimiento al sistema? (S/N): \c"
read MyVar1
echo "Estimad@ $USER, Ha seleccionado $MyVar1"

case $MyVar1 in
        [Ss])
                echo -e "¿Desea Actualizar el Sistema? (S/N): \c"
                read MyVar2
                if [ $MyVar2 == "S" ]
                        then
                                echo "Se procede a actualizar..."
                                sudo yum update && sudo yum upgrade -y
                fi
                echo -e "¿Desea limpiar la memoria cache? (S/N): \c"
                read MyVar3
                if [ $MyVar3 == "S" ]
                        then
                                echo "Se procede a limpiar la memoria cache..."
                                sudo yum autoremove -y && sudo yum autoclean
                fi
                echo -e "¿Desea Desocupar la Carpeta /tmp/? (S/N): \c"
                read MyVar4
                if [ $MyVar4 == "S" ]
                        then
                                echo "Se procede a desocupar la carpeta /tmp/..."
                                sudo rm -r /tmp/*
                                echo "Carpeta desocupada"
                fi
                echo "Mantenimiento Terminado"
                exit 0
                ;;
        [Nn])
                echo "Mantenimiento Cancelado"
                exit 0
                ;;
        *)
                echo -e "$USER, has seleccionado $MyVar1, esta es una opción inválida, se procede a cancelar la ejeccución del script"
                exit 0
                ;;
esac

