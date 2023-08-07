:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: Copyright 2023 Thqrn. Licensed under the GNU General Public License v3.0.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts

:: this script is made to remove the corner of minecraft capes that don't have transparent corners

@echo off
if not exist "ALPHAMAP.png" (curl -s -o "ALPHAMAP.png" https://i.ibb.co/T2kT08c/ALPHAMAP.png > nul) 
for %%a in (%*) do call :capescale %%a
if exist "ALPHAMAP.png" (del "ALPHAMAP.png")
exit

:capescale
set inputvideo=%1
ffprobe -v error -select_streams v:0 -show_entries stream=width -i %inputvideo% -of csv=p=0 > %temp%\width.txt
ffprobe -v error -select_streams v:0 -show_entries stream=height -i %inputvideo% -of csv=p=0 > %temp%\height.txt
set /p height=<%temp%\height.txt
set /p width=<%temp%\width.txt
if exist "%temp%\height.txt" (del "%temp%\height.txt")
if exist "%temp%\width.txt" (del "%temp%\width.txt")
ffmpeg -i ALPHAMAP.png -vf "scale=%width%:%height%:flags=neighbor,setsar=1:1" "ALPHAMAP (scaled to %width%x%height%).png"
ffmpeg -i %inputvideo% -i "ALPHAMAP (scaled to %width%x%height%).png" -filter_complex "alphamerge" "%~dpn1 (fixed)%~x1"
if exist "ALPHAMAP (scaled to %width%x%height%).png" (del "ALPHAMAP (scaled to %width%x%height%).png")
goto :eof