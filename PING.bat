@echo off
:menu
cls
echo ====================================
echo          MENU DE REDES
echo ====================================
echo 1. Hacer ping
echo 2. Realizar nslookup
echo 3. Ejecutar tracert
echo 4. Salir
echo ====================================
set /p opcion="Elige una opción (1-4): "

if "%opcion%"=="1" goto ping
if "%opcion%"=="2" goto nslookup
if "%opcion%"=="3" goto tracert
if "%opcion%"=="4" goto salir
goto menu

:ping
cls
set /p ip="Introduce la direccion IP o dominio para hacer ping: "

REM Ejecutamos el ping y mostramos el resultado
ping %ip% -n 1

REM Verificamos si el ping fue exitoso o no
if %ERRORLEVEL%==0 (
    echo Ping exitoso a %ip%
) else (
    echo Ping fallido a %ip%
)

pause
goto menu

:nslookup
cls
set /p ip="Introduce la direccion IP o dominio para realizar nslookup: "
nslookup %ip%
pause
goto menu

:tracert
cls
set /p ip="Introduce la direccion IP o dominio para ejecutar tracert: "
tracert %ip%
pause
goto menu

:salir
exit
