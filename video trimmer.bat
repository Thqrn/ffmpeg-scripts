:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: Copyright 2023 Thqrn. Licensed under the GNU General Public License v3.0.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts

@echo off

where /q ffmpeg.exe || (
    echo [91mERROR: You either don't have ffmpeg installed or don't have it in PATH.[0m
    echo Please install it as it's needed for this script to work.
    choice /n /c gc /m "Press [G] to open a guide on installing it, or [C] to close the script."
    if %errorlevel% == 1 start "" https://www.youtube.com/watch?v=WwWITnuWQW4
    exit
)

set /p "start=Start time (in seconds): "
set /p "duration=Duration of video after start: "
if not defined start set start=0
if not defined duration set duration=99999999999
set /a end=%start%+%duration%

choice /c ce /n /m "Press [c] to copy streams (faster) or [e] to reencode them (slower)" 
if %errorlevel% == 1 for %%a in (%*) do call :copy %%a
if %errorlevel% == 2 call :reenc %*
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit

:copy
ffmpeg -stats_period 0.05 -hide_banner -loglevel error -stats -ss %start% -t %duration% -i %1 -c copy "%~dpn1 (%start%-%end%)%~x1"
goto :eof

:reenc
echo [N]VENC
echo [C]PU
echo [A]MF
echo [Q]uicksync
choice /c NCAQ /n /m "Select an encoder: "
set ch=%errorlevel%
if %ch% == 1 for %%a in (%*) do ffmpeg -stats_period 0.05 -hide_banner -loglevel error -stats -ss %start% -t %duration% -i %%a -c:v h264_nvenc -preset p7 -rc vbr -b:v 250M -cq 14 -c:a aac -b:a 256k "%%~dpna (%start%-%end%).mp4"
if %ch% == 2 for %%a in (%*) do ffmpeg -stats_period 0.05 -hide_banner -loglevel error -stats -ss %start% -t %duration% -i %%a -c:v libx264 -preset slow -crf 17 -aq-mode 3 -c:a aac -b:a 256k "%%~dpna (%start%-%end%).mp4"
if %ch% == 3 for %%a in (%*) do ffmpeg -stats_period 0.05 -hide_banner -loglevel error -stats -ss %start% -t %duration% -i %%a -c:v h264_amf -quality quality -qp_i 16 -qp_p 18 -qp_b 22 -c:a aac -b:a 256k "%%~dpna (%start%-%end%).mp4"
if %ch% == 4 for %%a in (%*) do ffmpeg -stats_period 0.05 -hide_banner -loglevel error -stats -ss %start% -t %duration% -i %%a -c:v h264_qsv -preset veryslow -global_quality:v 15 -c:a aac -b:a 256k "%%~dpna (%start%-%end%).mp4"
goto :eof