@echo off

if "%1" == "/?" goto :usage

for /f "delims=" %%I in ('powershell -file rubyinstaller.ps1') do set PATH=%%I;%PATH%

if "%1" == "user" goto :user
if "%1" == "machine" goto :machine
goto :end

:user
for /f "delims=" %%I in ('powershell -file rubyinstaller.ps1') do setx PATH "%%I"
goto :end

:machine
for /f "delims=" %%I in ('powershell -file rubyinstaller.ps1') do setx PATH "%%I;%PATH%" -m
goto :end

:usage
echo This script will setup your ruby environment
echo. 
echo rubyenv.bat                sets ruby for the session
echo rubyenv.bat user           sets ruby for the user
echo rubyenv.bat machine        sets ruby for the machine
echo. 
goto :end

:end
@echo on