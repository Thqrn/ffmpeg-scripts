@echo off
set /p desired=What fps do you want to interpolate from? The lower this value is, the worse the output looks: 
set /p intnum=What do you want to interpolate to: 
SET mypath=%~dp0
for %%a in (%*) do (
     call "%mypath%!interpolater.bat" %%a %desired% %intnum%
)