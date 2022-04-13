@echo off
set /p fpsq=New FPS: 
SET mypath=%~dp0
for %%a in (%*) do (
     call "%mypath%!change fps.bat" %%a %fpsq%
)