:: made by Frost#5872
:: https://github.com/Thqrn/ffmpeg-scripts
@echo off
set /p lowqualmusic=Please drag the desired file here, it must be an audio file: 
set /p musicstarttime=Enter a specific start time of the music in seconds: 
for %%a in (%*) do ffmpeg -loglevel warning -stats -i %%a -ss %musicstarttime% -i %lowqualmusic% -c:v copy -preset slow -c:a aac -map 0:v:0 -map 1:a:0 -shortest "%%~dpna (added audio).mp4"
where /q ffplay || exit
if not exist "C:\Windows\Media\notify.wav" (exit) else ffplay "C:\Windows\Media\notify.wav" -volume 50 -autoexit -showmode 0 -loglevel quiet
exit