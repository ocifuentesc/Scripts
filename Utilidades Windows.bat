@echo off
:menu
cls
color 0a
title Script con Utilidades
echo Script con Utilidades
echo ----------------------
echo.
echo 1. PING a una IP o Dominio
echo 2. NSLOOKUP a una IP o Dominio
echo 3. Informacion del equipo
echo 4. Listar procesos activos
echo 5. Ver Usuarios del Sistema
echo 6. Ver cache ARP
echo 7. Mostrar las conexiones TCP activas
echo 8. Actualizar Windows
echo 9. Activar / Desactivar firewall

echo.
echo 0. Salir
echo.
set /p opcion=Ingrese una opcion (0-9): 

if "%opcion%"=="1" goto opcion1
if "%opcion%"=="2" goto opcion2
if "%opcion%"=="3" goto opcion3
if "%opcion%"=="4" goto opcion4
if "%opcion%"=="5" goto opcion5
if "%opcion%"=="6" goto opcion6
if "%opcion%"=="7" goto opcion7
if "%opcion%"=="8" goto opcion8
if "%opcion%"=="9" goto opcion9
if "%opcion%"=="0" goto :eof
if not "%opcion%"=="" goto otro

:opcion1 @REM PING a una IP o Dominio
    cls
    echo.
    set /p ping=Ingrese direccion IP o Dominio: 
    ping %ping%
    echo.
    pause
    goto menu

:opcion2 @REM NSLOOKUP a una IP o Dominio
    cls
    echo.
    set /p nslookup=Ingrese direccion IP o Dominio: 
    nslookup %nslookup%
    echo.
    pause
    goto menu

:opcion3
    cls
    echo.
    echo Informacion del Equipo
    echo ----------------------
    echo.
	echo Modelo Equipo:
	wmic computersystem get manufacturer | findstr /v "Modelo Equipo"
	echo.
	echo Marca del Equipo:
	wmic computersystem get model | findstr /v "Modelo del Equipo"
	echo.
	echo Nombre del Equipo: %COMPUTERNAME%
	echo.
	echo Serial Number:
	wmic bios get serialnumber | findstr /v "SerialNumber"
    systeminfo | findstr /B /C:"Nombre de host"
    systeminfo | findstr /B /C:"Nombre del sistema operativo"
    systeminfo | findstr /B /i "Versión"
    systeminfo | findstr /B /i "Memoria"
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
  
:opcion4
    cls
    echo.
    tasklist
    echo.
    pause
    goto menu

:opcion5
    cls
    echo.
    net user
    echo.
    pause
    goto menu

:opcion6
    cls
    echo.
    arp -a
    echo.
    pause
    goto menu

:opcion7
    cls
    echo.
    netstat -n
    echo.
    pause
    goto menu

:opcion8
    cls
    echo.
    winget upgrade --all
    echo.
    pause
    goto menu

:opcion9
	:opcionfirewall
	cls
	echo Menu Firewall
	echo ----------------------
	echo.
	echo 1. Activar Firewall
	echo 2. Desactivar Firewall
	echo 3. Mostrar Estado del Firewall
	echo.
	echo 4. Salir al Menu Principal
	echo.
	set /p opcionfirewall=Ingrese una opcion (1-4):
	if "%opcionfirewall%"=="1" goto opcionfirewall1
	if "%opcionfirewall%"=="2" goto opcionfirewall2
	if "%opcionfirewall%"=="3" goto opcionfirewall3
	if "%opcionfirewall%"=="4" goto menu
	
	:opcionfirewall1
		netsh advfirewall set allprofile state on
		echo "Firewall activado."
		echo.
		pause
		goto opcionfirewall

	:opcionfirewall2
		netsh advfirewall set allprofile state off
		echo "Firewall desactivado."
		echo.
		pause
		goto opcionfirewall

	:opcionfirewall3
    for /F  %%i in ('netsh advfirewall show currentprofiles state ^| find "State"') do (set estado=%%i)
    if /I "%estado%"=="ON" (
        echo El Firewall esta actualmente habilitado.
    ) else (
        echo El Firewall esta actualmente deshabilitado.
    )
		echo.
		pause
		goto opcionfirewall
    
:otro
    cls
    echo.
    echo Ingresa una opcion valida
    echo.
    pause
    goto menu
