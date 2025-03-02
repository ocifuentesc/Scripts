@echo off

REM @author	Oscar Cifuentes Cisterna
REM @copyright	Copyright © 2023 Oscar Cifuentes Cisterna
REM @license	https://wwww.gnu.org/licenses/gpl.txt
REM @email	oscar@ocifuentesc.cl
REM @web		https://ocifuentesc.cl
REM @github	https://github.com/ocifuentesc

REM ###################################
REM ## Sistemas Operativos Testeados ##
REM ###################################

REM - Windows 10 Pro
REM - Windows 11 Pro

:menu
cls
color 0a
title Script con Utilidades
echo ========================
echo      MENU PRINCIPAL
echo ========================
echo.
echo 1. PING a una IP o Dominio
echo 2. NSLOOKUP a una IP o Dominio
echo 3. Informacion del equipo
echo 4. Listar procesos activos
echo 5. Ver Usuarios del Sistema
echo 6. Ver cache ARP
echo 7. Mostrar las conexiones TCP activas
echo 8. Actualizar Aplicaciones de Windows (Administrador)
echo 9. Activar / Desactivar firewall (Administrador)
echo 10. Borrar Cache DNS (Administrador)
echo.
echo 0. Salir
echo.
echo ========================
echo.
set /p opcion=Ingrese una opcion (0-10): 

if "%opcion%"=="1" goto opcion1
if "%opcion%"=="2" goto opcion2
if "%opcion%"=="3" goto opcion3
if "%opcion%"=="4" goto opcion4
if "%opcion%"=="5" goto opcion5
if "%opcion%"=="6" goto opcion6
if "%opcion%"=="7" goto opcion7
if "%opcion%"=="8" goto opcion8
if "%opcion%"=="9" goto opcion9
if "%opcion%"=="10" goto opcion10
if "%opcion%"=="0" goto :eof
if not "%opcion%"=="" goto otro

REM Opcion 1 - PING a una IP o Dominio
:opcion1
    cls
    echo.
    set /p ping=Ingrese direccion IP o Dominio: 
    ping %ping%
    echo.
    pause
    goto menu

REM Opcion 2 - NSLOOKUP a una IP o Dominio
:opcion2
    cls
    echo.
    set /p nslookup=Ingrese direccion IP o Dominio: 
    nslookup %nslookup%
    echo.
    pause
    goto menu

REM Opcion 3 - Informacion del equipo
:opcion3
    cls
    echo.
    echo Informacion del Equipo
    echo ----------------------
    echo.
    systeminfo | findstr /B /C:"Nombre de host"
    systeminfo | findstr /B /C:"Nombre del sistema operativo"
    systeminfo | findstr /B /i "Versión"
    systeminfo | findstr /B /i "Memoria"
    wmic bios get serialnumber
    echo.
    echo Informacion de Red
    echo ------------------
    echo.
    ipconfig | findstr "Direccion IPv4"
    ipconfig | findstr "subred"
    ipconfig | findstr "Puerta"
    ipconfig /all | findstr /C:"Servidores DNS"
    echo.
    pause
    goto menu

REM Opcion 4 - Procesos activos
:opcion4
    cls
    echo.
    tasklist
    echo.
    pause
    goto menu

REM Opcion 5 - Listar usuarios
:opcion5
    cls
    echo.
    net user
    echo.
    pause
    goto menu

REM Opcion 6 - Ver cache ARP
:opcion6
    cls
    echo.
    arp -a
    echo.
    pause
    goto menu

REM Opcion 7 - Ver conecciones activas
:opcion7
    cls
    echo.
    netstat -n
    echo.
    pause
    goto menu

REM Opcion 8 - Actualizar aplicaciones Windows
:opcion8
    cls
    echo.
    winget upgrade --all
    echo.
    pause
    goto menu

REM Opcion 9 - Activar/Desactivar Firewall
:opcion9
    :menufirewall
    cls
    echo.
    echo ==================================
    echo      MENU FIREWALL DE WINDOWS
    echo ==================================
    echo.
    echo 1. Activar Firewall
    echo 2. Desactivar Firewall
    echo.
    echo 0. Regresar al Menu Principal
    echo.
    echo ====================================
    echo.
    set /p opcion="Elige una opcion (0-2): "

    if "%opcion%"=="1" goto activar
    if "%opcion%"=="2" goto desactivar
    if "%opcion%"=="0" goto salir
    if not "%opcion%"=="" goto otrofirewall

    :activar
    cls
    echo Activando Firewall de Windows...
    netsh advfirewall set allprofiles state on
    if %ERRORLEVEL%==0 (
        echo Firewall activado correctamente.
    ) else (
        echo Error al activar el Firewall.
    )
    pause
    goto :menufirewall

    :desactivar
    cls
    echo Desactivando Firewall de Windows...
    netsh advfirewall set allprofiles state off
    if %ERRORLEVEL%==0 (
        echo Firewall desactivado correctamente.
    ) else (
        echo Error al desactivar el Firewall.
    )
    pause
    goto :menufirewall

    :otrofirewall
        cls
        echo.
        echo Ingresa una opcion valida
        echo.
        pause
        goto menufirewall

    :salir
    goto :menu

REM Opcion 10 - Borrar Cache DNS
:opcion10
    cls
    echo.
    echo Limpiando cache DNS ...
    echo.
    ipconfig /flushdns
    echo.
    echo Eliminando archivos temporales del sistema ...
    echo.
    del /q /f /s %temp%\*
    echo.
    echo Limpiando cache de actualizaciones de Windows ...
    echo.
    net stop wuauserv
    net stop bits
    del /f /s /q %windir%\SoftwareDistribution\*
    net start wuauserv
    net start bits
    echo.
    pause
    goto menu

REM En caso de marcar una opcion incorrecta
:otro
    cls
    echo.
    echo Ingresa una opcion valida
    echo.
    pause
    goto menu
