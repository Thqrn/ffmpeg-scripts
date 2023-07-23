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

echo.
echo Trimming video from %start% seconds to %end% seconds...

ffmpeg -stats_period 0.05 -hide_banner -loglevel error -stats -ss %start% -t %time% -i %1 -c copy "%~dpn1 (%start%-%end%)%~x1"

where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit