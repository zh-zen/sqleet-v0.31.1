@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0decrypt-folder.ps1"
set "EXIT_CODE=%ERRORLEVEL%"
if not "%EXIT_CODE%"=="0" (
  echo.
  echo Script failed with exit code %EXIT_CODE%.
  echo Press any key to close this window.
  pause >nul
)
exit /b %EXIT_CODE%
