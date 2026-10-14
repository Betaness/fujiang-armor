@echo off
chcp 65001 >nul 2>&1
setlocal
title Fujiang Armor v0.4.4 Uninstaller
echo.
echo ============================================================
echo   Fujiang Armor v0.4.4 - One-click Uninstall
echo   Targets: DSH / Codex / OpenCode / WorkBuddy
echo ============================================================
echo.
echo This will remove Fujiang rules from all four targets below
echo (targets not installed are skipped automatically):
echo   1. DeepSeek Harness (DSH)
echo   2. OpenAI Codex
echo   3. OpenCode
echo   4. WorkBuddy
echo.
echo Backups are saved to %LOCALAPPDATA%\FujiangArmor\backup
echo Make sure you have FULLY EXITED these programs first.
echo Press any key to start...
pause >nul
echo.
if exist "%~dp0uninstall.ps1" goto run
echo [ERROR] uninstall.ps1 not found next to this launcher.
set "FUJIANG_UNINSTALL_RESULT=2"
goto finished

:run
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0uninstall.ps1"
set "FUJIANG_UNINSTALL_RESULT=%ERRORLEVEL%"

:finished
echo.
if not "%FUJIANG_UNINSTALL_RESULT%"=="0" (
    echo [ERROR] Uninstall failed. See the message above.
) else (
    echo [OK] Uninstall succeeded! Restart your target programs.
)
if not "%FUJIANG_UNINSTALL_NO_PAUSE%"=="1" pause
exit /b %FUJIANG_UNINSTALL_RESULT%
