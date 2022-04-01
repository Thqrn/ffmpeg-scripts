@echo off
SET mypath=%~dp0
for %%a in (%*) do (
     call "%mypath%!blur auto audio fix" %%a
)