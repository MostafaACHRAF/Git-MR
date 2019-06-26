@echo off
:: @Author : Mostafa ASHARF
:: @Date (en) : 05/11/19
:: @Last update (en) : 06/26/19
:: @Version : 3.0
:: Developed will listening to piano music \(^_^)/

echo "############################################################################"
echo "###/ \####| |#| |#|_   _|#/  _  \#####/  __\##(_)#|_   _|##| \##/ |#|  _ \##"
echo "##/ _ \###| |#| |###| |###| |#| |####| |############| |####|  \/  |#| |#||##"
echo "#/ /#\ \##| |#| |###| |###| |#| |####| |#\ _\#| |###| |####| |\/| |#|  _ \##"
echo "/_/###\_\#\_____/###|_|###\_____/#()#\_____|##|_|###|_|#()#|_|##|_|#|_|#|_\#"
echo "############################################################################"
echo "Version : 3.0"

:: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ CONFIG @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
setlocal EnableDelayedExpansion
set SRC_PATH=C:\gitAutoMR\
set SRC_SCRIPT=git-lmr
set SRC_SCRIPT_PATH=!%SRC_PATH%%SRC_SCRIPT%!

:: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  MAIN FUN @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
:: CREATE THE SRC FOLDER, THEN COPY THE SRC SCRIPT INTO IT

echo ">> [Result] : Create [%SRC_PATH%]..."
mkdir %SRC_PATH%

SET ACTUAL_PATH=%~dp0

echo ">> [Result] : Copy [%SRC_SCRIPT%] into [%SRC_PATH%]..."
powershell -command "Copy-Item -Path $env:ACTUAL_PATH\git-lmr -Destination $env:SRC_PATH"

if exist %SRC_SCRIPT_PATH% (
  echo ">> [Configure] : The OS : 'WINDOWS' in [%SRC_SCRIPT_PATH%]..."
  powershell -command "(gc $env:SRC_SCRIPT_PATH) -replace 'NONO_OS', 'WINDOWS' | sc $env:SRC_SCRIPT_PATH"

  :: UPDATE PATH VARIABLE
  ::if exist %SRC_SCRIPT_PATH% (
  ::echo ">> [ADD] : [%SRC_PATH%] to PATH ENVIROMENT VARIABLE..."
  ::powershell -command "[Environment]::SetEnvironmentVariable('Path', $env:Path -join ';C:\gitAutoMR\', 'Machine')"
  ::)
  echo ">> [Manually] : add [%SRC_PATH%] to your PATH environement variable \[x_X]/"

  :: DOWNLOAD AND INSTALL CHOCOLATEY
  echo ">> [Result] : Download and install chocolatey..."
  @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

  :: Download and install jq
  echo ">> [Result] : Download and install jq..."
  chocolatey install jq

  :: INSTALL CURL
  echo ">> [Result] : Install curl..."
  choco install curl
)

pause