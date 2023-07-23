:: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
:: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
:: You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

:: @froest on Discord
:: https://github.com/Thqrn/ffmpeg-scripts

:: upscaler

@echo off
setlocal enabledelayedexpansion

where /q ffmpeg.exe || (
    echo [91mERROR: You either don't have ffmpeg installed or don't have it in PATH.[0m
    echo Please install it as it's needed for this script to work.
    choice /n /c gc /m "Press [G] to open a guide on installing it, or [C] to close the script."
    if %errorlevel% == 1 start "" https://www.youtube.com/watch?v=WwWITnuWQW4
    exit
)

:: check if video exists
ffprobe -i %1 -show_streams -select_streams v -loglevel error > %temp%\vstream.txt
set /p vstream=<%temp%\vstream.txt
if exist "%temp%\vstream.txt" (del "%temp%\vstream.txt")
if 1%vstream% == 1 (
    echo "Input file does not have a video stream. Exiting..."
    pause
    exit
)

:: gets the resolution of the video
ffprobe -v error -select_streams v:0 -show_entries stream=width -i %1 -of csv=p=0 > %temp%\width.txt
ffprobe -v error -select_streams v:0 -show_entries stream=height -i %1 -of csv=p=0 > %temp%\height.txt
set /p height=<%temp%\height.txt
set /p width=<%temp%\width.txt
if exist "%temp%\height.txt" (del "%temp%\height.txt")
if exist "%temp%\width.txt" (del "%temp%\width.txt")

echo [1] Nearest Neighbor / Point
echo [2] Bicubic
echo [3] Bilinear
echo [4] Lanczos
echo [5] XBR
echo [6] HQX
echo [7] Area
echo [8] Bicublin
echo [9] Gauss
echo [0] Sinc
echo [Q] Spline
choice /c 1234567890Q /n /m "Select a scaling algorithm: "
set ch=%errorlevel%
if %ch% == 1 set scaler=neighbor
if %ch% == 2 set scaler=bicubic
if %ch% == 3 set scaler=bilinear
if %ch% == 4 set scaler=lanczos
if %ch% == 5 set scaler=xbr
if %ch% == 6 set scaler=hqx
if %ch% == 7 set scaler=area
if %ch% == 8 set scaler=bicublin
if %ch% == 9 set scaler=gauss
if %ch% == 10 set scaler=sinc
if %ch% == 11 set scaler=spline

cls

set pixel=0
if %scaler%==xbr set pixel=1
if %scaler%==hqx set pixel=1

if %pixel%==0 (
    echo [1] 1080p
    echo [2] 1440p
    echo [3] 4K or 2160p
    echo [4] 8K or 4320p
    choice /c 1234 /n /m "Resolution: "
    if !errorlevel!==1 set res=1920
    if !errorlevel!==1 set selectres=1080p
    if !errorlevel!==2 set res=2560
    if !errorlevel!==2 set selectres=1440p
    if !errorlevel!==3 set res=3840
    if !errorlevel!==3 set selectres=4K
    if !errorlevel!==4 set res=7680
    if !errorlevel!==4 set selectres=8K
) else (
    set /a height2=%height%*2
    set /a width2=%width%*2
    set /a height3=%height%*3
    set /a width3=%width%*3
    set /a height3=%height%*4
    set /a width3=%width%*4
    echo [2] 2x input %width2%x%height2%
    echo [3] 3x input %width3%x%height3%
    echo [4] 4x input %width4%x%height4%
    choice /c 234 /n /m "Resolution: "
    if !errorlevel!==1 set res=2
    if !errorlevel!==2 set res=3
    if !errorlevel!==3 set res=4
)

cls

echo [1] NVENC (NVIDIA GPU Encoder)
echo [2] CPU (x264, most compatible)
echo [3] AMF (AMD GPU Encoder)
echo [4] Quicksync (Intel iGPU Encoder)
choice /c 1234 /n /m "Select an encoder: "
set ch=%errorlevel%
if %ch% == 1 set encodingargs=-c:v h264_nvenc -preset p7 -rc vbr -b:v 250M -cq 14
if %ch% == 2 set encodingargs=-c:v libx264 -preset slow -crf 17 -aq-mode 3
if %ch% == 3 set encodingargs=-c:v h264_amf -quality quality -qp_i 16 -qp_p 18 -qp_b 22
if %ch% == 4 set encodingargs=-c:v h264_qsv -preset veryslow -global_quality:v 15

cls

if %pixel%==0 (
    for %%a in (%*) do (
        set filename=%%~dpna ^(%selectres%^)
        if exist "!filename!.mp4" call :renamefile "!filename!"
        echo ffmpeg -stats_period 0.05 -hide_banner -loglevel error -stats -i %%a -vf "scale=%res%:-2:flags=%scaler%,setsar=1:1" %encodingargs% -c:a copy "!filename!.mp4"
        ffmpeg -stats_period 0.05 -hide_banner -loglevel error -stats -i %%a -vf "scale=%res%:-2:flags=%scaler%,setsar=1:1" %encodingargs% -c:a copy "!filename!.mp4"
    )
) else (
    for %%a in (%*) do (
        set filename=%%~dpna ^(%selectres%^)
        if exist "!filename!.mp4" call :renamefile "!filename!"
        echo ffmpeg -stats_period 0.05 -hide_banner -loglevel error -stats -i %%a -vf "%scaler%=%res%" %encodingargs% -c:a copy "!filename!.mp4"
        ffmpeg -stats_period 0.05 -hide_banner -loglevel error -stats -i %%a -vf "%scaler%=%res%" %encodingargs% -c:a copy "!filename!.mp4"
    )
)

where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit


:renamefile
:: start of the repeat until loop (repeats until the file doesn't exist)
:renamefileloop
echo %filename%
set /a "i+=1"
if exist "%filename% (%i%).mp4" goto renamefileloop
set "filename=%filename% (%i%)"
goto :eof