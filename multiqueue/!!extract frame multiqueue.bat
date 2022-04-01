@echo off
set /p framenum=Frame num, starts at 0: 
SET mypath=%~dp0
for %%a in (%*) do (
     call "%mypath%!extract frame.bat" %%a %framenum%
)