@echo off
setlocal EnableExtensions
setlocal EnableDelayedExpansion

if "%~1" equ "" call :print_usage
if "%~2" neq "" call :print_usage

set "vimdir=%~dp0"
set "app=%~1"
echo.Running application: %app%
"%vimdir%gvim.exe" -u "%vimdir%vimos.vimrc" -U "%vimdir%vimos.gvimrc" -S "%app%"

goto :eof

:print_usage
    echo.Usage: run APP
    exit /b 1
goto :eof
