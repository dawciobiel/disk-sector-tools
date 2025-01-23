@echo off
REM The script is used under Windows for compilation and linking using NASM of the source code file given as the launch parameter.
REM
REM Author: Dawid Bielecki - dawciobiel
REM GitHub: https://github.com/dawciobiel
REM Version: beta
REM
REM Usage:
REM   build-windows-x64.bat <nasm_source_file>

REM Displaying an empty line
echo.

REM Checking if a file was provided as an argument
IF "%~1"=="" (
    echo Usage: %~nx0 ^<source_file^>
    exit /b 1
)

REM Variable containing the source file name
SET "SOURCE_FILE=%~1"

REM Checking if the file exists
IF NOT EXIST "%SOURCE_FILE%" (
    echo File [%SOURCE_FILE%] does not exist.
    exit /b 2
)

REM Variable containing the executable file name (without extension)
SET "OUTPUT_FILE=%~n1"

REM Compiling the ASM file using NASM
echo Compiling [%SOURCE_FILE%]
nasm -f win64 -o "%OUTPUT_FILE%.obj" "%SOURCE_FILE%"
IF NOT "%ERRORLEVEL%"=="0" (
    echo Compilation error.
    exit /b 3
)

REM Linking the object file
echo Linking [%OUTPUT_FILE%.obj]
link /SUBSYSTEM:CONSOLE /ENTRY:start /OUT:"%OUTPUT_FILE%.exe" "%OUTPUT_FILE%.obj"
IF NOT "%ERRORLEVEL%"=="0" (
    echo Linking error.
    exit /b 4
)

REM Print success message
echo.
echo Executable file [ %OUTPUT_FILE%.exe ] created successfully.

REM List content of the current folder
dir /b
