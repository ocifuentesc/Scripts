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

# Explicación de los colores:
# - \[\033[1;32m\] -> Verde brillante para el nombre de usuario (\u)
# - \[\033[1;31m\] -> Rojo brillante para la arroba (@)
# - \[\033[1;33m\] -> Amarillo brillante para el nombre del host (\h)
# - \[\033[1;36m\] -> Cian brillante para la ruta actual (\w)
# - \[\033[1;31m\] -> Rojo brillante para el símbolo del prompt ($ o # según el usuario)

# Ruta del archivo .bashrc
BASHRC="$HOME/.bashrc"

# Definir la configuración del prompt con export
PROMPT_CONFIG="export PS1='\\[\\033[1;32m\\]\\u\\[\\033[1;31m\\]@\\[\\033[1;33m\\]\\h:\\[\\033[1;36m\\]\\w\\[\\033[1;31m\\]\\$\\[\\033[0m\\] '"

# Verificar si ya existe una línea que defina PS1 en .bashrc
if ! grep -q "^export PS1=" "$BASHRC"; then
    echo "" >> "$BASHRC"  # Agregar una línea en blanco para organización
    echo "# Configuración del prompt con colores" >> "$BASHRC"
    echo "$PROMPT_CONFIG" >> "$BASHRC"
    echo "¡Cambio realizado!"
else
    echo "La configuración del prompt ya está aplicada. No se añadirá nuevamente."
fi

# Validar si el archivo .bashrc sigue teniendo una sintaxis correcta
if bash --norc --noprofile -c "source $BASHRC" &>/dev/null; then
    echo "Configuración agregada correctamente."
    echo "Para aplicar los cambios, ejecuta: source ~/.bashrc"
else
    echo "Error: El archivo .bashrc tiene problemas de sintaxis. Revísalo antes de recargarlo."
fi

