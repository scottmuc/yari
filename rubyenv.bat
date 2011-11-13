@echo off
if "%*" == "" goto :usage

@powershell -ExecutionPolicy RemoteSigned .\rubyinstaller.ps1 %*

if not exist yari.tmp.cmd (
    echo something didn't work quite right...
    goto :usage
)

call yari.tmp.cmd
del yari.tmp.cmd
goto :end

:usage
echo This script will setup your ruby environment
echo. 
echo rubyenv.bat version               sets ruby for the session
echo. 
goto :end

:end
@echo on
