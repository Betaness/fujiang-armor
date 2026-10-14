@echo off
chcp 65001 >nul 2>&1
setlocal
title Fujiang Armor v0.4.4 Installer
echo.
echo ============================================================
echo   Fujiang Armor v0.4.4 - One-click Install
echo   Targets: DSH / Codex / OpenCode / WorkBuddy
echo ============================================================
echo.
echo This will configure all four targets below
echo (targets not installed are skipped automatically):
echo   1. DeepSeek Harness (DSH)
echo   2. OpenAI Codex
echo   3. OpenCode
echo   4. WorkBuddy
echo.
echo Make sure you have FULLY EXITED these programs first.
echo Press any key to start...
pause >nul
echo.
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
set "FUJIANG_INSTALL_RESULT=%ERRORLEVEL%"
echo.
if not "%FUJIANG_INSTALL_RESULT%"=="0" (
    echo [ERROR] Install failed. See the message above.
) else (
    echo [OK] Install succeeded! Restart your target programs and start a new session.
)
if not "%FUJIANG_INSTALL_NO_PAUSE%"=="1" pause
exit /b %FUJIANG_INSTALL_RESULT%
