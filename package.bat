@echo off
setlocal EnableExtensions
setlocal EnableDelayedExpansion

set archive=vimos.7z
set files=apps workspace README.md

:: Check if 7-zip is available
7z.exe >NUL 2>&1
if errorlevel 1 (
    echo.7-zip cannot be run. Make sure 7z.exe is in your PATH.
    exit 1
)

7z.exe a %archive% %files%

