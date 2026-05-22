@echo off
setlocal EnableDelayedExpansion
title ETL to PCAP Converter (Automated)

echo ========================================
echo        ETL to PCAP Converter
echo ========================================
echo.

:: Define temporary path for the Microsoft conversion engine
set "TOOL_PATH=%TEMP%\etl2pcapng.exe"

:: Check if the tool already exists in temp, if not, securely download it natively
if not exist "!TOOL_PATH!" (
    echo [*] Initializing conversion engine for the first time...
    echo [*] Downloading Microsoft's etl2pcapng securely via native curl...
    curl -s -L -o "!TOOL_PATH!" "https://github.com/microsoft/etl2pcapng/releases/latest/download/etl2pcapng.exe"
    
    if not exist "!TOOL_PATH!" (
        echo [ERROR] Failed to download the required conversion engine. 
        echo Check your internet connection and try again.
        pause
        exit /b
    )
)

:PROMPT_FOLDER
set /p "folderPath=Enter the full path to the folder containing .etl files: "

:: Remove quotes in case the folder was dragged and dropped
set "folderPath=%folderPath:"=%"

if not exist "%folderPath%\" (
    echo [!] The folder "%folderPath%" does not exist. Please try again.
    echo.
    goto PROMPT_FOLDER
)

:: Navigate to the target folder
pushd "%folderPath%"

set "fileCount=0"

for %%F in (*.etl) do (
    set /a fileCount+=1
    echo.
    echo Processing file: "%%~nxF"
    
    :: Determine the next available sequential filename
    set "counter="
    
    :FIND_NEXT_NAME
    if exist "converted!counter!.pcap" (
        if "!counter!"=="" (
            set "counter=1"
        ) else (
            set /a counter+=1
        )
        goto FIND_NEXT_NAME
    )
    
    set "outFile=converted!counter!.pcap"
    
    :: Convert using the background tool
    "!TOOL_PATH!" "%%~fF" "!outFile!"
    
    if !errorlevel! equ 0 (
        echo [SUCCESS] Saved as: "!outFile!"
    ) else (
        echo [ERROR] Failed to convert "%%~nxF". 
    )
)

if !fileCount! equ 0 (
    echo [!] No .etl files were found in "%folderPath%".
)

echo.
echo ========================================
echo               Finished!
echo ========================================
popd
pause