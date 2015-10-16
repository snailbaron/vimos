@echo off
setlocal EnableExtensions
setlocal EnableDelayedExpansion

set "target=%~1"
if "%target%" equ "" (
    set target=build
)

set "ops="

:: Directory with Win32.mak
set ops=%ops% SDK_INCLUDE_DIR="C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Include"

:: Feature set: TINY|SMALL|NORMAL|BIG|HUGE
::set ops=%ops% FEATURES=NORMAL
set ops=%ops% FEATURES=TINY

:: GUI interface
set ops=%ops% GUI=yes

:: OLE interface (requires GUI=yes)
::set ops=%ops% OLE=yes

:: Multibyte support
set ops=%ops% MBYTE=yes

:: IME support (requires GUI=yes). DYNAMIC_IME=yes loads imm32.dll dynamically
set ops=%ops% IME=yes
set ops=%ops% DYNAMIC_IME=no

:: Iconv library support, always dynamically loaded
set ops=%ops% ICONV=yes

:: Set subsystem, to target Windows XP, not Vista (6.0)
::set ops=%ops% SUBSYSTEM_VER=5.01

:: Debug version.
:: Also removes /GL from compiler flags, allowing to inspect object files with dumpbin.
::set ops=%ops% DEBUG=yes

:: NetBeans support
set ops=%ops% NETBEANS=no

:: CScope support
set ops=%ops% CSCOPE=no


:: Individual features to enable/disable
set "feat="

:: Syntax highlighting
set feat=%feat% -DFEAT_SYN_HL
set feat=%feat% -DFEAT_AUTOCMD
set feat=%feat% -DFEAT_EVAL

set ops=%ops% "DEFINES=%feat%"

cd vim\src

if "%target%" equ "build" (
    nmake -f Make_mvc.mak %ops%
    goto :eof
)
if "%target%" equ "clean" (
    nmake -f Make_mvc.mak %ops% clean
    goto :eof
)

echo.Unknown target: %target%

