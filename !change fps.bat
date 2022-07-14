:: made by Frost#5872
:: https://github.com/Thqrn/ffmpeg-scripts
@echo off
set /p fpsq=New FPS: 
for %%a in (%*) do ffmpeg -i %%a -vf "fps=%fpsq%" -c:v libx264 -preset slower -x264-params aq-mode=3 -crf 17 -c:a copy "%%~dpna (%fpsq% FPS).mp4"
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit