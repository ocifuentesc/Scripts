#!/bin/bash

# ███╗   ██╗███████╗████████╗███████╗███████╗ ██████╗██╗   ██╗██████╗ ██╗████████╗██╗   ██╗
# ████╗  ██║██╔════╝╚══██╔══╝██╔════╝██╔════╝██╔════╝██║   ██║██╔══██╗██║╚══██╔══╝╚██╗ ██╔╝
# ██╔██╗ ██║█████╗     ██║   ███████╗█████╗  ██║     ██║   ██║██████╔╝██║   ██║    ╚████╔╝ 
# ██║╚██╗██║██╔══╝     ██║   ╚════██║██╔══╝  ██║     ██║   ██║██╔══██╗██║   ██║     ╚██╔╝  
# ██║ ╚████║███████╗   ██║   ███████║███████╗╚██████╗╚██████╔╝██║  ██║██║   ██║      ██║   
# ╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝   
#
# Sitio Web: https://netsecurity.cl 

#Indicamos la variable Fecha para asignarle al nombre del backup
Fecha=$(date +%d-%B-%Y-%H-%M-%S)


# Guardamos toda la carpeta de nuestro usuario
# --exclude=*.jpg / Agregar al comando en el caso que se quiera excluir imagenes
tar -cvpJf Backup_$Fecha.tar.xz /home/netsecurity/* > /var/log/Backup 2>&1 