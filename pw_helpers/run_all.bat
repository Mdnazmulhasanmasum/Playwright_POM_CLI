@echo off
setlocal
cd /d "%~dp0..\Playwright_POM_CLI"
set HELP=%~dp0
title Playwright_POM_CLI
echo ===== Checking Node.js =====
where node >nul 2>nul
if errorlevel 1 (
  echo NODE_MISSING > "%HELP%status.txt"
  echo Node.js is not installed. Install it from https://nodejs.org and run this again.
  pause
  exit /b 1
)
call node -v
call npm -v
echo ===== npm install =====
call npm install
echo ===== npx playwright install chromium =====
call npx playwright install chromium

cls
echo PS %CD%^> tree (project folder structure)
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%HELP%tree.ps1" "%CD%"
powershell -NoProfile -ExecutionPolicy Bypass -File "%HELP%shot.ps1" "%HELP%folder_structure.png"

cls
echo %CD%^> npm run test:login
call npm run test:login
set RC=%ERRORLEVEL%
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%HELP%shot.ps1" "%HELP%cli_run.png"
echo EXIT_CODE=%RC% > "%HELP%status.txt"

call npx playwright test tests/login.spec.js --project=chromium --reporter=line > "%HELP%test_output.txt" 2>&1

where git >nul 2>nul
if not errorlevel 1 (
  if not exist .git (
    git init -b main >nul 2>nul
    git add . >nul 2>nul
    git commit -m "Playwright POM framework for Sauce Demo login (data-driven)" >nul 2>nul
  )
)
echo.
echo ===== DONE =====
pause
