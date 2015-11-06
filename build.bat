@echo off
setlocal EnableExtensions
setlocal EnableDelayedExpansion

:: If nmake is not available, try to find and run vcvarsall.bat
nmake /? > NUL 2>&1
if errorlevel 1 (
    echo.nmake is not found, trying to find and run vcvarsall.bat
    set key=HKLM\SOFTWARE\Microsoft\VisualStudio\12.0
    set value=ShellFolder
    set type=REG_SZ
    for /f "tokens=1,2*" %%a in ('reg query !key! /v !value! /reg:32') do (
        if "%%a" equ "!value!" if "%%b" equ "!type!" (
            set "vspath=%%c"
        )
    )

    set "vcvars=!vspath!\VC\vcvarsall.bat"
    call "!vcvars!" amd64

    nmake /? > NUL 2>&1
    if errorlevel 1 (
        echo.Failed to find nmake
        exit /b 1
    )
    echo.nmake is found
)

set "ops="

:: Directory with Win32.mak
set ops=%ops% SDK_INCLUDE_DIR="C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Include"

:: Feature set: TINY|SMALL|NORMAL|BIG|HUGE
set ops=%ops% FEATURES=NORMAL
::set ops=%ops% FEATURES=TINY
::set ops=%ops% FEATURES=SMALL

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

:: NetBeans support
set ops=%ops% NETBEANS=no

:: CScope support
set ops=%ops% CSCOPE=no


:: Clean package directory
rmdir /s /q vim-pkg

:: Go to ViM source directory for building
cd vim\src

:: Build ViM
nmake -f Make_mvc.mak %ops%
if errorlevel 1 (
    echo.BUILD FINISHED WITH ERRORS
    exit /b 1
)

:: Copy gvim binary and runtime files to package directory
mkdir ..\..\vim-pkg
mkdir ..\..\vim-pkg\autoload
mkdir ..\..\vim-pkg\colors
mkdir ..\..\vim-pkg\syntax

copy gvim.exe ..\..\vim-pkg
copy ..\runtime\autoload\paste.vim ..\..\vim-pkg\autoload\
copy ..\runtime\colors\desert.vim ..\..\vim-pkg\colors\
copy ..\runtime\syntax\syntax.vim ..\..\vim-pkg\syntax\
copy ..\runtime\filetype.vim ..\..\vim-pkg\
copy ..\runtime\menu.vim ..\..\vim-pkg\
copy ..\runtime\rgb.txt ..\..\vim-pkg\

copy ..\..\vim-pkg-src\vimos.vimrc ..\..\vim-pkg
copy ..\..\vim-pkg-src\vimos.gvimrc ..\..\vim-pkg
copy ..\..\vim-pkg-src\run.bat ..\..\vim-pkg

:: Clean after successful build
nmake -f Make_mvc.mak %ops% clean

