@echo off
setlocal EnableExtensions
setlocal EnableDelayedExpansion

set archive=vimos.7z
set files=apps workspace vim-pkg README.md

:: Check if 7-zip is available
7z >NUL 2>&1
if errorlevel 1 (
    echo.7-zip cannot be run. Make sure 7z.exe is in your PATH.
    exit 1
)

7z a %archive% %files%

