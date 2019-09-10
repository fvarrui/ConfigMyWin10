# Mi configurador inicial de Windows 10

Para configurar los equipos con Windows instalado ejecutamos un script que hace lo siguiente:

1. Instala el software de la siguiente [lista](packages.txt).

2. Configura el sistema para que almacene los perfiles de los usuarios en la segundad unidad (unidad D:)

   > :warning: Sólo en caso de que se detecte una segunda unidad en el equipo.

3. Desinstala OneDrive.

4. Cambia el nombre del equipo a `CENTOLLO` (el nombre de mi portátil) y mete el equipo en el grupo de trabajo `MINIK`.

5. Reinicia el equipo para establecer algunos cambios realizados.

## Requisitos

* Windows 7+/2012+
* PowerShell v2+

## Ejecución del script

Ejecutar el siguiente comando como `Administrador` desde:

### Símbolo del sistema (CMD)

```
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/fvarrui/win10-configurator/master/config-windows.ps1'))"
```

### PowerShell (PS)

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/fvarrui/win10-configurator/master/config-windows.ps1'))
```

