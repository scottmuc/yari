@echo off
if "%*" == "" goto :usage

@powershell -ExecutionPolicy RemoteSigned %~dp0rubyinstaller.ps1 %*

if not exist %~dp0yari.tmp.cmd (
    echo something didn't work quite right...
    goto :usage
)

call %~dp0yari.tmp.cmd
del %~dp0yari.tmp.cmd
goto :end

:usage
echo Sets up a ruby environment for you 
echo. 
echo rubyenv.bat [version] [-MachineScope]
echo.
echo   version          1.8.7, 1.9.2
echo   -MachineScope    permanently sets your machines PATH otherwise it only
echo                    sets it for the current session
echo. 
goto :end

:end
@echo on