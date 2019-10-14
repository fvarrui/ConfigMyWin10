# Mi configurador inicial de Windows 10

Para configurar mi equipo con Windows 10 recién instalado ejecuto el siguiente script y ocurre la magia:

1. Instala el software de la siguiente [lista](packages.txt).

2. Configura el sistema para que almacene los perfiles de los usuarios en la segundad unidad (unidad D:)

   > :warning: Sólo en caso de que se detecte una segunda unidad en el equipo.

3. Desinstala OneDrive.

4. Cambia el nombre del equipo a `CENTOLLO` (el nombre de mi portátil) y mete el equipo en el grupo de trabajo `MINIK`.

5. Cambia la zona horaria a GMT/UTC+0.

6. Reinicia el equipo para establecer algunos cambios realizados.

## Requisitos

* Windows 10+/2016+
* PowerShell v5+

## Configuración completa del equipo

Ejecutar el siguiente comando como `Administrador` desde **PowerShell (PS)**:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/fvarrui/ConfigMyWin10/master/config-windows.ps1'))
```

## Sólo desinstalar OneDrive 

Ejecutar el siguiente comando como `Administrador` desde **PowerShell (PS)**:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/fvarrui/ConfigMyWin10/master/uninstall-onedrive.ps1'))
```
