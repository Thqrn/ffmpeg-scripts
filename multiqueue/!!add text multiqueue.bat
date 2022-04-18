@echo off
set "toptext= "
set /p toptext=Top text: 
set "bottomtext= "
set /p bottomtext=Bottom text: 
set "toptext=%toptext: =SPACEHERE%"
set "bottomtext=%bottomtext: =SPACEHERE%"
SET mypath=%~dp0
for %%a in (%*) do (
     call "%mypath%!add text.bat" %%a %toptext% %bottomtext%
)