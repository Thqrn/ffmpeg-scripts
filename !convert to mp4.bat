@echo off
choice /c me /n /m "Press [m] to remux (faster) or [e] to reencode (slower)" 
if %errorlevel% == 1 for %%a in (%*) do ffmpeg -stats_period 0.05 -hide_banner -loglevel error -stats -i %%a -c copy "%%~dpna.mp4"
if %errorlevel% == 2 for %%a in (%*) do ffmpeg -stats_period 0.05 -hide_banner -loglevel error -stats -i %%a -c:v libx264 -preset slow -crf 17 -aq-mode 3 -c:a aac -b:a 256k "%%~dpna.mp4"
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit