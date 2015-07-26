@echo off
if "%*" == "" goto :usage

@powershell -ExecutionPolicy RemoteSigned "& '%~dp0..\rubyinstaller.ps1'" %*

if not exist "%~dp0..\yari.tmp.cmd" (
    echo something didn't work quite right...
    goto :usage
)

call "%~dp0..\yari.tmp.cmd"
del "%~dp0..\yari.tmp.cmd"
goto :end

:usage
echo Sets up a ruby environment for you 
echo. 
echo rubyenv [version] [-InstallMachine]
echo.
echo   version          1.8.7, 1.9.3, 2.0.0, 2.2.2
echo   -InstallMachine  permanently sets your machines PATH otherwise it only
echo                    sets it for the current session
echo. 
goto :end

:end
@echo on
