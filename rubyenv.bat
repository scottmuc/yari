@echo off
for /f "delims=" %%I in ('powershell -file rubyinstaller.ps1') do echo %%I
@echo on
