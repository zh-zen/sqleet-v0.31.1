@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0decrypt-folder.ps1"
exit /b %ERRORLEVEL%
