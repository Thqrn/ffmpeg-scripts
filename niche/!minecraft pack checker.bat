:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts

:: this script checks if a (unzipped) minecraft texture pack contains a pack.png and pack.mcmeta file
:: if pack.png is more than 64x64 in resolution, it is downscaled to 64x64
:: it also logs which packs are missing things

@echo off
cd /d "%~dp1"
for %%a in (%*) do (
    call :func %%a
)
pause
exit

:func
set haspng=false
set hasmcmeta=false
set currentfolder="%~1"
if exist "%~1\pack.png" set haspng=true
if exist "%~1\pack.mcmeta" set hasmcmeta=true
if %haspng%%hasmcmeta% == truefalse (
    echo missing pack.mcmeta: "%~n1" >> packsandfolderslog.txt
)
if %haspng%%hasmcmeta% == falsetrue (
    echo missing pack.png: "%~n1" >> packsandfolderslog.txt
    goto :eof
)
if %haspng%%hasmcmeta% == falsefalse (
    echo missing pack.png AND pack.mcmeta: "%~n1" >> packsandfolderslog.txt
    goto :eof
)
ffprobe -v error -select_streams v:0 -show_entries stream=width -i "%~1\pack.png" -of csv=p=0 > %temp%\width.txt
set /p width=<%temp%\width.txt
if exist "%temp%\width.txt" (del "%temp%\width.txt")
if %width% gtr 64 (
    ren "%~1\pack.png" pack1.png
    ffmpeg -hide_banner -loglevel error -stats -i "%~1\pack1.png" -vf scale=64:64:flags=bicubic "%~1\pack.png"
    del "%~1\pack1.png"
)
goto :eof