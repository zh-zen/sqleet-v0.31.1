@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0encrypt-folder.ps1"
exit /b %ERRORLEVEL%
