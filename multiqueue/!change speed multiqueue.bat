@echo off
set /p speedq=What speed do you want the video (0.5 to 100): 
SET mypath=%~dp0
for %%a in (%*) do (
     call "%mypath%!change speed.bat" %%a %speedq%
)