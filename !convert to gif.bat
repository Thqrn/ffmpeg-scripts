:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts

@echo off
choice /c me /n /m "Press [m] to remux (faster) or [e] to reencode (slower)" 
if %errorlevel% == 1 goto remux
set /p scale=Amount to scale down by: 
set /p fps=Frames per second: 
for %%a in (%*) do (
    call :conversion %%a
)
echo.
echo [92mDone![0m
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit

:remux
for %%a in (%*) do ffmpeg -stats_period 0.05 -hide_banner -loglevel error -stats -i %%a -f gif "%%~dpna.gif"
echo.
echo [92mDone![0m
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit

:conversion
ffprobe -v error -select_streams v:0 -show_entries stream=width -i %1 -of csv=p=0 > %temp%\width.txt
ffprobe -v error -select_streams v:0 -show_entries stream=height -i %1 -of csv=p=0 > %temp%\height.txt
set /p height=<%temp%\height.txt
set /p width=<%temp%\width.txt
if exist "%temp%\height.txt" (del "%temp%\height.txt")
if exist "%temp%\width.txt" (del "%temp%\width.txt")
set /a height=%height%/%scale%
set /a width=%width%/%scale%
set /a height=(%height%/2)*2
set /a width=(%width%/2)*2
set "filters=scale=%width%:%height%:flags=lanczos,fps=%fps%"
if exist "%temp%\gifpalette.png" (del "%temp%\gifpalette.png")
if exist "%temp%\tempgifvideo.mp4" (del "%temp%\tempgifvideo.mp4")
cls
echo [1/3] [38;2;254;165;0mCreating color palette...[0m
ffmpeg -hide_banner -loglevel error -stats -i %1 -vf "%filters%,palettegen=stats_mode=diff" -y "%temp%\gifpalette.png"
cls
echo [2/3] [38;2;254;165;0mEncoding to a compatible format...[0m
ffmpeg -hide_banner -loglevel error -stats -i %1 -vf "%filters%" -pix_fmt rgb24 -c:v libx264 -crf 15 -f h264 "%temp%\tempgifvideo.mp4"
cls
echo [3/3] [38;2;254;165;0mMaking the output into a gif...[0m
ffmpeg -stats_period 0.1 -hide_banner -loglevel error -stats -i %1 -i "%temp%\gifpalette.png" -an -lavfi "%filters%,paletteuse=dither=sierra2_4a" -f gif -y "%~dpn1.gif"
if exist "%temp%\gifpalette.png" (del "%temp%\gifpalette.png")
if exist "%temp%\tempgifvideo.mp4" (del "%temp%\tempgifvideo.mp4")
goto :eof