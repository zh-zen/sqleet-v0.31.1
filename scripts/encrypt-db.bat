@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0encrypt-db.ps1"
exit /b %ERRORLEVEL%
