@echo off
set /p lowqualmusic=Please drag the desired file here, it must be an audio file: 
set /p musicstarttime=Enter a specific start time of the music in seconds: 
for %%a in (%*) do ffmpeg -loglevel warning -stats -i %%a -ss %musicstarttime% -i %lowqualmusic% -c:v copy -preset slow -c:a aac -map 0:v:0 -map 1:a:0 -shortest "%%~dpna (added audio).mp4"