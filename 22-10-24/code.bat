@echo off
setlocal

REM Set source and backup directory
set "SOURCE=C:\TestFiles"
set "BACKUP_ROOT=D:\Backups"
set "DATE=%date:~10,4%%date:~4,2%%date:~7,2%"  REM Format: YYYYMMDD
set "BACKUP_DIR=%BACKUP_ROOT%\%DATE%"
set "LOG_FILE=%BACKUP_DIR%\backup_log.txt"

REM Create files in the TestFiles directory
echo This is the first test file. > "%SOURCE%\file1.txt"
echo This is the second test file. > "%SOURCE%\file2.txt"
echo This is the third test file. > "%SOURCE%\file3.txt"


REM Create backup directory if it doesn't exist
if not exist "%BACKUP_DIR%" (
    mkdir "%BACKUP_DIR%"
)

REM Copy files from source to backup directory
set "FILE_COUNT=0"
for %%F in ("%SOURCE%\*") do (
    copy "%%F" "%BACKUP_DIR%"
    if not errorlevel 1 (
        set /a FILE_COUNT+=1
    )
)

REM Log the backup information
(
    echo Backup Date: %date%
    echo Backup Time: %time%
    echo Number of files copied: %FILE_COUNT%
) >> "%LOG_FILE%"

REM Cleanup old backups (older than 7 days)
for /d %%D in ("%BACKUP_ROOT%\*") do (
    REM Get the last modified date of the directory
    forfiles /p "%%D" /d -7 >nul 2>&1
    if not errorlevel 1 (
        echo Deleting old backup: %%D
        rmdir /s /q "%%D"
    )
)

echo Backup completed successfully!
pause
