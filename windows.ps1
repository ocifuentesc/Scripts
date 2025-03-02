# Verifica si el script se ejecuta como administrador y reinicia si es necesario
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ADVERTENCIA: Este script requiere privilegios de administrador. Reiniciando con permisos elevados..." -ForegroundColor Red
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Configurar PowerShell para usar UTF-8 sin BOM y evitar problemas de codificacion
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

# Guardar la politica de ejecucion actual y cambiarla temporalmente
$prevPolicy = Get-ExecutionPolicy
Set-ExecutionPolicy Bypass -Scope Process -Force

function Mostrar-Menu {
    Clear-Host
    Write-Host ""
    Write-Host "======================================="
    Write-Host "     MENU PRINCIPAL DE UTILIDADES"
    Write-Host "======================================="
    Write-Host ""
    Write-Host "1. PING a una IP o Dominio"
    Write-Host "2. NSLOOKUP a una IP o Dominio"
    Write-Host "3. Informacion del Equipo"
    Write-Host "4. Listar Procesos Activos"
    Write-Host "5. Ver Usuarios del Sistema"
    Write-Host "6. Ver Cache ARP"
    Write-Host "7. Mostrar Conexiones TCP Activas"
    Write-Host "8. Actualizar Aplicaciones de Windows"
    Write-Host "9. Activar / Desactivar Firewall"
    Write-Host "10. Limpiar Cache DNS y Archivos Temporales"
    Write-Host ""
    Write-Host "0. Salir"
    Write-Host ""
    Write-Host "======================================="
}

function Menu-Firewall {
    while ($true) {
        Clear-Host
        Write-Host ""
        Write-Host "================================="
        Write-Host "     MENU DE FIREWALL"
        Write-Host "================================="
        Write-Host ""
        Write-Host "1. Activar Firewall"
        Write-Host "2. Desactivar Firewall"
        Write-Host "3. Mostrar Estado del Firewall"
        Write-Host ""
        Write-Host "0. Volver al Menu Principal"
        Write-Host ""
        Write-Host "================================="
        Write-Host ""
        
        $fwopcion = Read-Host "Seleccione una opcion (1-3)"
        switch ($fwopcion) {
            "1" {
                Clear-Host
                Write-Host ""
                netsh advfirewall set allprofiles state on
                Write-Host "Firewall activado."
            }
            "2" {
                Clear-Host
                Write-Host ""
                netsh advfirewall set allprofiles state off
                Write-Host "Firewall desactivado."
            }
            "3" {
                Clear-Host
                Write-Host ""
                netsh advfirewall show allprofiles
            }
            "0" {
                return  # Volver al menu principal
            }
            default {
                Write-Host "ADVERTENCIA: Opcion no valida, por favor intente de nuevo." -ForegroundColor Red
            }
        }
        Write-Host ""
        Write-Host "Presione Enter para continuar..."
        Read-Host
    }
}

while ($true) {
    Mostrar-Menu
    Write-Host ""
    $opcion = Read-Host "Ingrese una opcion (1-10)"
    
    switch ($opcion) {
        "1" {
            Clear-Host
            Write-Host ""
            $hostInput = Read-Host "Ingrese una direccion IP o Dominio"
            Test-Connection -ComputerName $hostInput -Count 4
        }
        "2" {
            Clear-Host
            Write-Host ""
            $hostInput = Read-Host "Ingrese una direccion IP o Dominio"
            Resolve-DnsName -Name $hostInput
        }
        "3" {
            Clear-Host
            Write-Host ""
            Write-Host "===== Informacion del Equipo ====="
            Get-CimInstance Win32_ComputerSystem | Select-Object Manufacturer, Model
            Write-Host "Numero de Serie: " (Get-CimInstance Win32_BIOS).SerialNumber
            Write-Host "Nombre del Equipo: " $env:COMPUTERNAME
            systeminfo | findstr /B /C:"Nombre de host" /C:"Nombre del sistema operativo" /C:"Version" /C:"Memoria"
        }
        "4" {
            Clear-Host
            Write-Host ""
            Write-Host "===== Procesos Activos ====="
            Write-Host ""
            Get-Process | Select-Object ProcessName, Id, CPU | Format-Table -AutoSize
        }
        "5" {
            Clear-Host
            Write-Host ""
            Write-Host "===== Usuarios del Sistema ====="
            Write-Host ""
            Get-LocalUser | Select-Object Name, Enabled | Format-Table -AutoSize
        }
        "6" {
            Clear-Host
            Write-Host ""
            Write-Host "===== Tabla ARP ====="
            Write-Host ""
            arp -a
        }
        "7" {
            Clear-Host
            Write-Host ""
            Write-Host "===== Conexiones TCP Activas ====="
            Write-Host ""
            netstat -n -o
        }
        "8" {
            Clear-Host
            Write-Host ""
            if (Get-Command winget -ErrorAction SilentlyContinue) {
                Write-Host "Buscando actualizaciones de aplicaciones..."
                Write-Host ""
                $updates = winget upgrade | Out-String
                
                if ($updates -match "No se encontro ningun paquete" -or $updates -match "No applicable update found") {
                    Write-Host "No hay actualizaciones disponibles." -ForegroundColor Green
                } else {
                    Write-Host ""
                    Write-Host "Actualizando aplicaciones..."
                    winget upgrade --all
                }
            } else {
                Clear-Host
                Write-Host ""
                Write-Host "ERROR: Winget no esta instalado o no esta disponible en este sistema." -ForegroundColor Red
            }
        }
        "9" {
            Menu-Firewall  # Llamar al menu de firewall
        }
        "10" {
            Clear-Host
            Write-Host ""
            Write-Host "Limpiando cache DNS..."
            ipconfig /flushdns
            Write-Host ""
            Write-Host "Eliminando archivos temporales..."
            Remove-Item -Path $env:TEMP\* -Force -Recurse -ErrorAction SilentlyContinue -Confirm:$true
            Write-Host ""
            Write-Host "Limpiando cache de actualizaciones de Windows..."
            Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue -Confirm:$true
            Stop-Service -Name bits -Force -ErrorAction SilentlyContinue -Confirm:$true
            Remove-Item -Path C:\Windows\SoftwareDistribution\* -Force -Recurse -ErrorAction SilentlyContinue -Confirm:$true
            Start-Service -Name wuauserv
            Start-Service -Name bits
        }
        "0" {
            # Restaurar la politica de ejecucion original antes de salir
            Set-ExecutionPolicy $prevPolicy -Scope Process -Force
            exit
        }
        default {
            Clear-Host
            Write-Host ""
            Write-Host "ADVERTENCIA: Opcion no valida, por favor intente de nuevo." -ForegroundColor Red
        }
    }
    Write-Host ""
    Write-Host "Presione Enter para continuar..."
    Read-Host    
}
